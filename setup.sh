#!/bin/bash
# ============================================================
#  GTUDemo Application Setup and Startup Script
#  Run: chmod +x setup.sh && ./setup.sh
# ============================================================

set -e

echo "============================================="
echo " Starting GTU Student Portal Setup"
echo "============================================="

# 1. Stop and clean existing containers
echo "Stopping any currently running containers..."
docker-compose down --remove-orphans || true

# 2. Rebuild and bring up the containers
echo "Building and launching containers in background..."
docker-compose up --build -d

# 3. Wait for database and Tomcat to launch
echo "Waiting for services to initialize (15 seconds)..."
sleep 15

echo "============================================="
echo " Setup Completed Successfully!"
echo " Application is running."
echo " Access URL: http://localhost:8080/GTUDemo/"
echo "============================================="
