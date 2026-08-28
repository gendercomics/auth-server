#!/bin/bash
set -euo pipefail

BASE_DIR="${BASE_DIR:-/var/gendercomics/auth-server}"

log() { echo "[$(date '+%H:%M:%S')] $*"; }

log "=== gendercomics Auth Server Setup ==="

log "Creating external networks..."
docker network create proxy 2>/dev/null && log "  proxy: created" || log "  proxy: already exists"
echo ""

log "Starting infra stack (traefik + portainer)..."
docker compose -p auth-infra -f "$BASE_DIR/docker-compose.infra.yml" up -d
echo ""

log "Starting app stack (mysql + keycloak)..."
docker compose -p auth-app -f "$BASE_DIR/docker-compose.yml" up -d

echo ""
log "=== All services started ==="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
