#!/usr/bin/env bash

{
  declare -p ews || declare -A ews=([base]="${0%/*}" [exec]="${0}" [levl]=1 \
      [name]='Calc' [sign]='u3r8 by Brendon, 12/31/2022.' \
      [desc]='Bash arithmetic frontend. https://ed7n.github.io/calc')
} &> /dev/null

# Undo stack size.
readonly CLC_EXL=8

# Manual pages.
readonly -a CLC_MANS=(
'——About
Calc is a frontend to Bash'"'"'s arithmetic feature. As such, evaluations are
done in fixed-width integers with no check for overflow.

Each input line is part of an expression, which is to be evaluated with either a
`=` or `eval` input. Evaluations are done in isolation, so assignments do not
carry over.

More information can be found in its homepage: [https://ed7n.github.io/calc]'

'——Calc Functions
Enter these individually in a separate line.
      ac      Clears expression and last result.
      ans     Inserts last result.
      clr     Clears expression.
      cls     Clears screen.
      copy    Inserts expression.
   =, eval    Evaluates expression.
      fps     Toggles fractional precision for simple divisions.
   ?, help    Prints this function reference.
      man     Prints manual pages.
   p, peek    Previews evaluation of expression.
      pre     Toggles input prepending.
      quit    Quits program.
      rand    Inserts a random number within [0, 32767].
   m, rcl     Inserts saved result.
  rd, redo    Redoes last change to expression.
  ps, stat    Prints calculator state.
      sto     Saves last result to memory.
  ud, undo    Undoes last change to expression.
      vars    Prints program variables.'

'——Bash Arithmetic Operators [1/2]
Operators and their precedence, associativity, and values are the same as those
in C. The following operators are grouped by levels of equal-precedence
operators. The levels are listed in order of decreasing precedence.

  x++ x--     Variable post-increment and -decrement
  ++x --x     Variable  pre-increment and -decrement
  - +         Unary minus and plus
  ! ~         Logical and bitwise negation
  **          Exponentiation
  * / %       Multiplication, division, remainder
  + -         Addition, subtraction
  << >>       Left and right bitwise shifts
  <= >= < >   Comparison
  == !=       Equality and inequality
  &           Bitwise AND
  ^           Bitwise exclusive OR
  |           Bitwise OR
  &&          Logical AND
  ||          Logical OR'

'——Bash Arithmetic Operators [2/2]
Conditional Operator
  <cond.> ? <expr. if true> : <expr. if false>

Assignment
  = *= /= %= += -= <<= >>= &= ^= |=

Comma
  <expr.> , <expr.>

Sub-expressions in parentheses are evaluated first and may override the
precedence rules above.'

'——Numerical Notations
The following lists common representations of the number ten.

  10    base-10 "decimal"
  0XA
  0xA   base-16 "hexadecimal"
  012   base-8  "octal"

Otherwise, numbers take the form `[base#]n`, where the optional `base#` is a
decimal number between 2 and 64 representing the arithmetic base, and `n` is a
number in that base.

When specifying `n`, if a non-digit is required, then the digits greater than 9
are represented by the lowercase letters, the uppercase letters, '"'@'"', and
'"'_'"', in that order. If `base#` is less than or equal to 36, then lowercase
and uppercase letters may be used interchangeably to represent numbers between
10 and 35.'
)
# Undo stack.
declare -a clcExs
# Answer.
clcAns=0
# Undo stack tail index.
clcExi=0
# Undo stack cursor index.
clcExj=0
# Undo stack head index.
clcExk=0
# Fractional precision flag.
clcFps='fps'
# Memory.
clcMem=0
# Nul variable.
clcNul=
# Input prepending flag.
clcPre=
# For use in array iterations.
IFS=' '

# Clears expression, and answer with `$@`.
clr() {
  exin 'all'
  clcExs[${clcExj}]=
  (( ${#} )) && {
    clcAns=0
    echo -n 'All' || :
  } || echo -n 'Expression'
  echo ' cleared.'
}

# Divides `$2` by `$3` with fractional precision to `$1`.
div() {
  (( ${3} )) || {
    echo 'Division by zero.'
    return 1
  }
  [ "${1}" == 'clcOut' ] || local -n clcOut="${1}"
  local clcDdv=$(( ${2} )) clcDsv=$(( ${3} ))
  local clcDdm="${clcDdv#-}" clcDsm="${clcDsv#-}"
  local clcFra=$(( clcDdm % clcDsm )) clcZro
  while [ $(( clcFra * 10 )) == "${clcFra}"'0' ]; do
    (( clcFra *= 10 ))
    (( clcFra < clcDsm )) && clcZro+='0'
  done
  (( clcDdm < clcDsm && ${clcDdv:0:1}1 * ${clcDsv:0:1}1 < 0 )) && {
    clcOut='-' || :
  } || clcOut=
  clcOut+=$(( clcDdv / clcDsv ))
  (( clcFra )) && {
    (( clcFra /= clcDsm ))
    clcOut+='.'"${clcZro}${clcFra%%+(0)}"
  }
}

# Evaluates expression and prints its result, and saves them with `$@`.
evl() {
  local clcOut
  exev clcOut && {
    (( ${#} )) && {
      clcAns="${clcOut%%.*}"
      [ "${clcAns}" == '-0' ] && clcAns=0
      exin 'all'
      clcExs[${clcExj}]=
    }
    echo "${clcOut}"
  }
}

# Concatenates `$REPLY` to expression.
excn() {
  ins "${REPLY}"
  local clcExp="${clcExs[${clcExj}]}"
  (( ${#clcExp} )) && {
    (( ${#clcPre} )) && {
      clcExp="${REPLY}"' '"${clcExp}" || :
    } || clcExp+=' '"${REPLY}" || :
  } || clcExp="${REPLY}"
  exin 'all'
  clcExs[${clcExj}]="${clcExp}"
}

# Decrements undo stack cursor index.
exdc() {
  (( clcExj )) && {
    (( clcExj-- )) || :
  } || (( clcExj = CLC_EXL - 1 ))
}

# Increments undo stack cursor index, and head and tail indeces with `$@`.
exin() {
  (( clcExj = (clcExj + 1) % CLC_EXL ))
  (( ${#} )) && {
    (( clcExi == clcExj && (clcExi = (clcExi + 1) % CLC_EXL) ))
    clcExk="${clcExj}"
  }
}

# Evaluates expression to `$1`.
exev() {
  [ "${1}" == 'clcOut' ] || local -n clcOut="${1}"
  (( ${#clcFps} )) \
      && [[ "${clcExs[${clcExj}]}" == ?([+-])+([[:digit:]])*([[:space:]])/*([[:space:]])?([+-])+([[:digit:]]) ]] \
      && {
    div clcOut "${clcExs[${clcExj}]%%*([[:space:]])/*}" \
        "${clcExs[${clcExj}]##*/*([[:space:]])}" || :
  } || clcOut="$(echo $(( clcExs[clcExj] )))"
}

# Toggles fractional precision for simple divisions.
fps() {
  echo -n 'Simple divisions will be evaluated '
  (( ${#clcFps} )) && {
    clcFps=
    echo -n 'integrally' || :
  } || {
    clcFps='fps'
    echo -n 'fractionally'
  }
  echo '.'
}

# Substitutes key `$1` into `$REPLY`.
ins() {
  case "${1}" in
    'ans' )
      REPLY="${clcAns}" ;;
    'm' | 'rcl' )
      REPLY="${clcMem}" ;;
    'rand' )
      REPLY="${RANDOM}" ;;
    'copy' )
      REPLY="${clcExs[${clcExj}]}" ;;
    * )
      return ;;
  esac
  echo '< '"${REPLY}"
}

# Prints all manual pages, or the second one with `$@`.
man() {
  (( ${#} )) && {
    echo "${CLC_MANS[1]}" || :
  } || {
    for clcIdx in $(eval echo "{0..$(( ${#CLC_MANS[@]} - 2 ))}"); do
      read -sp $'\n'"${CLC_MANS[${clcIdx}]}"$'\n\n[Enter] to continue.' clcNul
      echo -en '\r                    \r'
    done
    echo -e "${CLC_MANS[(( ${#CLC_MANS[@]} - 1 ))]}"'\n'
  }
}

# Prints calculator state, or all program variables with `$@`.
mon() {
  (( ${#} )) && {
    declare -p clcExs clcAns clcExi clcExj clcExk clcFps clcMem clcNul clcPre \
        IFS || :
  } || {
    echo -e 'fps: '"${clcFps}"'\npre: '"${clcPre}"'\nans: '"${clcAns}"'
mem: '"${clcMem}"'\nexp: '"${clcExs[${clcExj}]}"
  }
}

# Toggles input prepending.
pre() {
  echo -n 'Subsequent inputs will be '
  (( ${#clcPre} )) && {
    clcPre=
    echo -n 'appended' || :
  } || {
    clcPre='pre'
    echo -n 'prepended'
  }
  echo ' to the expression.'
}

# Saves last result to memory.
sto() {
  clcMem="${clcAns}"
  echo 'mem: '"${clcMem}"
}

# Undoes last change to expression.
udo() {
  [ "${clcExj}" == "${clcExi}" ] && {
    echo 'Reached the bottom of the undo stack.' || :
  } || {
    exdc
    echo 'Undid last change to expression.'
  }
}

# Redoes last change to expression.
rdo() {
  [ "${clcExj}" == "${clcExk}" ] && {
    echo 'Reached the top of the undo stack.' || :
  } || {
    exin
    echo 'Redid last change to expression.'
  }
}

shopt -q 'extglob' || shopt -qs 'extglob' || {
  echo '`extglob` shell option can not be set.'
  exit 1
}
[[ "${1}" == ?(-)?(-)[Hh]?([Ee][Ll][Pp]) ]] && {
  echo 'Usage: [<expression>]'
  exit 0
}
(( ${#} )) && {
  {
    REPLY="${@}"
    excn
    exev clcMem
    echo "${clcMem}"
    exit 0
  } || exit 1
}
echo -en '\033]2;'"${ews[name]}"'\007'
echo -e "${ews[name]}"' '"${ews[sign]}"'\n——'"${ews[desc]}"'\n
`help` for function reference.'
while true; do
  read -erp '> '
  REPLY="${REPLY%+([[:space:]])}"
  REPLY="${REPLY#+([[:space:]])}"
  (( ${#REPLY} )) || continue
  case "${REPLY}" in
    'ac' )
      clr 'ac' ;;
    'clr' )
      clr ;;
    'cls' )
      clear 2> /dev/null || {
        (( LINES )) && {
          eval printf '\\uA%.0s' "{1..${LINES}}" || :
        } || eval printf '\\uA%.0s' {1..24}
      } ;;
    '=' | 'eval' )
      evl 'ans' ;;
    'fps' )
      fps ;;
    '\?' | 'help' )
      man 'help' ;;
    'man' )
      man ;;
    'p' | 'peek' )
      evl ;;
    'pre' )
      pre ;;
    'quit' )
      echo -en '\033]2;\007'
      exit 0 ;;
    'rd' | 'redo' )
      rdo ;;
    'ps' | 'stat' )
      mon ;;
    'sto' )
      sto ;;
    'ud' | 'undo' )
      udo ;;
    'vars' )
      mon 'all' ;;
    * )
      excn ;;
  esac
done
