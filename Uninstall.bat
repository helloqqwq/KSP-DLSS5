@echo off
setlocal
title KSP DLSS 5 - Uninstall

echo.
echo  ==================================================
echo    KSP DLSS 5  -  Uninstaller
echo  ==================================================
echo.

set "KSPDIR="

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

if not "%~1"=="" if exist "%~1\KSP_x64.exe" set "KSPDIR=%~1"

if not defined KSPDIR (
  set /p KSPDIR="  KSP folder: "
)

if not exist "%KSPDIR%\KSP_x64.exe" (
  echo  [ERROR] No KSP_x64.exe in: %KSPDIR%
  pause
  exit /b 1
)

echo  Removing DLSS 5 files from: %KSPDIR%
echo  Press any key to continue  (Ctrl+C to cancel)
pause >nul

del /Q "%KSPDIR%\dxgi.dll"            2>nul
del /Q "%KSPDIR%\dlss5-feed.addon64"  2>nul
del /Q "%KSPDIR%\dlss5-feed.cfg"      2>nul
del /Q "%KSPDIR%\dlss5-feed.log"      2>nul
del /Q "%KSPDIR%\renodx-dlss5.addon64" 2>nul
del /Q "%KSPDIR%\nvngx_dlss.dll"      2>nul
del /Q "%KSPDIR%\nvngx_dlssnr.dll"    2>nul
del /Q "%KSPDIR%\ReShade.ini"         2>nul
del /Q "%KSPDIR%\ReShadePreset.ini"   2>nul
del /Q "%KSPDIR%\ReShade.log"         2>nul
rd /S /Q "%KSPDIR%\reshade-shaders"   2>nul

echo.
echo  Done. KSP is back to its original state.
echo.
pause
