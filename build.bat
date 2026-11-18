@echo off
setlocal EnableExtensions
chcp 65001 >nul

set "ROOT=%~dp0"
set "PROJECT_DIR=%ROOT%UnityProject"
set "OUTPUT_EXE=%ROOT%Build\OngChuMMO_Live.exe"
set "LOG_FILE=%ROOT%build_log.txt"
set "PROJECT_VERSION="

for /f "tokens=2 delims=:" %%v in ('findstr /b "m_EditorVersion:" "%PROJECT_DIR%\ProjectSettings\ProjectVersion.txt" 2^>nul') do for /f "tokens=*" %%w in ("%%v") do set "PROJECT_VERSION=%%w"

if not defined PROJECT_VERSION (
    echo [LOI] Khong doc duoc phien ban Unity tu ProjectVersion.txt.
    goto :failed
)

rem Prefer the Unity editor installed on this workstation.
rem Fall back to the project's pinned Unity Hub version when it is installed.
set "UNITY_EXE=C:\Program Files\Unity 6000.6.8f1\Editor\Unity.exe"
set "UNITY_EDITOR_VERSION=6000.6.8f1"
if not exist "%UNITY_EXE%" (
    set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\%PROJECT_VERSION%\Editor\Unity.exe"
    set "UNITY_EDITOR_VERSION=%PROJECT_VERSION%"
)
if not exist "%UNITY_EXE%" (
    echo [LOI] Chua tim thay Unity Editor dung phien ban.
    echo Da kiem tra Unity 6000.6.8f1 tai:
    echo C:\Program Files\Unity 6000.6.8f1\Editor\Unity.exe
    echo Va Unity %PROJECT_VERSION% tai:
    echo C:\Program Files\Unity\Hub\Editor\%PROJECT_VERSION%\Editor\Unity.exe
    goto :failed
)

echo =======================================
echo     BUILD GAME ONG CHU MMO LIVE
echo =======================================
echo Unity Editor: %UNITY_EDITOR_VERSION%
echo Project version metadata: %PROJECT_VERSION%
echo Output: %OUTPUT_EXE%
echo.

if not exist "%ROOT%Build" mkdir "%ROOT%Build"
"%UNITY_EXE%" -quit -batchmode -projectPath "%PROJECT_DIR%" -buildWindows64Player "%OUTPUT_EXE%" -logFile "%LOG_FILE%"
set "BUILD_RESULT=%ERRORLEVEL%"

if not "%BUILD_RESULT%"=="0" (
    echo [LOI] Unity build that bai ^(ma loi %BUILD_RESULT%^).
    echo Xem log: %LOG_FILE%
    goto :failed
)

if not exist "%OUTPUT_EXE%" (
    echo [LOI] Unity khong tao file %OUTPUT_EXE%.
    echo Xem log: %LOG_FILE%
    goto :failed
)

echo Dang chep nhac va tai san nen vao Build...
call "%ROOT%stage_runtime_assets.bat"
if errorlevel 1 (
    echo [LOI] Khong the chep day du nhac va tai san nen vao Build.
    goto :failed
)

echo.
echo Build thanh cong: %OUTPUT_EXE%
pause
exit /b 0

:failed
echo.
pause
exit /b 1
