#!/bin/bash

SERVICE_NAME="db"
MAX_RETRIES=30

echo "[SCRIPT]: Waiting for service '$SERVICE_NAME' to become healthy..."

attempt=0
while [[ "$(docker inspect --format='{{.State.Health.Status}}' devops-demo_${SERVICE_NAME}_1 2>/dev/null)" != "healthy" ]]; do
  if [ "$attempt" -ge "$MAX_RETRIES" ]; then
    echo "[SCRIPT]: $SERVICE_NAME did not become healthy after $((MAX_RETRIES * SLEEP_TIME)) seconds."
    exit 1
  fi
  echo "[SCRIPT]: Attempt $((attempt+1))/$MAX_RETRIES..."
  attempt=$((attempt+1))
  sleep 2
done

echo "[SCRIPT]: $SERVICE_NAME is healthy. Running tests..."

exec "$@"
