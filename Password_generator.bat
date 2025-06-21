@echo off
title Password Generator by cray

color 0a

cls

rem
echo.
echo   .o88b.  d8888b.   .d8b.   Y8b   d8P
echo  d8P  Y8  88  `8D  d8' `8b   `88b d88'
echo  8P       88oobY'  88ooo88    `88o88'
echo  8b       88`8b    88~~~88     `888'
echo  Y8b  d8  88 `88.  88   88      888
echo   `Y88P'  88   YD  YP   YP      888
echo.
echo.
echo           Welcome to the Password Generator by cray!
echo.
echo.

:start_generation
setlocal enabledelayedexpansion

set "LOWERCASE=abcdefghijklmnopqrstuvwxyz"
set "UPPERCASE=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set "NUMBERS=0123456789"
set "SPECIALS=#$*_-.,?@+!&|\=[]{}()'`~"

set "CHARSET="
set "CHARSET_LEN=0"

:getLower
set "use_lower="
set /p "use_lower=Include lowercase letters (a-z)? [Y/N]: "
if /i not "!use_lower!"=="Y" if /i not "!use_lower!"=="N" (
    echo Invalid input. Please enter Y or N.
    goto getLower
)
if /i "!use_lower!"=="Y" (
    set "CHARSET=!CHARSET!%LOWERCASE%"
    set /a CHARSET_LEN+=26
)

:getUpper
set "use_upper="
set /p "use_upper=Include uppercase letters (A-Z)? [Y/N]: "
if /i not "!use_upper!"=="Y" if /i not "!use_upper!"=="N" (
    echo Invalid input. Please enter Y or N.
    goto getUpper
)
if /i "!use_upper!"=="Y" (
    set "CHARSET=!CHARSET!%UPPERCASE%"
    set /a CHARSET_LEN+=26
)

:getNumbers
set "use_numbers="
set /p "use_numbers=Include numbers (0-9)? [Y/N]: "
if /i not "!use_numbers!"=="Y" if /i not "!use_numbers!"=="N" (
    echo Invalid input. Please enter Y or N.
    goto getNumbers
)
if /i "!use_numbers!"=="Y" (
    set "CHARSET=!CHARSET!%NUMBERS%"
    set /a CHARSET_LEN+=10
)

:getSpecials
set "use_specials="
set /p "use_specials=Include special characters (%SPECIALS%)? [Y/N]: "
if /i not "!use_specials!"=="Y" if /i not "!use_specials!"=="N" (
    echo Invalid input. Please enter Y or N.
    goto getSpecials
)
if /i "!use_specials!"=="Y" (
    set "CHARSET=!CHARSET!%SPECIALS%"
    set /a CHARSET_LEN+=8
)

echo.

if !CHARSET_LEN! equ 0 (
    echo You must select at least one character set to generate a password.
    echo.
    goto end
)

:getLength
set "pass_len="
set /p "pass_len=Enter the desired password length (e.g., 12): "

set /a num_check=0
set /a num_check=%pass_len% 2>nul
if !num_check! equ 0 (
    echo Invalid length. Please enter a valid number greater than 0.
    goto getLength
)
if %pass_len% LSS 1 (
    echo Password length must be at least 1.
    goto getLength
)

echo.
echo Generating your password...
echo.

set "password="
for /l %%i in (1,1,%pass_len%) do (
    set /a "rand_num=!RANDOM! %% !CHARSET_LEN!"
    call set "char=%%CHARSET:~!rand_num!,1%%"
    set "password=!password!!char!"
)

echo =======================================================
echo  Your randomly generated password is:
echo.
echo  !password!
echo.
echo =======================================================
echo.
echo  Remember to store it in a safe place!
echo.

:ask_again
echo.
choice /c CYN /m "Press [C] to copy, [Y] to generate another, or [N] to quit."
if errorlevel 3 goto end
if errorlevel 2 (
    endlocal
    cls
    goto :start_generation
)
if errorlevel 1 (
    echo|set /p=!password!|clip
    echo Password copied to clipboard.
    goto ask_again
)

:end
endlocal
pause
