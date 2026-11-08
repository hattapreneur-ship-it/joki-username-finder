@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Build Joki Username Finder

if not exist ".venv\Scripts\python.exe" (
    echo Jalankan run.bat sekali terlebih dahulu agar dependency aplikasi terpasang.
    pause
    exit /b 1
)

set "PY=%CD%\.venv\Scripts\python.exe"
"%PY%" -m pip install -r requirements-build.txt
if errorlevel 1 goto build_failed

if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist JokiUsernameFinder.spec del /q JokiUsernameFinder.spec
if exist sherlock_engine.spec del /q sherlock_engine.spec

echo [1/2] Build aplikasi GUI...
"%PY%" -m PyInstaller --noconfirm --clean --onedir --windowed --name JokiUsernameFinder --collect-all sherlock_project --collect-all PySide6 --collect-all pandas --collect-all certifi --collect-all colorama --collect-all requests_futures --collect-all requests --hidden-import socks main.py
if errorlevel 1 goto build_failed

echo [2/2] Build Sherlock engine...
"%PY%" -m PyInstaller --noconfirm --clean --onefile --console --name sherlock_engine --distpath dist\engine --workpath build\engine --specpath . --collect-all sherlock_project --collect-all pandas --collect-all certifi --collect-all colorama --collect-all requests_futures --collect-all requests --hidden-import socks app\sherlock_entry.py
if errorlevel 1 goto build_failed

copy /y "dist\engine\sherlock_engine.exe" "dist\JokiUsernameFinder\sherlock_engine.exe" >nul
if errorlevel 1 goto build_failed

echo.
echo BUILD BERHASIL!
echo Folder aplikasi: dist\JokiUsernameFinder\
echo Jalankan JokiUsernameFinder.exe
pause
exit /b 0

:build_failed
echo.
echo Build gagal. Periksa pesan error di atas.
pause
exit /b 1
