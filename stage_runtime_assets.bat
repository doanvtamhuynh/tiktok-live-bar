@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
set "BUILD_ROOT=%ROOT%Build"
set "COPY_FAILED=0"

call :copy_extensions DJ_MUSIC DJ_MUSIC mp3 wav ogg
call :copy_file "%ROOT%DJ_MUSIC\VOLUME.txt" "%BUILD_ROOT%\DJ_MUSIC"

call :copy_extensions DJ_VIDEO DJ_VIDEO mp4 mov m4v webm png jpg jpeg
call :copy_file "%ROOT%DJ_VIDEO\BPM.txt" "%BUILD_ROOT%\DJ_VIDEO"
call :copy_file "%ROOT%LiveAssets\nenamphu.png" "%BUILD_ROOT%\LiveAssets"

if "%COPY_FAILED%"=="1" exit /b 1
exit /b 0

:copy_extensions
set "SOURCE_DIR=%ROOT%%~1"
set "DEST_DIR=%BUILD_ROOT%\%~2"
shift
shift

:next_extension
if "%~1"=="" exit /b 0
call :copy_extension "%SOURCE_DIR%" "%DEST_DIR%" "%~1"
shift
goto :next_extension

:copy_extension
if not exist "%~1\*.%~3" exit /b 0
if not exist "%~2\" mkdir "%~2" >nul 2>&1
for %%F in ("%~1\*.%~3") do if exist "%%~fF" (
    copy /y "%%~fF" "%~2\" >nul
    if errorlevel 1 set "COPY_FAILED=1"
)
exit /b 0

:copy_file
if not exist "%~1" exit /b 0
if not exist "%~2\" mkdir "%~2" >nul 2>&1
copy /y "%~1" "%~2\" >nul
if errorlevel 1 set "COPY_FAILED=1"
exit /b 0
