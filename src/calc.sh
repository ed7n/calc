#!/bin/env bash

{
  declare -p ews || declare -Ax ews=([base]="${0%/*}" [exec]="${0}" [levl]=1 \
      [name]='Calc' [sign]='u3r7 by Brendon, 07/25/2022.' \
      [desc]='Bash arithmetic frontend. https://ed7n.github.io/calc')
} &> /dev/null

# Undo stack size.
ews[exl]=4
# Manual pages.
declare -ar CLC_MTXS=(
'——About
Calc is a frontend to Bash'"'"'s arithmetic feature. As such, evaluations are
done in fixed-width integers with no check for overflow.

Inputs are space-delimited parts of an expression, which is to be evaluated with
either a `=` or `eval` input. Evaluations are done in isolation, so variables do
not carry over--use the memory functions instead.

More information can be found in its homepage: [https://ed7n.github.io/calc]'

'——Calc Functions
Enter these individually in a separate input.
      ac      Clears expression and last result.
      ans     Inserts last result.
      clr     Clears expression.
      cls     Clears screen.
      copy    Inserts expression.
   =, eval    Evaluates expression.
      fps     Toggles fractional precision for elementary divisions.
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

'——Numerical Notation
Integer constants follow the C language definition, without suffixes or
character constants. The following lists common representations of the number
ten.

  10    base-10 "decimal"
  0XA
  0xA   base-16 "hexadecimal"
  012   base-8  "octal"

Otherwise, numbers take the form `[base#]n`, where the optional `base#` is a
decimal number between 2 and 64 representing the arithmetic base, and `n` is a
number in that base. If `base#` is omitted, then base 10 is used. When
specifying `n`, if a non-digit is required, the digits greater than 9 are
represented by the lowercase letters, the uppercase letters, '"'@'"', and
'"'_'"', in that order. If `base#` is less than or equal to 36, lowercase and
uppercase letters may be used interchangeably to represent numbers between 10
and 35.'
)

# Clears expression, and answer with a truthy `$1`.
clr() {
  exin 'all'
  clcExs["${ews[exj]}"]=''
  [ "${1}" ] && {
    ews[ans]=0
    echo -n 'All' || :
  } || echo -n 'Expression'
  echo ' cleared.'
}

# Divides `$2` by `$3` with fractional precision to variable `$1`.
div() {
  (( ${3} )) || {
    echo 'Division by zero.'
    return 1
  }
  [ "${1}" == 'clcOut' ] || local -n clcOut="${1}"
  local clcDdn=$(( ${2} )) clcDsn=$(( ${3} ))
  local clcDda="${clcDdn#-}" clcDsa="${clcDsn#-}"
  local clcFra=$(( clcDda % clcDsa )) clcZro=''
  while [ $(( clcFra * 10 )) == "${clcFra}"'0' ]; do
    (( clcFra *= 10 ))
    (( clcFra < clcDsa )) && clcZro="${clcZro}"'0'
  done
  (( clcDda < clcDsa && ${clcDdn:0:1}1 * ${clcDsn:0:1}1 < 0 )) && {
    clcOut='-' || :
  } || clcOut=''
  clcOut="${clcOut}"$(( clcDdn / clcDsn ))
  (( clcFra )) && {
    (( clcFra /= clcDsa ))
    clcOut="${clcOut}"'.'"${clcZro}${clcFra%%+(0)}"
  }
}

# Evaluates expression and prints its result, and saves them with a truthy `$1`.
evl() {
  local clcOut
  exev clcOut && {
    [ "${1}" ] && {
      ews[ans]="${clcOut%%.*}"
      [ "${ews[ans]}" == '-0' ] && ews[ans]=0
      exin 'all'
      clcExs["${ews[exj]}"]=''
    }
    echo "${clcOut}"
  }
}

# Concatenates `REPLY` to expression.
excn() {
  ins "${REPLY}"
  local clcExp="${clcExs[${ews[exj]}]}"
  [ "${clcExp}" ] && {
    [ "${ews[pre]}" ] && {
      clcExp="${REPLY}"' '"${clcExp}" || :
    } || clcExp="${clcExp}"' '"${REPLY}" || :
  } || clcExp="${REPLY}"
  exin 'all'
  clcExs["${ews[exj]}"]="${clcExp}"
}

# Decrements undo stack cursor index.
exdc() {
  (( ews[exj] )) && {
    (( ews[exj]-- )) || :
  } || ews[exj]=$(( ews[exl] - 1 ))
}

# Increments undo stack cursor index, and head and tail indeces with a truthy
# `$1`.
exin() {
  ews[exj]=$(( (ews[exj] + 1) % ews[exl] ))
  [ "${1}" ] && {
    ews[exk]="${ews[exj]}"
    (( ews[exk] == ews[exi] )) && ews[exi]=$(( (ews[exi] + 1) % ews[exl] ))
  }
}

# Evaluates expression to variable `$1`.
exev() {
  [ "${1}" == 'clcOut' ] || local -n clcOut="${1}"
  [ "${ews[fps]}" ] \
      && [[ "${clcExs[${ews[exj]}]}" == ?([+-])+([[:digit:]])*([[:space:]])/*([[:space:]])?([+-])+([[:digit:]]) ]] \
      && {
    div "${1}" "${clcExs[${ews[exj]}]%%*([[:space:]])/*}" \
        "${clcExs[${ews[exj]}]##*/*([[:space:]])}" || :
  } || clcOut="$(echo $(( clcExs[ews[exj]] )))"
}

# Toggles fractional precision for elementary divisions.
fps() {
  echo -n 'Elementary divisions will be evaluated '
  [ "${ews[fps]}" ] && {
    ews[fps]=''
    echo -n 'integrally' || :
  } || {
    ews[fps]='fps'
    echo -n 'fractionally'
  }
  echo '.'
}

# Appends key `$1` to input.
ins() {
  case "${1}" in
    'ans' )
      REPLY="${ews[ans]}" ;;
    'm' | 'rcl' )
      REPLY="${ews[mem]}" ;;
    'rand' )
      REPLY="${RANDOM}" ;;
    'copy' )
      REPLY="${clcExs[${ews[exj]}]}" ;;
    * )
      return ;;
  esac
  echo '< '"${REPLY}"
}

