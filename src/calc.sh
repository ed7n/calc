#!/bin/bash

# Undo stack size.
exl=4
# Prompt string.
pst='calc> '

# Prints header.
echd() {
  echo -e 'Calc u3r3 by Brendon, 09/13/2021.
—An undependable calculator. https://github.com/ed7n/calc\n'
}

# Prints usage.
ecus() {
  echo 'Usage: [<expression>]'
}

# Clears expression, and answer with a truthy `$1`.
clr() {
  exin
  ex[$exj]=
  [[ "$1" ]] && { ans=0 ; echo 'All Cleared.' ; } || echo 'Expression cleared.'
}

# Returns field `$2` of `$1` delimited by `/`.
cutd() {
  cuts "$1" '/' "$2"
}

# Returns field `$2` of `$1` delimited by `.`.
cutf() {
  cuts "$1" '.' "$2"
}

# Returns field `$3` of `$1` delimited by `$2`.
cuts() {
  echo -n "$1" | cut -d "$2" -f "$3"
}

# Divide `$1` by `$2` with fractional precision.
div() {
  (( $2 )) || { echo 'Division by zero.' ; return 1 ; }
  acc=$(( $1 % $2 ))
  [[ $(( acc * 10 )) == "$acc"'0' ]] || { out=$(( $1 / $2 )) ; return ; }
  rg0=
  rg1=
  while true; do
    (( acc *= 10 ))
    (( acc < $2 )) && rg1=$rg1'0'
    [[ $(( acc * 10 )) == "$acc"'0' ]] || break
  done
  (( acc /= $2 ))
  (( acc < 0 )) && { (( acc *= -1 )) ; (( $1 < $2 )) && rg0=- ; }
  out=$rg0$(( $1 / $2 )).$rg1$acc
}

# Evaluates expression and prints its result, and saves them with a truthy `$1`.
evl() {
  exev || return
  [[ "$1" ]] && { ans=$(cutf "$out" '1') ; exin ; ex[$exj]= ; }
  echo ' ans: '"$out"
}

# Concatenates input to expression.
excn() {
  ins "$inp"
  [[ "${ex[$exj]}" ]] && { [[ "$pre" == '1' ]] \
      && acc="$inp ${ex[$exj]}" \
      || acc="${ex[$exj]} $inp" ; } \
      || acc=$inp
  exin
  ex[$exj]=$acc
}

# Decrements undo stack cursor index.
exdc() {
  [[ "$exj" == '0' ]] && exj=$(( exl - 1 )) || (( exj-- ))
}

# Evaluates expression to output.
exev() {
  [[ "$fps" == '1' ]] \
      && [[ "$(exp)" == *([[:space:]])*(-)+([[:digit:]])*([[:space:]])/*([[:space:]])*(-)+([[:digit:]])*([[:space:]]) ]] \
      && { div "$(cutd "$(exp)" '1')" "$(cutd "$(exp)" '2')" || return ; } \
      || out=$(echo $(( $(exp) )))
}

# Increments undo stack cursor index, and head and tail indeces with a falsy
# `$1`.
exin() {
  exj=$(( (exj + 1) % exl ))
  [[ "$1" ]] && return
  exk=$exj
  (( exi == exk )) && exi=$(( (exi + 1) % exl ))
}

# Echoes expression.
exp() {
  echo -n "${ex[$exj]}"
}

# Toggles fractional precision for simple divisions.
fps() {
  shopt -q 'extglob' || shopt -s 'extglob' \
      || { echo 'The `extglob` shell option can not be set.' ; return ; }
  echo -n 'Simple divisions will be evaluated '
  [[ "$fps" == '1' ]] \
      && { fps=0 ; echo -n 'integrally' ; } \
      || { fps=1 ; echo -n 'fractionally' ; }
  echo '.'
}

# Appends key `$1` to input.
ins() {
  case "$1" in
    ans ) inp=$ans ;;
    m | rcl ) inp=$mem ;;
    rand ) inp=$RANDOM ;;
    copy ) inp=$(exp) ;;
    * ) return ;;
  esac
  echo "$pst$inp"
}

# Prints calculator state, and all other program variables with a truthy `$1`.
mon() {
  [[ "$1" ]] || echo ' exp: '"$(exp)"
  echo ' ans: '"$ans"'
 mem: '"$mem"'
 pre: '"$pre"'
 fps: '"$fps"
  [[ "$1" ]] || return
  echo ' acc: '"$acc"
  acc=0
  until [[ "$acc" == "$exl" ]]; do
    echo ' ex'"$acc"': '"${ex[(( acc++ ))]}"
  done
  echo ' exi: '"$exi"'
 exj: '"$exj"'
 exk: '"$exk"'
 inp: '"$inp"'
 out: '"$out"'
 rg0: '"$rg0"'
 rg1: '"$rg1"
}

# Toggles input prepending.
pre() {
  echo -n 'Subsequent inputs will be '
  [[ "$pre" == '1' ]] \
      && { pre=0 ; echo -n 'appended' ; } \
      || { pre=1 ; echo -n 'prepended' ; }
  echo ' to the expression.'
}

# Redoes last change to expression.
rdo() {
  [[ "$exj" == "$exk" ]] \
      && { echo 'Reached the top of the undo stack.' ; return ; }
  exin 1
  echo 'Redid last change to expression.'
}

# Prints reference.
ref() {
  echo '——Functions
Enter these individually in a separate input.
      ac      Clears expression and last result.
      ans     Inserts last result.
      clr     Clears expression.
      cls     Clears screen.
      copy    Inserts expression.
   =, eval    Evaluates expression.
      fps     Toggles fractional precision for simple divisions.
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
      vars    Prints program variables.'
  read -sp '[Enter] to continue.'
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
  mem=$ans
  echo ' mem: '"$mem"
}

# Undoes last change to expression.
udo() {
  [[ "$exj" == "$exi" ]] \
      && { echo 'Reached the bottom of the undo stack.' ; return ; }
  exdc
  echo 'Undid last change to expression.'
}

[[ "$1" == "--help" ]] && { echd ; ecus ; exit 0 ; }
# Accumulator.
acc=
# Answer.
ans=0
# Undo stack tail index.
exi=0
# Undo stack cursor index.
exj=0
# Undo stack head index.
exk=0
# Fractional precision flag.
fps=0
# Input.
inp=
# Memory.
mem=0
# Output.
out=
# Input prepending flag.
pre=0
# Registers
rg0=
rg1=
until [[ "$exj" == "$exl" ]]; do
  ex[(( exj++ ))]=
done
exj=0
[[ "$@" ]] && { { inp=$@ ; excn ; exev ; exit 0 ; } || exit 1 ; }
echd
echo '`help` for reference.'
while true; do
  inp=
  read -ep "$pst" inp
  [[ "$inp" ]] || continue
  case "$inp" in
    ac ) clr 1 ;;
    clr ) clr ;;
    cls ) clear 2> /dev/null ;;
    = | eval ) evl 1 ;;
    fps ) fps ;;
    \? | help ) ref ;;
    p | peek ) evl ;;
    pre ) pre ;;
    quit ) exit 0 ;;
    rd | redo ) rdo ;;
    ps | stat ) mon ;;
    sto ) sto ;;
    ud | undo ) udo ;;
    vars ) mon 1 ;;
    * ) excn ;;
  esac
done
