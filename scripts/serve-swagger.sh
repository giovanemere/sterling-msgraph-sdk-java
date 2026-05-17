#!/usr/bin/env bash
# Sirve Swagger UI + OpenAPI desde openapi/ (requiere HTTP, no file://)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENAPI_DIR="${ROOT}/openapi"
PORT="${SWAGGER_PORT:-8088}"

cd "$OPENAPI_DIR"

echo "Swagger UI: http://127.0.0.1:${PORT}/"
echo "OpenAPI:    http://127.0.0.1:${PORT}/o365-sterling-graph.openapi.yaml"
echo "Documentación: openapi/README.md"
echo "Ctrl+C para detener."

if command -v python3 >/dev/null 2>&1; then
  exec python3 -m http.server "$PORT" --bind 127.0.0.1
elif command -v python >/dev/null 2>&1; then
  exec python -m SimpleHTTPServer "$PORT" 2>/dev/null || python -m http.server "$PORT" --bind 127.0.0.1
else
  echo "Error: se necesita python3 para servir archivos estáticos." >&2
  exit 1
fi
