@echo off

goto run

:head
    echo Calculator (calc.bat)
    echo ---------------------
    echo u2r0 by Brendon, 01/23/2019.
    echo:
    echo Actually an expression evaluator.
    echo Conceived over 61 months after the last stale release^^!
    echo:
    echo:
goto :eof

:help
    echo Usage: calc ^<expression^>
    echo:
    echo where ^<expression^> is the expression to be evaluated.
    echo:
    echo Otherwise, this script is interactive.
goto :eof

:end
    endlocal
    echo:
    echo:
    echo ---------------
    echo End of calc.bat
goto :eof

:clr
    echo:
    set calc_exp=NUL
    set calc_bex=NUL
    set calc_row=1
    set calc_bro=1

    if "%1" == "all" (
        set calc_ans=0
        echo All Cleared.
    ) else (
        echo Expression cleared.
    )
    echo:
goto :eof

:cls
    cls
    echo Screen cleared.
    echo:
goto :eof

:eval
    echo:
    :: ack: https://stackoverflow.com/a/34937706
    set calc_tmp=0
    set /a edendos_out="!calc_exp!" && set calc_tmp=1

    if !calc_tmp! EQU 1 (
        echo Ans: !edendos_out!
    ) else (
        echo Expr: !calc_exp!
    )
    if not "%1" == "peek" (
        if !calc_tmp! EQU 1 set calc_ans=!edendos_out!
        set calc_bex=!calc_exp!
        set calc_exp=NUL
        set calc_bro=!calc_row!
        set calc_row=1
    )
    echo:
goto :eof

:info
    echo:
    echo Expr: !calc_exp!
    echo  Ans: !calc_ans!
    echo  Mem: !calc_mem!
    echo:
    echo  Pre: !calc_pre!
    echo   Ln: !calc_row!
    echo:
goto :eof

:ins
    if "%1" == "ans"  ( set "edendos_inp=!calc_ans!" & goto :ins_echo )
    if "%1" == "mem"  ( set "edendos_inp=!calc_mem!" & goto :ins_echo )
    if "%1" == "rand" ( set "edendos_inp=!random!"   & goto :ins_echo )

    if "%1" == "copy" (
        if "!calc_exp!" == "NUL" (
            set edendos_inp=
        ) else (
            set edendos_inp=!calc_exp!
        )
    )
    :ins_echo
    echo calc/_^>!edendos_inp!
goto :eof

:pre
    echo:

    if !calc_pre! EQU 1 (
        set calc_pre=0
        echo Subsequent inputs will be appended.
    ) else (
        set calc_pre=1
        echo Subsequent inputs will be prepended.
    )
    echo Pre: !calc_pre!
    echo:
goto :eof

:ref
    echo:
    echo ---------------------------------^<i^> FUNCTIONS---------------------------------
    echo   ac       Clears current expression and last result.
    echo   ans      Inserts last result.
    echo   clr      Clears current expression.
    echo   cls      Clears screen.
    echo   copy     Inserts current expression.
    echo   =, eval  Evaluates current expression.
    echo   help     Displays this help reference.
    echo   info     Displays current state.
    echo   mem      Inserts saved result.
    echo   peek     Peeks result of current expression.
    echo   pre      Toggles prepending of inputs.
    echo   rand     Inserts a random decimal number within [0, 32767].
    echo   sto      Saves last result to memory.
    echo   undo     Reverts last change to expression.
    echo:
    echo   quit, exit   Quits Calculator.
    echo -------------------------------------------------------------------------------
    echo Press any key to continue.
    pause > nul
    echo:
    echo -------------------------------^<i^> COMMON SYNTAX-------------------------------
    echo   -        Arithmetic negation
    echo   ^^! ~      Logical and bitwise negation
    echo   * / %%    Multiplication, division, remainder (modulus)
    echo   + -      Addition, subtraction
    echo   ^<^< ^>^>    Logical shifts
    echo   ^&        Bitwise AND
    echo   ^^        Bitwise XOR
    echo   ^|        Bitwise OR
    echo   ( )      Precedence grouping
    echo:
    echo Assignment
    echo   = *= /= %%= += -= ^<^<= ^>^>= ^&= ^^= ^|=
    echo:
    echo Numeric values are decimal numbers, unless prefixed by 0x for hexadecimal
    echo numbers, and 0 for octal numbers. So 0x12 == 18 == 022. Please note that the
    echo octal notation can be confusing: 08 and 09 are invalid numbers because 8 and
    echo 9 are invalid octal digits.
    echo:
    echo Refer to the command interpreter's reference for specific syntaxes.
    echo -------------------------------------------------------------------------------
    echo:
