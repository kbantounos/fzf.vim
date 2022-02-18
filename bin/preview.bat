:: Partially replicate behaviour of bash script "fzf.vim\bin\preview.sh" using a Windows Command Prompt batch file "preview.bat".
@ECHO OFF

:: Input to script is a single string, delimited by character ':'
set stringInput=%1

:: Split input string based on a colon delimiter character ':'
for /f "tokens=1,2 delims=:" %%a in ("%stringInput%") do (
    set file=%%a
    set lineNum=%%b
)

:: Debugging path
:: call :PRINTPATH %file%

:: Obtain absolute path to file
call :ABSPATH %file%
set filePath=%RETVAL%

:: Debugging
:: echo "%filePath%">> %HOME%\t1.txt

:: Execute bat program for the preview, with a single input or two inputs
::     Original command from "preview.sh":
::         ${BATNAME} --style="${BAT_STYLE:-numbers}" --color=always --pager=never \ --highlight-line=$CENTER -- "$FILE"
::     Simplified:
::         bat --style=numbers --color=always --pager=never --highlight-line=$CENTER -- "$FILE"
:: if [%2] == [] (bat --style=numbers --color=always --pager=never -- "%file%") else (bat --style=numbers --color=always --pager=never --highlight-line=%lineNum% -- "%filePath%")
if [%2] == [] (bat --style=numbers --color=always --pager=never -- "%filePath%") else (bat --style=numbers --color=always --pager=never --highlight-line=%lineNum% -- "%filePath%")

:: End script execution
EXIT /B

:: Debugging - Print various versions of the current path to the input argument and of the current batch script
:: [windows - Resolve absolute path from relative path and/or file name - Stack Overflow](https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name)
:PRINTPATH
    echo %%~dp0               is: "%~dp0".
    echo %%0                  is: "%0".
    echo %%~dpnx0             is: "%~dpnx0".
    echo %%~f1                is: "%~f1".
    echo %%~dp0%%~1            is: "%~dp0%~1".

    :: Temporarily change the current working directory, to retrieve a full path to the first parameter
    pushd .
    cd %~dp0
    echo batch-relative %%~f1 is: "%~f1"
    popd
    EXIT /B

:: Return the absolute path of a file passed as the input argument
:ABSPATH
    SET RETVAL=%~f1
    :: Debugging
    :: echo ABSPATH path result is: "%RETVAL%"
    EXIT /B

