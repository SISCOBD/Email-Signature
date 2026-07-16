@echo off
cd /d "%~dp0"

if not exist "signature-assets\sisco-logo.png" (
    echo Extracting images...
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1"
    if errorlevel 1 (
        echo Setup failed.
        pause
        exit /b 1
    )
)

echo Opening SISCO Email Signature Generator...
start "" "%~dp0index.html"
