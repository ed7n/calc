#! /bin/bash

#goto run

head() {
    echo "Calculator (calc)"
    echo "-----------------"
    echo "u2r0 by Brendon, 01/23/2019."
    echo
    echo "Actually an expression evaluator."
    echo "Conceived over 61 months after the last stale release!"
    echo
    echo
}

help() {
    echo "Usage: ./calc <expression>"
    echo
    echo "where <expression> is the expression to be evaluated."
    echo
    echo "Otherwise, this script is interactive."
}

end() {
    #endlocal
    echo
    echo
    echo "-----------"
    echo "End of calc"
}

clr() {
    echo
    calc_exp=NUL
    calc_bex=NUL
    calc_row=1
    calc_bro=1

    if [[ "$1" == "all" ]]; then
        calc_ans=0
        echo "All Cleared."
    else
        echo "Expression cleared."
    fi
    echo
}

cls() {
    clear
    echo "Screen cleared."
    echo
}

eval() {
    echo
    # ack: https://stackoverflow.com/a/34937706
    calc_tmp=0
    edensh_out=$( echo $(( $calc_exp )) ) && calc_tmp=1

    if (( $calc_tmp == 1 )); then
        echo "Ans: $edensh_out"
    else
        echo "Expr: $calc_exp"
    fi
    if ! [[ "$1" == "peek" ]]; then
        if (( $calc_tmp == 1 )); then calc_ans=$edensh_out; fi
        calc_bex=$calc_exp
        calc_exp=NUL
        calc_bro=$calc_row
        calc_row=1
    fi
    echo
}

info() {
    echo
    echo "Expr: $calc_exp"
    echo " Ans: $calc_ans"
    echo " Mem: $calc_mem"
    echo
    echo " Pre: $calc_pre"
    echo "  Ln: $calc_row"
    echo
}

ins() {
    if   [[ "$1" == "ans"  ]]; then edensh_inp=$calc_ans
    elif [[ "$1" == "mem"  ]]; then edensh_inp=$calc_mem
    elif [[ "$1" == "rand" ]]; then edensh_inp=$RANDOM

    elif [[ "$1" == "copy" ]]; then
        if [[ "$calc_exp" == "NUL" ]]; then
            edensh_inp=
        else
            edensh_inp=$calc_exp
        fi
    fi
    #:ins_echo
    echo "calc/_>$edensh_inp"
}

pre() {
    echo

    if (( $calc_pre == 1 )); then
        calc_pre=0
        echo "Subsequent inputs will be appended."
    else
        calc_pre=1
        echo "Subsequent inputs will be prepended."
    fi
    echo "Pre: $calc_pre"
    echo
}

ref() {
    echo
    echo "---------------------------------<i> FUNCTIONS---------------------------------"
    echo "  ac       Clears current expression and last result."
    echo "  ans      Inserts last result."
    echo "  clr      Clears current expression."
    echo "  cls      Clears screen."
    echo "  copy     Inserts current expression."
    echo "  =, eval  Evaluates current expression."
    echo "  help     Displays this help reference."
    echo "  info     Displays current state."
    echo "  mem      Inserts saved result."
    echo "  peek     Peeks result of current expression."
    echo "  pre      Toggles prepending of inputs."
    echo "  rand     Inserts a random decimal number within [0, 32767]."
    echo "  sto      Saves last result to memory."
    echo "  undo     Reverts last change to expression."
    echo
    echo "  quit, exit   Quits Calculator."
    echo "-------------------------------------------------------------------------------"
    echo "Press any key to continue"
    read -n 1
    echo
    echo "-------------------------------<i> COMMON SYNTAX-------------------------------"
    echo "  -       Arithmetic negation"
    echo "  ! ~     Logical and bitwise negation"
    echo "  * / %   Multiplication, division, remainder (modulus)"
    echo "  + -     Addition, subtraction"
    echo "  << >>   Logical shifts"
    echo "  &       Bitwise AND"
    echo "  ^       Bitwise XOR"
    echo "  |       Bitwise OR"
    echo "  ( )     Precedence grouping"
    echo
    echo "Assignment"
    echo "  = *= /= %= += -= <<= >>= &= ^= |="
    echo
    echo "Numeric values are decimal numbers, unless prefixed by 0x for hexadecimal"
    echo "numbers, and 0 for octal numbers. So 0x12 == 18 == 022. Please note that the"
    echo "octal notation can be confusing: 08 and 09 are invalid numbers because 8 and"
    echo "9 are invalid octal digits."
    echo
    echo "Refer to the command interpreter's reference for specific syntaxes."
    echo "-------------------------------------------------------------------------------"
    echo
}

