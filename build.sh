#!/bin/bash

# 🔨 Script Principal de Build
# Ejecuta el proceso completo de compilación

echo "🔨 Sterling Microsoft Graph SDK - Build"
echo "======================================="

# Verificar prerrequisitos
echo "🔍 Verificando prerrequisitos..."
java --version > /dev/null 2>&1 || { echo "❌ Java 17+ requerido"; exit 1; }
mvn --version > /dev/null 2>&1 || { echo "❌ Maven requerido"; exit 1; }

# Ejecutar build
if [ -f "scripts/build/compile.sh" ]; then
    echo "🚀 Ejecutando build completo..."
    ./scripts/build/compile.sh
else
    echo "🚀 Ejecutando build básico..."
    mvn clean package -DskipTests=false
fi

# Verificar resultado
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Build completado exitosamente"
    echo "📦 JAR shaded: target/O365InboxAttachmentToDisk-*.jar"
    ls -la target/*.jar 2>/dev/null || echo "⚠️ JAR no encontrado"
    if [ -f "scripts/build/sync-artifact-offline.sh" ]; then
        echo "📦 Paquete offline (JAR fino + deps)..."
        ./scripts/build/sync-artifact-offline.sh
    fi
else
    echo "❌ Build falló"
    exit 1
fi
