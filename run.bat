@echo off
setlocal

set "ROOT=%~dp0"
set "VENV_DIR=%ROOT%runtime\venv"

if not exist "%VENV_DIR%\Scripts\labelme.exe" (
    echo labelme is not installed. Run install.bat first.
    pause
    exit /b 1
)

echo Waiting for labelme to start...

"%VENV_DIR%\Scripts\labelme.exe" "%ROOT%images"