sto() {
    echo
    calc_mem=$calc_ans
    echo "Mem: $calc_mem"
    echo
}

undo() {
    echo
    if (( $calc_row != $calc_bro )); then
        calc_tmp=$calc_exp
        calc_exp=$calc_bex
        calc_bex=$calc_tmp
        calc_tmp=$calc_row
        calc_row=$calc_bro
        calc_bro=$calc_tmp
        echo "Expression undone. Input \"undo\" again to reverse."
    else
        echo "Nothing to undo, expression was last cleared."
    fi
    echo
}

#:run
if [[ "$1" == "help" ]]; then { echo; echo; head; help; end; exit; }; fi

if ! [[ "$@" == "" ]]; then
    #setlocal EnableExtensions
    #setlocal EnableDelayedExpansion
    edensh_err=1
    calc_ans=$(echo $(( $@ )) ) && edensh_err=0

    if (( $edensh_err == 0 )); then
        echo "$calc_ans"
    fi
    #endlocal
    exit $edensh_err
fi
echo
echo
echo "Initializing..."
#setlocal EnableExtensions
#setlocal EnableDelayedExpansion
edensh_out=NUL
edensh_inp=NUL
calc_ans=0
calc_bex=NUL
calc_bro=1
calc_exp=NUL
calc_mem=0
calc_pre=0
calc_row=1
calc_tmp=NUL
echo
head
echo "Input \"help\" for reference."
echo

while true; do
    edensh_inp=NUL
    read -e -p "calc/_>" edensh_inp

    if ! [[ "$edensh_inp" == "NUL" ]]; then
        # functions
        if   [[ "$edensh_inp" == "="    ]]; then eval
        elif [[ "$edensh_inp" == "eval" ]]; then eval
        elif [[ "$edensh_inp" == "peek" ]]; then eval peek
        elif [[ "$edensh_inp" == "undo" ]]; then undo
        elif [[ "$edensh_inp" == "sto"  ]]; then sto
        elif [[ "$edensh_inp" == "info" ]]; then info
        elif [[ "$edensh_inp" == "pre"  ]]; then pre
        elif [[ "$edensh_inp" == "clr"  ]]; then clr
        elif [[ "$edensh_inp" == "ac"   ]]; then clr all
        elif [[ "$edensh_inp" == "cls"  ]]; then cls
        elif [[ "$edensh_inp" == "help" ]]; then ref
        elif [[ "$edensh_inp" == "quit" ]]; then { end; break; }
        elif [[ "$edensh_inp" == "exit" ]]; then { end; break; }

        else
            if   [[ "$edensh_inp" == "ans"  ]]; then ins ans
            elif [[ "$edensh_inp" == "mem"  ]]; then ins mem
            elif [[ "$edensh_inp" == "copy" ]]; then ins copy
            elif [[ "$edensh_inp" == "rand" ]]; then ins rand
            fi
            # input concatenate
            #:concat
            calc_bex=$calc_exp

            if [[ "$calc_exp" == "NUL" ]]; then
                calc_exp=$edensh_inp
            else
                if (( $calc_pre == 1 )); then
                    calc_exp="$edensh_inp $calc_exp"
                else
                    calc_exp="$calc_exp $edensh_inp"
                fi
            fi
            calc_bro=$calc_row
            (( calc_row+=1 ))
        fi
    fi
done