# Prints manual text.
man() {
  [ "${1}" ] && {
    echo "${CLC_MTXS[1]}" || :
  } || {
    for clcIdx in $(eval echo {0..$(( ${#CLC_MTXS[*]} - 2 ))}); do
      read -sp '                    ''
'"${CLC_MTXS[${clcIdx}]}"'

[Enter] to continue.'
      echo -en '\r'
    done
    echo -e "${CLC_MTXS[$(( ${#CLC_MTXS[*]} - 1 ))]}"'\n'
  }
}

# Prints calculator state, and all other program variables with a truthy `$1`.
mon() {
  echo 'fps: '"${ews[fps]}"'
pre: '"${ews[pre]}"'
ans: '"${ews[ans]}"'
mem: '"${ews[mem]}"
  [ "${1}" ] && {
    for clcIdx in $(eval echo {0..$(( ${#clcExs[*]} - 1 ))}); do
      echo 'ex'"${clcIdx}"': '"${clcExs[${clcIdx}]}"
    done
    echo 'exi: '"${ews[exi]}"'
exj: '"${ews[exj]}"'
exk: '"${ews[exk]}" || :
  } || echo 'exp: '"${clcExs[${ews[exj]}]}"
}

# Toggles input prepending.
pre() {
  echo -n 'Subsequent inputs will be '
  [ "${ews[pre]}" ] && {
    ews[pre]=''
    echo -n 'appended' || :
  } || {
    ews[pre]='pre'
    echo -n 'prepended'
  }
  echo ' to the expression.'
}

# Saves last result to memory.
sto() {
  ews[mem]="${ews[ans]}"
  echo 'mem: '"${ews[mem]}"
}

# Undoes last change to expression.
udo() {
  [ "${ews[exj]}" == "${ews[exi]}" ] && {
    echo 'Reached the bottom of the undo stack.' || :
  } || {
    exdc
    echo 'Undid last change to expression.'
  }
}

# Redoes last change to expression.
rdo() {
  [ "${ews[exj]}" == "${ews[exk]}" ] && {
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

echo -e "${ews[name]}"' '"${ews[sign]}"'\n——'"${ews[desc]}"'\n'
[[ "${1}" == ?(-)?(-)[Hh]?([Ee][Ll][Pp]) ]] && {
  echo 'Usage: [<expression>]'
  exit
}
# Answer.
ews[ans]=0
# Undo stack tail index.
ews[exi]=0
# Undo stack cursor index.
ews[exj]=0
# Undo stack head index.
ews[exk]=0
# Fractional precision flag.
ews[fps]='fps'
# Memory.
ews[mem]=0
# Input prepending flag.
ews[pre]=''
until (( ews[exj] == ews[exl] )); do
  clcExs[(( ews[exj]++ ))]=''
done
ews[exj]=0
[ "${*}" ] && {
  {
    REPLY="${@}"
    excn
    exev ews[mem]
    echo "${ews[mem]}"
    exit
  } || exit
}
echo '`help` for function reference.'
while true; do
  read -ep '> '
  REPLY="${REPLY%+([[:space:]])}"
  REPLY="${REPLY#+([[:space:]])}"
  [ "${REPLY}" ] || continue
  case "${REPLY}" in
    'ac' )
      clr 'ac' ;;
    'clr' )
      clr ;;
    'cls' )
      clear 2> /dev/null || eval printf '\\uA%.0s' {1..${LINES:-24}} ;;
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