goto :eof

:sto
    echo:
    set calc_mem=!calc_ans!
    echo Mem: !calc_mem!
    echo:
goto :eof

:undo
    echo:
    if !calc_row! NEQ !calc_bro! (
        set calc_tmp=!calc_exp!
        set calc_exp=!calc_bex!
        set calc_bex=!calc_tmp!
        set calc_tmp=!calc_row!
        set calc_row=!calc_bro!
        set calc_bro=!calc_tmp!
        echo Expression undone. Input "undo" again to reverse.
    ) else (
        echo Nothing to undo, expression was last cleared.
    )
    echo:
goto :eof

:run
if /i "%1" == "help" ( echo: & echo: & call :head & call :help & goto end )

if /i not "%*" == "" (
    setlocal EnableExtensions
    setlocal EnableDelayedExpansion
    set edendos_err=1
    set /a calc_ans="%*" && set edendos_err=0

    if !edendos_err! EQU 0 (
        echo !calc_ans!
    )
    endlocal
    exit /b %edendos_err%
)
echo:
echo:
echo Initializing...
setlocal EnableExtensions
setlocal EnableDelayedExpansion
set edendos_out=NUL
set edendos_inp=NUL
set calc_ans=0
set calc_bex=NUL
set calc_bro=1
set calc_exp=NUL
set calc_mem=0
set calc_pre=0
set calc_row=1
set calc_tmp=NUL
echo:
call :head
echo Input "help" for reference.
echo:

:input
    set edendos_inp=NUL
    set /p edendos_inp="calc/_>"

    if not "!edendos_inp!" == "NUL" (
        :: functions
        if /i "!edendos_inp!" == "="    ( call :eval      & goto input )
        if /i "!edendos_inp!" == "eval" ( call :eval      & goto input )
        if /i "!edendos_inp!" == "peek" ( call :eval peek & goto input )
        if /i "!edendos_inp!" == "undo" ( call :undo      & goto input )
        if /i "!edendos_inp!" == "sto"  ( call :sto       & goto input )
        if /i "!edendos_inp!" == "info" ( call :info      & goto input )
        if /i "!edendos_inp!" == "pre"  ( call :pre       & goto input )
        if /i "!edendos_inp!" == "clr"  ( call :clr       & goto input )
        if /i "!edendos_inp!" == "ac"   ( call :clr all   & goto input )
        if /i "!edendos_inp!" == "cls"  ( call :cls       & goto input )
        if /i "!edendos_inp!" == "help" ( call :ref       & goto input )
        if /i "!edendos_inp!" == "quit" ( goto end )
        if /i "!edendos_inp!" == "exit" ( goto end

        ) else (
            if /i "!edendos_inp!" == "ans"  ( call :ins ans  & goto concat )
            if /i "!edendos_inp!" == "mem"  ( call :ins mem  & goto concat )
            if /i "!edendos_inp!" == "copy" ( call :ins copy & goto concat )
            if /i "!edendos_inp!" == "rand" ( call :ins rand & goto concat )

            :: input concatenate
            :concat
            set calc_bex=!calc_exp!

            if "!calc_exp!" == "NUL" (
                set calc_exp=!edendos_inp!
            ) else (
                if !calc_pre! EQU 1 (
                    set calc_exp=!edendos_inp! !calc_exp!
                ) else (
                    set calc_exp=!calc_exp! !edendos_inp!
                )
            )
            set calc_bro=!calc_row!
            set /a calc_row+=1
        )
    )
goto input