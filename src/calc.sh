#!/bin/env bash

{
  declare -p ews || declare -Ax ews=([base]="${0%/*}" [exec]="${0}" \
      [name]='Calc')
} &> /dev/null

# Undo stack size.
ews[exl]=4
# Header string.
ews[hdr]='Calc u3r5 by Brendon, 05/07/2022.
—An undependable calculator. https://github.com/ed7n/calc\n'
# Help text set.
declare -ar HTXS=(
'——About
Calc is a frontend to Bash'"'"'s arithmetic feature. As such, evaluations are
done in fixed-width integers with no check for overflow.

Inputs are space-delimited parts of an expression, which is to be evaluated with
either a `=` or `eval` input.

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
   ?, help    Prints this help text.
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
  ex["${ews[exj]}"]=''
  [ "${1}" ] && {
    ews[ans]=0
    echo -n 'All' || :
  } || echo -n 'Expression'
  echo ' cleared.'
}

# Divide `$2` by `$3` with fractional precision to variable `$1`.
div() {
  (( ${3} )) || {
    echo 'Division by zero.'
    return 1
  }
  [ "${1}" == 'out' ] || local -n out="${1}"
  local ddn=$(( ${2} )) dsn=$(( ${3} ))
  local dda="${ddn#-}" dsa="${dsn#-}"
  local fra=$(( dda % dsa )) zro=''
  while [ $(( fra * 10 )) == "${fra}"'0' ]; do
    (( fra *= 10 ))
    (( fra < dsa )) && zro="${zro}"'0'
  done
  (( dda < dsa && ${ddn:0:1}1 * ${dsn:0:1}1 < 0 )) && {
    out='-' || :
  } || out=''
  out="${out}"$(( ddn / dsn ))
  (( fra )) && {
    (( fra /= dsa ))
    out="${out}"'.'"${zro}${fra%%+(0)}"
  }
}

# Evaluates expression and prints its result, and saves them with a truthy `$1`.
evl() {
  local out
  exev out && {
    [ "${1}" ] && {
      ews[ans]="${out%%.*}"
      [ "${ews[ans]}" == '-0' ] && ews[ans]=0
      exin 'all'
      ex["${ews[exj]}"]=''
    }
    echo "${out}"
  }
}

# Concatenates `REPLY` to expression.
excn() {
  ins "${REPLY}"
  local exp="${ex[${ews[exj]}]}"
  [ "${exp}" ] && {
    [ "${ews[pre]}" ] && {
      exp="${REPLY}"' '"${exp}" || :
    } || exp="${exp}"' '"${REPLY}" || :
  } || exp="${REPLY}"
  exin 'all'
  ex["${ews[exj]}"]="${exp}"
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
  [ "${1}" == 'out' ] || local -n out="${1}"
  [ "${ews[fps]}" ] \
      && [[ "${ex[${ews[exj]}]}" == ?([+-])+([[:digit:]])*([[:space:]])/*([[:space:]])?([+-])+([[:digit:]]) ]] \
      && {
    div out "${ex[${ews[exj]}]%%*([[:space:]])/*}" \
        "${ex[${ews[exj]}]##*/*([[:space:]])}" || :
  } || out=$(echo $(( ex[ews[exj]] )))
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

# Prints help text.
hlp() {
  for idx in $(eval echo {0..$(( ${#HTXS[*]} - 1 ))}); do
    read -sp '
'"${HTXS[${idx}]}"'

[Enter] to continue.'
    echo
  done
  echo
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
      REPLY="${ex[${ews[exj]}]}" ;;
    * )
      return ;;
  esac
  echo '< '"${REPLY}"
}

# Prints calculator state, and all other program variables with a truthy `$1`.
mon() {
  echo 'fps: '"${ews[fps]}"'
pre: '"${ews[pre]}"'
ans: '"${ews[ans]}"'
mem: '"${ews[mem]}"
  [ "${1}" ] && {
    for idx in $(eval echo {0..$(( ${#ex[*]} - 1 ))}); do
      echo 'ex'"${idx}"': '"${ex[${idx}]}"
    done
    echo 'exi: '"${ews[exi]}"'
exj: '"${ews[exj]}"'
exk: '"${ews[exk]}" || :
  } || echo 'exp: '"${ex[${ews[exj]}]}"
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

[[ "${1}" == ?(-)?(-)[Hh]?([Ee][Ll][Pp]) ]] && {
  echo -e "${ews[hdr]}"'\nUsage: [<expression>]'
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
  ex[(( ews[exj]++ ))]=''
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
echo -e "${ews[hdr]}"'\n`help` for help text.'
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
      clear 2> /dev/null || eval printf '\\u000A%.0s' {1..${LINES:-24}} ;;
    '=' | 'eval' )
      evl 'ans' ;;
    'fps' )
      fps ;;
    '\?' | 'help' )
      hlp ;;
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
