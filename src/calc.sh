#!/bin/env bash

{
  declare -p ews || declare -Ax ews=([base]="${0%/*}" [exec]="${0}" \
      [name]='Calc')
} &> /dev/null

# Undo stack size.
ews[exl]=4
# Header string.
ews[hdr]='Calc u3r4 by Brendon, 05/06/2022.
—An undependable calculator. https://github.com/ed7n/calc\n'
# Prompt string.
ews[pst]='> '

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
  (( dda < dsa && ${ddn:0:4} * ${dsn:0:4} < 0 )) && {
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
      ews[ans]="${out#-0}"
      ews[ans]="${ews[ans]%%.*}"
      [ "${ews[ans]}" ] || ews[ans]=0
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
  echo "${ews[pst]}""${REPLY}"
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

# Prints reference.
ref() {
  read -sp '——Functions
Enter these individually in a separate input.
      ac      Clears expression and last result.
      ans     Inserts last result.
      clr     Clears expression.
      cls     Clears screen.
      copy    Inserts expression.
   =, eval    Evaluates expression.
      fps     Toggles fractional precision for elementary divisions.
   ?, help    Prints this reference.
   p, peek    Previews evaluation of expression.
      pre     Toggles input prepending.
      quit    Quits program.
      rand    Inserts a random number within [0, 32767].
   m, rcl     Inserts saved result.
  rd, redo    Redoes last change to expression.
  ps, stat    Prints calculator state.
      sto     Saves last result to memory.
  ud, undo    Undoes last change to expression.
      vars    Prints program variables.
[Enter] to continue.'
  echo '

——Syntax
Operators are listed in order of decreasing precedence.
  ( )         Precedence grouping.
  x++ x--     Variable post-increment and -decrement
  ++x --x     Variable  pre-increment and -decrement
  -           Arithmetic negation
  ! ~         Logical and bitwise negation
  **          Exponentiation
  * / %       Multiplication, division, remainder
  + -         Addition, subtraction
  << >>       Bitwise shifts
  <= >= < >   Comparison
  == !=       Equality, inequality
  &           Bitwise AND
  ^           Bitwise XOR
  |           Bitwise OR
  &&          Logical AND
  ||          Logical OR

Conditional Operator
  <condition> ? <expr. if true> : <expr. if false>

Assignment
  = *= /= %= += -= <<= >>= &= ^= |=

Expression Separator
  <expr.> , <expr.>

The above is adapted from section 6.5 of the Bash Reference Manual.

Numerical Notation
  10    base-10 "decimal"
  0xA   base-16 "hexadecimal"
  012   base-8  "octal"'
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
echo -e "${ews[hdr]}"'\n`help` for reference.'
while true; do
  read -ep "${ews[pst]}"
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
      ref ;;
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
