#!/bin/bash

echo ""
echo "========================================"
echo "   🚀 Polaris Showcase Server"
echo "========================================"
echo ""
echo "Starting Polaris showcase server..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed or not in PATH"
    echo "Please install Node.js from https://nodejs.org/"
    echo ""
    exit 1
fi

echo "✅ Node.js detected"
echo ""

# Start the server
echo "🌐 Starting server on port 3001..."
echo ""
echo "📍 Server will be available at: http://localhost:3001"
echo ""
echo "🛑 To stop the server: Press Ctrl+C"
echo ""

node server.js