#!/bin/bash

epl=34
pst='calc> '

head() {
  echo -e 'Calc u3r0 by Brendon, 05/01/2021.
—An undependable calculator. https://github.com/ed7n/calc\n'
}

clr() {
  exp=
  row=1
  bex=
  bro=1
  [[ "$1" ]] && { ans=0 ; echo 'All Cleared.' ; } || echo 'Expression cleared.'
}

con() {
  case "$inp" in
    ans | mem | copy | rand ) ins "$inp" ;;
  esac
  bex=$exp
  [[ "$exp" ]] \
      && { (( $pre )) && exp="$inp $exp" || exp="$exp $inp" ; } || exp=$inp
  bro=$row
  (( row++ ))
}

ecut() {
  echo -n "$exp" | cut -d '/' -f "$1"
}

eval() {
  out=$(echo $(( $exp ))) || return
  [[ "$1" ]] || ans=$out
  (( $ext )) \
      && [[ "$exp" == *([[:space:]])*(-)+([[:digit:]])*([[:space:]])/*([[:space:]])*(-)+([[:digit:]])*([[:space:]]) ]] \
      && exdv
  echo ' ans: '"$out"
  [[ "$1" ]] || { bex=$exp ; exp= ; bro=$row ; row=1 ; }
}

exdv() {
  tmp=$(ecut '2')
  acc=$(( $(ecut '1') % $tmp ))
  [[ $(( $acc * 10 )) == "$acc"'0' ]] || return
  while [[ $(( $acc * 10 )) == "$acc"'0' ]]; do
    (( acc *= 10 ))
  done
  acc=$(( $acc / $tmp ))
  tmp=
  (( $acc < 0 )) && { (( acc *= -1 )) ; (( $out )) || tmp=- ; }
  out=$tmp$out.$acc
}

ext() {
  (( $ext )) && ext=0 || { shopt -s 'extglob' && ext=1 \
      || { echo 'The `extglob` shell option can not be set.' ; return ; } ; }
  echo -n 'Simple divisions will be evaluated '
  (( $ext )) && echo -n 'fractionally' || echo -n 'integrally'
  echo '.'
}

ins() {
  case "$1" in
    ans ) inp=$ans ;;
    mem ) inp=$mem ;;
    rand ) inp=$RANDOM ;;
    copy ) inp=$exp ;;
  esac
  echo "$pst$inp"
}

mon() {
  echo -e ' exp: '"$exp" \
      '\n ans: '"$ans" \
      '\n mem: '"$mem" \
      '\n pre: '"$pre" \
      '\n ext: '"$ext"
  [[ "$1" ]] && echo -e ' acc: '"$acc" \
      '\n bex: '"$bex" \
      '\n bro: '"$bro" \
      '\n inp: '"$inp" \
      '\n out: '"$out" \
      '\n row: '"$row" \
      '\n tmp: '"$tmp"
}

pre() {
  (( $pre )) && pre=0 || pre=1
  echo -n 'Subsequent inputs will be '
  (( $pre )) && echo -n 'prepended' || echo -n 'appended'
  echo ' to the expression.'
}

ref() {
  echo '——Functions
     ac     Clears expression and result.
     ans    Inserts result.
     clr    Clears expression.
     cls    Clears screen.
     copy   Inserts expression.
  =, eval   Evaluates expression.
     ext    Toggles fractional precision for simple divisions.
  ?, help   Prints this reference.
     mem    Inserts saved result.
  p, peek   Previews expression evaluation.
     pre    Toggles input prepending.
     quit   Quits program.
     rand   Inserts a random number within [0, 32767].
     stat   Prints calculator variables.
     sto    Saves result to memory.
     undo   Undos last change to expression.
     vars   Prints program variables.'
  read -sp '[Enter] to continue.'
  echo '

——Common Syntax
  -       Arithmetic negation
  ! ~     Logical and bitwise negation
  * / %   Multiplication, division, remainder (modulus)
  + -     Addition, subtraction
  << >>   Logical shifts
  &       Bitwise AND
  ^       Bitwise XOR
  |       Bitwise OR
  ( )     Precedence grouping

Assignment
  = *= /= %= += -= <<= >>= &= ^= |=

Notation
  10    base-10 "Decimal"
  0xA   base-16 "Hexadecimal"
  012   base-8  "Octal"

Refer to the shell documentation for specific syntaxes.'
}

sto() {
  mem=$ans
  echo ' mem: '"$mem"
}

undo() {
  (( $row != $bro )) && {
    tmp=$exp ; exp=$bex ; bex=$tmp ; tmp=$row ; row=$bro ; bro=$tmp ;
    echo 'Undid last change to expression. `undo` again to reverse.' ;
  } || echo 'Nothing to undo; expression was last cleared.'
}

[[ "$1" == "--help" ]] && { head ; echo 'Usage: [<expression>]' ; exit 0 ; }
[[ "$@" ]] && { ans=$(echo $(( $@ )) ) \
    && { echo "$ans" ; exit 0 ; } \
    || exit 1 ; }
acc=0
ans=0
bex=
bro=1
exp=
ext=0
inp=
mem=0
out=
pre=0
row=1
tmp=
head
echo '`help` for reference.'
while true; do
  inp=
  read -ep "$pst" inp
  [[ "$inp" ]] || continue
  case "$inp" in
    = | eval ) eval ;;
    ac ) clr all ;;
    clr ) clr ;;
    cls ) clear 2> /dev/null ;;
    ext ) ext ;;
    \? | help ) ref ;;
    p | peek ) eval peek ;;
    pre ) pre ;;
    quit ) exit 0 ;;
    stat ) mon ;;
    sto ) sto ;;
    undo ) undo ;;
    vars ) mon all ;;
    * ) con ;;
  esac
done
