#!/usr/bin/env python3
"""
Render-specific startup script for Open WebUI
Ensures proper port binding and environment setup for Render deployment
"""

import os
import sys
import subprocess
from pathlib import Path

def main():
    print("Starting Open WebUI for Render deployment...")
    
    # Set default values with Render's requirements
    port = os.environ.get('PORT', '10000')
    host = '0.0.0.0'
    
    print(f"Binding to host: {host}, port: {port}")
    
    # Change to backend directory
    backend_dir = Path(__file__).parent / 'backend'
    os.chdir(backend_dir)
    
    # Set environment variables
    os.environ['PORT'] = port
    os.environ['HOST'] = host
    
    # Handle secret key if not provided
    if not os.environ.get('WEBUI_SECRET_KEY'):
        import secrets
        import base64
        secret_key = base64.b64encode(secrets.token_bytes(12)).decode('utf-8')
        os.environ['WEBUI_SECRET_KEY'] = secret_key
        print("Generated WEBUI_SECRET_KEY")
    
    if not os.environ.get('WEBUI_JWT_SECRET_KEY'):
        os.environ['WEBUI_JWT_SECRET_KEY'] = os.environ['WEBUI_SECRET_KEY']
    
    # Set workers
    workers = os.environ.get('UVICORN_WORKERS', '1')
    
    print(f"Starting server on {host}:{port}")
    
    # Start the application
    cmd = [
        sys.executable, '-m', 'uvicorn', 'open_webui.main:app',
        '--host', host,
        '--port', port,
        '--forwarded-allow-ips', '*',
        '--workers', workers
    ]
    
    print(f"Executing: {' '.join(cmd)}")
    
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error starting application: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nShutting down...")
        sys.exit(0)

if __name__ == '__main__':
    main()