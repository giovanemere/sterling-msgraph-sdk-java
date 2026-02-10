#!/bin/bash

# Cargar variables desde .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

# Validar variables requeridas
if [ -z "$TENANT_ID" ] || [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
    echo "Error: Missing required variables in .env file"
    echo "Required: TENANT_ID, CLIENT_ID, CLIENT_SECRET"
    exit 1
fi

# Obtener JWT token
curl -s -X POST "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&scope=$SCOPE&grant_type=$GRANT_TYPE" \
  | jq -r '.access_token'
