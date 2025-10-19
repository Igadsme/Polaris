@echo off
echo.
echo ========================================
echo    🚀 Polaris Showcase Server
echo ========================================
echo.
echo Starting Polaris showcase server...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js detected
echo.

REM Start the server
echo 🌐 Starting server on port 3001...
echo.
echo 📍 Server will be available at: http://localhost:3001
echo.
echo 🛑 To stop the server: Press Ctrl+C
echo.

node server.js

pause