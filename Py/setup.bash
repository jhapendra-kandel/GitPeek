@echo off
:: ================================================================
:: GitPeek — Automatic Setup Script (Windows)
:: ================================================================
:: Usage: Double-click setup.bat  OR  run from Command Prompt
:: ================================================================
setlocal EnableDelayedExpansion

title GitPeek Setup

echo.
echo   ____ _ _   ____           _
echo  / ___(_) ^|_^|  _ \ ___  ___^| ^| __
echo ^| ^|  _^| ^| __^| ^|_) / _ \/ _ \ ^|/ /
echo ^| ^|_^| ^| ^| ^|_^|  __/  __/  __/   ^<
echo  \__^|^|_^|\__^|_^|   \_^|_^|\^|_^|_^|\_\
echo.
echo  GitPeek -- GitHub Repository Explorer
echo  Windows Setup Script v2.1.0
echo.

:: ── Check Python ─────────────────────────────────────────────────
echo [1/6] Checking Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo  ERROR: Python not found.
    echo  Install Python 3.8+ from https://python.org
    echo  Make sure to check "Add Python to PATH"
    pause & exit /b 1
)
for /f "tokens=*" %%v in ('python --version') do set PYVER=%%v
echo  OK: Found %PYVER%

:: Check version is 3.8+
python -c "import sys; sys.exit(0 if sys.version_info >= (3,8) else 1)" >nul 2>&1
if errorlevel 1 (
    echo  ERROR: Python 3.8 or newer is required.
    pause & exit /b 1
)

:: ── Check tkinter ────────────────────────────────────────────────
echo [2/6] Checking tkinter...
python -c "import tkinter" >nul 2>&1
if errorlevel 1 (
    echo  WARN: tkinter not found. GUI version may not work.
    echo  On Windows, reinstall Python and check "tcl/tk and IDLE" option.
) else (
    echo  OK: tkinter available
)

:: ── Create venv ──────────────────────────────────────────────────
echo [3/6] Setting up virtual environment...
if exist venv\ (
    echo  INFO: venv\ already exists - skipping
) else (
    python -m venv venv
    if errorlevel 1 (
        echo  ERROR: Failed to create virtual environment
        pause & exit /b 1
    )
    echo  OK: Created venv\
)

:: ── Activate venv ────────────────────────────────────────────────
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo  ERROR: Failed to activate virtual environment
    pause & exit /b 1
)
echo  OK: Virtual environment activated

:: ── Upgrade pip ──────────────────────────────────────────────────
echo [4/6] Upgrading pip...
python -m pip install --upgrade pip --quiet
echo  OK: pip up-to-date

:: ── Install packages ─────────────────────────────────────────────
echo [5/6] Installing dependencies...
pip install -r requirements.txt --quiet
if errorlevel 1 (
    echo  WARN: Some packages may have failed. Check output above.
) else (
    echo  OK: Dependencies installed
)

:: ── Create launcher batch files ──────────────────────────────────
echo [6/6] Creating launchers...

:: CLI launcher
(
  echo @echo off
  echo cd /d "%%~dp0"
  echo call venv\Scripts\activate.bat
  echo python Py\CLI\main.py %%*
) > gitpeek.bat
echo  OK: Created gitpeek.bat

:: GUI launcher
(
  echo @echo off
  echo cd /d "%%~dp0"
  echo call venv\Scripts\activate.bat
  echo python Py\GUI\main.py %%*
) > gitpeek-gui.bat
echo  OK: Created gitpeek-gui.bat

:: ── Done ─────────────────────────────────────────────────────────
echo.
echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo   Run CLI:   gitpeek.bat
echo   Run GUI:   gitpeek-gui.bat
echo.
echo   Quick test:
echo   gitpeek.bat -r torvalds/linux tree 2
echo.
echo   Set GitHub token (optional, higher rate limit):
echo   set GITHUB_TOKEN=ghp_yourtoken
echo.
echo   Read the setup guide: type SETUP.md
echo.
pause