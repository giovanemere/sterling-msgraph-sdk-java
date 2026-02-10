#!/bin/bash

# Postman Collection Organization Test
echo "📋 Testing Postman Collection Organization..."

# Check if collection files exist
echo "🔍 Checking Postman files..."

COLLECTION_FILE="Microsoft_Graph_Sterling_Complete.postman_collection.json"
ENVIRONMENT_FILE="Sterling_Graph_Environment.postman_environment.json"

if [ -f "$COLLECTION_FILE" ]; then
    echo "✅ Collection file found: $COLLECTION_FILE"
    
    # Check collection structure
    echo "📊 Collection structure:"
    jq -r '.item[].name' "$COLLECTION_FILE" 2>/dev/null | sed 's/^/  - /'
    
    # Count total requests
    TOTAL_REQUESTS=$(jq '[.. | objects | select(has("request"))] | length' "$COLLECTION_FILE" 2>/dev/null)
    echo "📈 Total requests: $TOTAL_REQUESTS"
else
    echo "❌ Collection file not found: $COLLECTION_FILE"
fi

if [ -f "$ENVIRONMENT_FILE" ]; then
    echo "✅ Environment file found: $ENVIRONMENT_FILE"
    
    # Check environment variables
    echo "🔧 Environment variables:"
    jq -r '.values[] | select(.enabled == true) | "  - " + .key + " = " + (.value // "")' "$ENVIRONMENT_FILE" 2>/dev/null | head -10
else
    echo "❌ Environment file not found: $ENVIRONMENT_FILE"
fi

# Check documentation
echo "📚 Checking documentation..."
if [ -f "docs/postman.md" ]; then
    echo "✅ Unified Postman documentation found"
    
    # Check documentation sections
    echo "📖 Documentation sections:"
    grep "^##" docs/postman.md | sed 's/^/  /'
    
    # Count lines
    LINES=$(wc -l < docs/postman.md)
    echo "📏 Documentation length: $LINES lines"
else
    echo "❌ Postman documentation not found"
fi

# Test JWT script
echo "🔐 Testing JWT generation..."
if [ -f "get-jwt.sh" ] && [ -x "get-jwt.sh" ]; then
    echo "✅ JWT script is executable"
    
    # Test JWT generation (with timeout)
    if timeout 10s ./get-jwt.sh > /dev/null 2>&1; then
        echo "✅ JWT generation successful"
    else
        echo "⚠️  JWT generation failed or timed out"
    fi
else
    echo "❌ JWT script not found or not executable"
fi

# Check environment file
echo "⚙️  Checking environment configuration..."
if [ -f ".env" ]; then
    echo "✅ Environment file found"
    
    # Check required variables
    REQUIRED_VARS=("TENANT_ID" "CLIENT_ID" "CLIENT_SECRET" "MAIL_CORREO")
    for var in "${REQUIRED_VARS[@]}"; do
        if grep -q "^$var=" .env; then
            echo "  ✅ $var configured"
        else
            echo "  ❌ $var missing"
        fi
    done
else
    echo "❌ Environment file (.env) not found"
fi

echo "🎉 Postman organization test completed!"
