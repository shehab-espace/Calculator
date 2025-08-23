# Docker Setup for Calculator Application

This document provides instructions for building and running the Java Swing Calculator application using Docker.

## Prerequisites

- Docker installed on your system
- X11 display server running (for GUI applications)
- Linux environment (for X11 forwarding)

## Quick Start

### 1. Build the Docker Image

```bash
# Build the calculator image
docker build -t calculator:latest .
```

### 2. Allow X11 Connections (Required for GUI)

```bash
# Allow Docker containers to connect to your X11 display
xhost +local:docker
```

### 3. Run the Calculator

```bash
# Run the calculator with GUI support
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  calculator:latest
```

## Alternative Commands

### Build with Different Tags

```bash
# Build with version tag
docker build -t calculator:v1.0 .

# Build with custom name
docker build -t my-calculator:latest .

# Build without cache (if you have issues)
docker build --no-cache -t calculator:latest .
```

### Run with Different Options

```bash
# Run in background (detached)
docker run -d \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  calculator:latest

# Run with custom container name
docker run -it --rm \
  --name my-calculator \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  calculator:latest

# Run with resource limits
docker run -it --rm \
  --memory=512m \
  --cpus=1 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  calculator:latest
```

## Troubleshooting

### X11 Connection Issues

If you get X11 authorization errors:

```bash
# Check if X11 is running
echo $DISPLAY

# Allow all local connections (less secure)
xhost +local:

# Allow specific Docker connections
xhost +local:docker

# Check X11 permissions
xhost
```

### Missing Libraries

If you get library errors, rebuild the image:

```bash
# Rebuild with no cache
docker build --no-cache -t calculator:latest .
```

### Display Issues

If the GUI doesn't appear:

```bash
# Check if DISPLAY variable is set
echo $DISPLAY

# Try with different display
docker run -it --rm \
  -e DISPLAY=:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  calculator:latest
```

## Docker Compose (Alternative)

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  calculator:
    build: .
    container_name: java-calculator
    environment:
      - DISPLAY=${DISPLAY}
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix:rw
    network_mode: host
    stdin_open: true
    tty: true
```

Then run:

```bash
# Build and run with docker-compose
docker-compose up --build

# Run in background
docker-compose up -d --build
```

## Image Details

### What's Included

- **Base Image**: OpenJDK 11
- **Build Tool**: Maven
- **X11 Libraries**: All necessary libraries for Swing GUI
- **Application**: Java Swing Calculator

### Ports

- **No ports exposed** - This is a GUI application, not a web service

### Volumes

- **X11 Socket**: `/tmp/.X11-unix` (for GUI display)

## Security Notes

⚠️ **X11 Forwarding Security**: 
- `xhost +local:docker` allows Docker containers to access your display
- This is generally safe for local development
- For production, consider converting to a web application

## Next Steps

For web deployment, consider:
1. Converting to Spring Boot web application
2. Creating REST API endpoints
3. Building web-based UI
4. Exposing port 8080 for HTTP access

## Support

If you encounter issues:
1. Check that X11 is running: `echo $DISPLAY`
2. Verify Docker is running: `docker info`
3. Rebuild with no cache: `docker build --no-cache -t calculator:latest .`
4. Check system logs: `docker logs <container_id>`
