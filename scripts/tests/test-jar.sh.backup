#!/bin/bash

# Test script for JAR functionality
echo "🧪 Testing JAR file functionality..."

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Test JWT generation
echo "🔐 Testing JWT generation..."
TOKEN=$(./get-jwt.sh)
if [ -n "$TOKEN" ]; then
    echo "✅ JWT token generated successfully"
    echo "Token length: ${#TOKEN} characters"
else
    echo "❌ Failed to generate JWT token"
    exit 1
fi

# Test JAR execution with original parameters
echo "📦 Testing JAR execution..."
java -cp "target/O365InboxAttachmentToDisk-5.4.0.jar" co.com.edtech.msgraph.App \
    -client "$CLIENT_ID" \
    -tenant "$TENANT_ID" \
    -secret "$CLIENT_SECRET" \
    -email "$MAIL_CORREO" \
    -dir "$PATH_DESTINATION" \
    -help 2>&1 | head -10

echo "🎉 JAR test completed"
