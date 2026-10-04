@echo off
setlocal
title KSP DLSS 5 - Install

echo.
echo  ==================================================
echo    KSP DLSS 5  -  One-click Installer
echo  ==================================================
echo.

set "KSPDIR="

REM --- 1. common Steam / local locations ---
for %%D in (
  "C:\Program Files (x86)\Steam\steamapps\common\Kerbal Space Program"
  "C:\Program Files\Steam\steamapps\common\Kerbal Space Program"
  "D:\SteamLibrary\steamapps\common\Kerbal Space Program"
  "E:\SteamLibrary\steamapps\common\Kerbal Space Program"
  "F:\SteamLibrary\steamapps\common\Kerbal Space Program"
  "G:\SteamLibrary\steamapps\common\Kerbal Space Program"
  "F:\game\Kerbal Space Program"
) do (
  if exist "%%~D\KSP_x64.exe" if not defined KSPDIR set "KSPDIR=%%~D"
)

REM --- 2. folder dragged onto this .bat ---
if not "%~1"=="" if exist "%~1\KSP_x64.exe" set "KSPDIR=%~1"

REM --- 3. ask ---
if not defined KSPDIR (
  echo  KSP was not found automatically.
  echo  Drag your KSP folder onto this file, or type the path below.
  echo.
  set /p KSPDIR="  KSP folder: "
)

if not exist "%KSPDIR%\KSP_x64.exe" (
  echo.
  echo  [ERROR] No KSP_x64.exe in: %KSPDIR%
  echo.
  pause
  exit /b 1
)

echo.
echo  KSP folder : %KSPDIR%
echo.
echo  This will install ReShade + DLSS 5 Feeder into it.
echo  Press any key to continue  (Ctrl+C to cancel)
pause >nul

echo.
echo  Copying files ...
xcopy "%~dp0payload\*" "%KSPDIR%\" /E /I /Y /Q >nul
if errorlevel 1 (
  echo.
  echo  [ERROR] Copy failed. Is KSP still running? Close it and try again.
  echo.
  pause
  exit /b 1
)

REM --- KSP anti-aliasing must be OFF for depth to work ---
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = Join-Path '%KSPDIR%' 'settings.cfg'; if (Test-Path $s) { $c = Get-Content -Raw $s; if ($c -match '(?m)^ANTI_ALIASING\s*=\s*\d+') { $c = [regex]::Replace($c, '(?m)^ANTI_ALIASING\s*=\s*\d+', 'ANTI_ALIASING = 0'); [IO.File]::WriteAllText($s, $c); Write-Host '  settings.cfg: ANTI_ALIASING set to 0' } }"

echo.
echo  ==================================================
echo    DONE
echo  ==================================================
echo.
echo  How to use:
echo    1. Launch KSP
echo    2. Enter a flight scene
echo    3. Press HOME to open the ReShade overlay
echo.
echo  To remove everything, run Uninstall.bat
echo.
pause
