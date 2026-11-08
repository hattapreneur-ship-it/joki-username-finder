@echo off
setlocal EnableExtensions
cd /d "%~dp0"
title Joki Username Finder - Setup

set "PY_CMD="
for %%V in (3.13 3.12 3.11 3.10) do (
    py -%%V -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) else 1)" >nul 2>&1
    if not errorlevel 1 (
        set "PY_CMD=py -%%V"
        goto python_found
    )
)

python -c "import sys; raise SystemExit(0 if sys.version_info >= (3,10) and sys.version_info < (3,14) else 1)" >nul 2>&1
if not errorlevel 1 set "PY_CMD=python"

:python_found
if not defined PY_CMD (
    echo.
    echo Python 3.10 - 3.13 belum ditemukan.
    echo Silakan instal Python dari https://www.python.org/downloads/windows/
    echo Saat instalasi, aktifkan opsi Add Python to PATH.
    echo.
    pause
    exit /b 1
)

if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Membuat environment aplikasi...
    %PY_CMD% -m venv .venv
    if errorlevel 1 goto setup_failed
)

set "VENV_PY=%CD%\.venv\Scripts\python.exe"
"%VENV_PY%" -c "import PySide6, sherlock_project, requests, openpyxl, reportlab" >nul 2>&1
if errorlevel 1 (
    echo [2/3] Memasang dependency dan Sherlock. Proses pertama memerlukan internet...
    "%VENV_PY%" -m pip install --upgrade pip
    if errorlevel 1 goto setup_failed
    "%VENV_PY%" -m pip install -r requirements.txt
    if errorlevel 1 goto setup_failed
) else (
    echo [2/3] Dependency sudah tersedia.
)

echo [3/3] Menjalankan Joki Username Finder...
start "" "%CD%\.venv\Scripts\pythonw.exe" -m app.main
exit /b 0

:setup_failed
echo.
echo Setup gagal. Periksa koneksi internet dan pesan error di atas.
echo Jika perlu, hapus folder .venv lalu jalankan run.bat kembali.
echo.
pause
exit /b 1
