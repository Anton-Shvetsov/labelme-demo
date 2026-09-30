@echo off
setlocal

set "HOST=softmatterserver-ESC8000A-E12.local.bmstu.ru"
set "PORT=8000"

echo ============================================================================
echo Connecting to Digital Platform
echo ============================================================================

:check
set "URL=http://%HOST%:%PORT%/"
echo Connecting to server...

powershell -NoProfile -Command "try { $null = [System.Net.Dns]::GetHostAddresses('%HOST%') } catch { exit 1 }; $r = [System.Net.WebRequest]::Create('%URL%'); $r.Timeout = 5000; $r.AllowAutoRedirect = $false; try { $r.GetResponse().Close() } catch [System.Net.WebException] { if ($_.Exception.Response) { exit 0 }; exit 2 }; exit 0"
set "RC=%errorlevel%"

if "%RC%"=="0" goto open

if "%RC%"=="1" (
    echo ERROR: server was not found.
    echo Make sure you are connected to the seminar Wi-Fi and VPN is turned off.
) else if "%RC%"=="2" (
    echo ERROR: server does not respond.
    echo Make sure you are connected to the seminar Wi-Fi and VPN is turned off.
) else (
    echo ERROR: connection check failed.
)

echo.
set "MANUAL="
set /p "MANUAL=Enter server address from the organizers (or press Enter to exit): "
if not defined MANUAL goto fail

set "MANUAL=%MANUAL:http://=%"
if "%MANUAL:~-1%"=="/" set "MANUAL=%MANUAL:~0,-1%"
for /f "tokens=1,2 delims=:" %%a in ("%MANUAL%") do (
    set "HOST=%%a"
    if not "%%b"=="" set "PORT=%%b"
)
goto check

:open
echo Opening Digital Platform in browser...
start "" "%URL%app-acc/register"
exit /b 0

:fail
pause
exit /b 1
