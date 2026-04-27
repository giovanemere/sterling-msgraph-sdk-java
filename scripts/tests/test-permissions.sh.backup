#!/bin/bash

# Script para verificar permisos de Microsoft Graph
echo "🔍 Verificando permisos Microsoft Graph..."

# Load environment
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Obtener token
echo "🔐 Obteniendo token de acceso..."
TOKEN=$(./postman/get-jwt.sh 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "❌ No se pudo obtener token"
    exit 1
fi

echo "✅ Token obtenido"

# Verificar permisos básicos
echo ""
echo "📧 Verificando acceso a mailbox..."
MAILBOX_RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" \
    "https://graph.microsoft.com/v1.0/users/$MAIL_CORREO" \
    -w "%{http_code}")

HTTP_CODE="${MAILBOX_RESPONSE: -3}"
if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Acceso a usuario: OK"
else
    echo "❌ Acceso a usuario: FAILED (HTTP $HTTP_CODE)"
fi

# Verificar acceso a carpetas
echo ""
echo "📁 Verificando acceso a carpetas..."
FOLDERS_RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" \
    "https://graph.microsoft.com/v1.0/users/$MAIL_CORREO/mailFolders" \
    -w "%{http_code}")

FOLDERS_HTTP_CODE="${FOLDERS_RESPONSE: -3}"
if [ "$FOLDERS_HTTP_CODE" = "200" ]; then
    echo "✅ Acceso a carpetas: OK"
    
    # Buscar carpeta processed
    PROCESSED_EXISTS=$(echo "${FOLDERS_RESPONSE%???}" | jq -r '.value[] | select(.displayName == "processed") | .id' 2>/dev/null)
    if [ -n "$PROCESSED_EXISTS" ]; then
        echo "✅ Carpeta 'processed' existe: $PROCESSED_EXISTS"
    else
        echo "⚠️ Carpeta 'processed' no encontrada"
    fi
else
    echo "❌ Acceso a carpetas: FAILED (HTTP $FOLDERS_HTTP_CODE)"
fi

# Verificar permisos de escritura (crear carpeta test)
echo ""
echo "🔧 Verificando permisos de escritura..."
TEST_FOLDER_NAME="test_permissions_$(date +%s)"

CREATE_RESPONSE=$(curl -s -X POST \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"displayName\": \"$TEST_FOLDER_NAME\"}" \
    "https://graph.microsoft.com/v1.0/users/$MAIL_CORREO/mailFolders/inbox/childFolders" \
    -w "%{http_code}")

CREATE_HTTP_CODE="${CREATE_RESPONSE: -3}"
if [ "$CREATE_HTTP_CODE" = "201" ]; then
    echo "✅ Permisos de escritura: OK"
    
    # Limpiar carpeta de test
    FOLDER_ID=$(echo "${CREATE_RESPONSE%???}" | jq -r '.id' 2>/dev/null)
    if [ -n "$FOLDER_ID" ] && [ "$FOLDER_ID" != "null" ]; then
        curl -s -X DELETE \
            -H "Authorization: Bearer $TOKEN" \
            "https://graph.microsoft.com/v1.0/users/$MAIL_CORREO/mailFolders/$FOLDER_ID" > /dev/null
        echo "🧹 Carpeta de test eliminada"
    fi
else
    echo "❌ Permisos de escritura: FAILED (HTTP $CREATE_HTTP_CODE)"
    echo "   Response: ${CREATE_RESPONSE%???}" | head -c 200
fi

echo ""
echo "=================================="
echo "📊 Resumen de Permisos:"
echo "✅ Token: OK"
echo "$([ "$HTTP_CODE" = "200" ] && echo "✅" || echo "❌") Usuario: $HTTP_CODE"
echo "$([ "$FOLDERS_HTTP_CODE" = "200" ] && echo "✅" || echo "❌") Carpetas: $FOLDERS_HTTP_CODE"
echo "$([ "$CREATE_HTTP_CODE" = "201" ] && echo "✅" || echo "❌") Escritura: $CREATE_HTTP_CODE"

if [ "$CREATE_HTTP_CODE" != "201" ]; then
    echo ""
    echo "🔧 Permisos requeridos en Azure:"
    echo "   - Mail.ReadWrite"
    echo "   - Mail.ReadWrite.Shared"
    echo "   - MailboxSettings.Read"
    echo ""
    echo "📋 Verificar en Azure Portal:"
    echo "   App Registration → API Permissions → Grant admin consent"
fi
