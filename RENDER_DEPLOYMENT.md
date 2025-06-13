# Deploying Open WebUI to Render

This guide will help you deploy Open WebUI to Render with proper port binding configuration.

## Quick Deploy

### Option 1: Using render.yaml (Recommended)

1. Fork this repository to your GitHub account
2. Connect your GitHub account to Render
3. Create a new Web Service on Render
4. Connect your forked repository
5. Render will automatically detect the `render.yaml` file and configure the service

### Option 2: Manual Configuration

If you prefer manual setup:

1. **Create a new Web Service** on Render
2. **Connect your repository**
3. **Configure the following settings:**

   - **Name**: `open-webui`
   - **Runtime**: `Python`
   - **Build Command**:
     ```bash
     npm install && npm run build && cd backend && pip install -r requirements.txt
     ```
   - **Start Command**:
     ```bash
     python start_render.py
     ```

4. **Set Environment Variables:**
   - `PORT`: `10000` (or leave empty to use Render's default)
   - `HOST`: `0.0.0.0`
   - `WEBUI_SECRET_KEY`: Generate a random string
   - `UVICORN_WORKERS`: `1`

## Files Created for Render Deployment

### 1. `render.yaml`
Automatic configuration file for Render deployment.

### 2. `start_render.py`
Python startup script that ensures proper port binding and environment setup.

### 3. `render-start.sh`
Bash alternative startup script (backup option).

## Troubleshooting

### "No open ports detected" Error

This error occurs when the application doesn't bind to the correct port. The files created above solve this by:

1. **Explicit Port Binding**: Using the `PORT` environment variable that Render provides
2. **Host Configuration**: Binding to `0.0.0.0` instead of `localhost`
3. **Proper Startup**: Using uvicorn with correct parameters

### Memory Issues

If you encounter "Out of memory" errors:

1. **Upgrade Plan**: Consider upgrading from the free tier
2. **Reduce Workers**: Set `UVICORN_WORKERS=1`
3. **Optimize Build**: The build process requires significant memory

### Build Failures

If the build fails:

1. **Check Node.js Version**: Ensure compatibility
2. **Python Dependencies**: Verify all requirements are installable
3. **Build Logs**: Check Render's build logs for specific errors

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `10000` | Port to bind the application |
| `HOST` | `0.0.0.0` | Host address to bind |
| `WEBUI_SECRET_KEY` | Generated | Secret key for the application |
| `UVICORN_WORKERS` | `1` | Number of worker processes |

## Health Check

The application includes a health endpoint at `/health` which Render uses to verify the service is running correctly.

## Support

If you continue to experience issues:

1. Check the Render deployment logs
2. Verify all environment variables are set correctly
3. Ensure the repository is properly connected
4. Try redeploying the service

## Alternative Deployment Methods

If Render deployment continues to fail, consider:

1. **Railway**: Similar platform with different configuration
2. **Heroku**: Traditional PaaS platform
3. **Docker**: Using the provided Dockerfile
4. **VPS**: Manual deployment on a virtual private server