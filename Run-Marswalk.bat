@echo off
setlocal
title Marswalk local server
cd /d "%~dp0"
set PORT=8123
echo.
echo  MARSWALK - Jezero mission planner
echo  Starting a local server on http://localhost:%PORT%/
echo  (3D terrain and fonts need an internet connection. Close this window to stop.)
echo.
:: Open the browser a couple of seconds after the server starts.
start "" /min cmd /c "timeout /t 3 /nobreak >nul & start "" http://localhost:%PORT%/"
:: 1) Node.js
where node >nul 2>nul
if %errorlevel%==0 (
  node scripts\serve.mjs %PORT%
  goto :end
)
:: 2) Python launcher / python
where py >nul 2>nul
if %errorlevel%==0 (
  py -3 -m http.server %PORT% --bind 127.0.0.1 --directory dist
  goto :end
)
where python >nul 2>nul
if %errorlevel%==0 (
  python -m http.server %PORT% --bind 127.0.0.1 --directory dist
  goto :end
)
echo.
echo  Could not find Node.js or Python.
echo  Install one of them (https://nodejs.org or https://www.python.org/downloads/) and run this file again.
pause
:end
endlocal
