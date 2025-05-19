#!/bin/bash

set -e

echo "[SYSTEM]: Cleaning up old containers..."
docker compose down -v

echo "[SYSTEM]: Starting containers..."
docker compose up -d --build

echo "[SYSTEM]: Waiting for MySQL container to become healthy (max 60s)..."
timeout=60
elapsed=0
while [ "$(docker inspect --format='{{.State.Health.Status}}' mysql_todo)" != "healthy" ]; do
  if [ $elapsed -ge $timeout ]; then
    echo "[ERROR]: MySQL did not become healthy in time."
    docker compose logs db
    docker compose down -v
    exit 1
  fi
  sleep 2
  elapsed=$((elapsed + 2))
done

echo "[SYSTEM]: Running tests..."
docker compose exec web pytest

echo "[SYSTEM]: Cleaning up..."
docker compose down -v

echo "[SYSTEM]: All tests done successfully!"

