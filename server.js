const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3001;

// MIME types for different file extensions
const mimeTypes = {
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'application/javascript',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
    // Parse the URL
    let filePath = req.url === '/' ? '/index.html' : req.url;
    filePath = path.join(__dirname, filePath);
    
    // Get file extension
    const extname = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[extname] || 'application/octet-stream';
    
    // Check if file exists
    fs.access(filePath, fs.constants.F_OK, (err) => {
        if (err) {
            // File not found
            res.writeHead(404, { 'Content-Type': 'text/html' });
            res.end(`
                <!DOCTYPE html>
                <html>
                <head>
                    <title>404 - File Not Found</title>
                    <style>
                        body { 
                            font-family: Arial, sans-serif; 
                            text-align: center; 
                            padding: 50px; 
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            min-height: 100vh;
                            margin: 0;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                        }
                        .error-container {
                            background: rgba(255,255,255,0.1);
                            padding: 40px;
                            border-radius: 20px;
                            backdrop-filter: blur(10px);
                        }
                        h1 { font-size: 3rem; margin-bottom: 20px; }
                        p { font-size: 1.2rem; margin-bottom: 30px; }
                        a { 
                            color: #fff; 
                            text-decoration: none; 
                            background: rgba(255,255,255,0.2);
                            padding: 15px 30px;
                            border-radius: 10px;
                            display: inline-block;
                            transition: all 0.3s ease;
                        }
                        a:hover { background: rgba(255,255,255,0.3); }
                    </style>
                </head>
                <body>
                    <div class="error-container">
                        <h1>🚀 Data Transmission Simulator</h1>
                        <p>File not found: ${req.url}</p>
                        <a href="/">← Go to Home</a>
                    </div>
                </body>
                </html>
            `);
            return;
        }
        
        // Read and serve the file
        fs.readFile(filePath, (err, data) => {
            if (err) {
                res.writeHead(500, { 'Content-Type': 'text/html' });
                res.end(`
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <title>500 - Server Error</title>
                        <style>
                            body { 
                                font-family: Arial, sans-serif; 
                                text-align: center; 
                                padding: 50px; 
                                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                                color: white;
                                min-height: 100vh;
                                margin: 0;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                            }
                            .error-container {
                                background: rgba(255,255,255,0.1);
                                padding: 40px;
                                border-radius: 20px;
                                backdrop-filter: blur(10px);
                            }
                            h1 { font-size: 3rem; margin-bottom: 20px; }
                            p { font-size: 1.2rem; margin-bottom: 30px; }
                            a { 
                                color: #fff; 
                                text-decoration: none; 
                                background: rgba(255,255,255,0.2);
                                padding: 15px 30px;
                                border-radius: 10px;
                                display: inline-block;
                                transition: all 0.3s ease;
                            }
                            a:hover { background: rgba(255,255,255,0.3); }
                        </style>
                    </head>
                    <body>
                        <div class="error-container">
                            <h1>🚀 Data Transmission Simulator</h1>
                            <p>Server error reading file: ${req.url}</p>
                            <a href="/">← Go to Home</a>
                        </div>
                    </body>
                    </html>
                `);
                return;
            }
            
            // Set headers and serve file
            res.writeHead(200, { 
                'Content-Type': contentType,
                'Cache-Control': 'no-cache, no-store, must-revalidate',
                'Pragma': 'no-cache',
                'Expires': '0'
            });
            res.end(data);
        });
    });
});

server.listen(PORT, () => {
    console.log(`
🚀 Data Transmission Simulator Server Started!

📍 Server running at: http://localhost:${PORT}
📁 Serving files from: ${__dirname}
🌐 Open your browser and navigate to: http://localhost:${PORT}

✨ Features:
   • Real-time data transmission simulation
   • Speed comparison (Your software vs 48-hour batch processing)
   • Beautiful modern UI with animations
   • Mobile responsive design

🛑 To stop the server: Press Ctrl+C

Happy coding! 🎉
    `);
});

// Handle server errors
server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.log(`❌ Port ${PORT} is already in use. Trying port ${PORT + 1}...`);
        server.listen(PORT + 1);
    } else {
        console.error('❌ Server error:', err);
    }
});

// Graceful shutdown
process.on('SIGINT', () => {
    console.log('\n🛑 Shutting down server...');
    server.close(() => {
        console.log('✅ Server closed successfully');
        process.exit(0);
    });
});
