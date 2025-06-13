#!/bin/bash

# Render-specific startup script for Open WebUI
# This script ensures proper port binding for Render deployment

set -e

echo "Starting Open WebUI for Render deployment..."

# Set default values with Render's requirements
PORT="${PORT:-10000}"
HOST="0.0.0.0"

echo "Binding to host: $HOST, port: $PORT"

# Navigate to backend directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR/backend" || exit

# Handle secret key
if [ -n "${WEBUI_SECRET_KEY_FILE}" ]; then
    KEY_FILE="${WEBUI_SECRET_KEY_FILE}"
else
    KEY_FILE=".webui_secret_key"
fi

if test "$WEBUI_SECRET_KEY $WEBUI_JWT_SECRET_KEY" = " "; then
  echo "Loading WEBUI_SECRET_KEY from file, not provided as an environment variable."

  if ! [ -e "$KEY_FILE" ]; then
    echo "Generating WEBUI_SECRET_KEY"
    # Generate a random value to use as a WEBUI_SECRET_KEY in case the user didn't provide one.
    echo $(head -c 12 /dev/urandom | base64) > "$KEY_FILE"
  fi

  echo "Loading WEBUI_SECRET_KEY from $KEY_FILE"
  WEBUI_SECRET_KEY=$(cat "$KEY_FILE")
fi

if [ "$WEBUI_JWT_SECRET_KEY" = "" ]; then
  WEBUI_JWT_SECRET_KEY="$WEBUI_SECRET_KEY"
fi

# Install Python dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
fi

# Set Python command
PYTHON_CMD=$(command -v python3 || command -v python)

echo "Starting server on $HOST:$PORT"

# Start the application with explicit port binding
WEBUI_SECRET_KEY="$WEBUI_SECRET_KEY" exec "$PYTHON_CMD" -m uvicorn open_webui.main:app --host "$HOST" --port "$PORT" --forwarded-allow-ips '*' --workers "${UVICORN_WORKERS:-1}"