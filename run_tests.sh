#!/bin/bash

set -e

echo "[SYSTEM]: Cleaning up old containers..."
docker compose down -v

echo "[SYSTEM]: Starting containers..."
docker compose up -d --build

timeout=60
until docker inspect --format='{{json .State.Health.Status}}' mysql_todo | grep -q '"healthy"' || [ $timeout -eq 0 ]; do
  echo "[SYSTEM]: Waiting for MySQL to become healthy... ($timeout seconds left)"
  sleep 2
  timeout=$((timeout - 2))
done

if [ $timeout -eq 0 ]; then
  echo "[ERROR]: MySQL container did not become healthy in time"
  exit 1
fi


echo "[SYSTEM]: Running tests..."
docker compose exec web pytest

echo "[SYSTEM]: Cleaning up..."
docker compose down -v

echo "[SYSTEM]: All tests done successfully!"

