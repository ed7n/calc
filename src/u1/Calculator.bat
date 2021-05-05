@echo off
title Calculator: Starting up...
mode con cols=38
color 07
goto allclear
:allclear
cls
set calcansl=Null.
goto reset
:reset
set calcinp1=n
set calcinp2=n
set calcinp3=n
set calcinp4=n
set calcinp5=n
set calcinp6=n
set calcinp7=n
set calcinp8=n
set calcans=Null.
set calcansr=Null.
goto input1
:input1
title Calculator: Ln 1
set /p calcinp1=
if %calcinp1%==000 exit
if %calcinp1%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp1%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input1
goto :eof
) else (
@echo off
)
if %calcinp1%==. (
echo --------
echo Ans: %calcansr%
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcinp1%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input2
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input2
goto :eof
) else (
set calcansr=%calcans%
goto input2
goto :eof
)
:input2
title Calculator: Ln 2
set /p calcinp2=
if %calcinp2%==000 exit
if %calcinp2%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp2%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input2
goto :eof
) else (
@echo off
)
if %calcinp2%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp2%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input3
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input3
goto :eof
) else (
set calcansr=%calcans%
goto input3
goto :eof
)
:input3
title Calculator: Ln 3
set /p calcinp3=
if %calcinp3%==000 exit
if %calcinp3%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp3%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input3
goto :eof
) else (
@echo off
)
if %calcinp3%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp3%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input4
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input4
goto :eof
) else (
set calcansr=%calcans%
goto input4
goto :eof
)
:input4
title Calculator: Ln 4
set /p calcinp4=
if %calcinp4%==000 exit
if %calcinp4%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp4%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input4
goto :eof
) else (
@echo off
)
if %calcinp4%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp4%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input5
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input5
goto :eof
) else (
set calcansr=%calcans%
goto input5
goto :eof
)
:input5
title Calculator: Ln 5
set /p calcinp5=
if %calcinp5%==000 exit
if %calcinp5%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp5%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input5
goto :eof
) else (
@echo off
)
if %calcinp5%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp5%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input6
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input6
goto :eof
) else (
set calcansr=%calcans%
goto input6
goto :eof
)
:input6
title Calculator: Ln 6
set /p calcinp6=
if %calcinp6%==000 exit
if %calcinp6%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp6%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input6
goto :eof
) else (
@echo off
)
if %calcinp6%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp6%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input7
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input7
goto :eof
) else (
set calcansr=%calcans%
goto input7
goto :eof
)
:input7
title Calculator: Ln 7
set /p calcinp7=
if %calcinp7%==000 exit
if %calcinp7%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp7%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input7
goto :eof
) else (
@echo off
)
if %calcinp7%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp7%"
if %calcans%==Null. (
set calcansr=Syntax error.
goto input8
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
goto input8
goto :eof
) else (
set calcansr=%calcans%
goto input8
goto :eof
)
:input8
title Calculator: Ln 8
set /p calcinp8=
if %calcinp8%==000 exit
if %calcinp8%==00 (
goto allclear
goto :eof
) else (
@echo off
)
if %calcinp8%==0 (
echo -------------------------------------
echo Current: %calcansr%
echo Last: %calcansl%
echo.
echo Command inputs:
echo  . to execute.
echo  0 to view help.
echo  00 to AC.
echo  000 to exit.
echo [ENTER] to submit input.
echo [UP] or [DOWN] to view input history.
echo Up to 8 lines only.
echo Integers with [+] [-] [*] [/] only.
echo.
echo u1r0 by Brendon, 12/17/2013.
echo -------------------------------------
goto input8
goto :eof
) else (
@echo off
)
if %calcinp8%==. (
echo --------
echo Ans: %calcansr%
set calcansl=%calcansr%
echo.
goto reset
goto :eof
) else (
@echo off
)
set /a calcans="%calcans%%calcinp8%"
if %calcans%==Null. (
set calcansr=Syntax error.
echo --------
echo Ans: %calcansr%
goto reset
goto :eof
) else (
@echo off
)
if %calcans%==0 (
set calcansr=Error: Ans is 0 or syntax error.
echo --------
echo Ans: %calcansr%
goto reset
goto :eof
) else (
set calcansl=%calcans%
echo --------
echo Ans: %calcans%
echo.
goto reset
goto :eof
)