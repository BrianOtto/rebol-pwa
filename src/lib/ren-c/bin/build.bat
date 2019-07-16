@ECHO OFF

REM The location of Ren-C
REM See https://github.com/metaeducation/ren-c
SET RENC=..\..\..\..\..\ren-c

ECHO.
ECHO Building Ren-C ...
ECHO.

REM Build the executable
"%RENC%\prebuilt\r3-windows-x86-8994d23" %RENC%\make.r

REM Clean up the build output
RMDIR /S /Q objs
RMDIR /S /Q prep

ECHO.
ECHO Done

EXIT /B %ERRORLEVEL%