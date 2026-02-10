#!/bin/bash

# Script de compilación para Microsoft Graph Sterling
echo "🔨 Compilando Microsoft Graph Sterling..."

# Limpiar y compilar
mvn clean compile -q

if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    
    # Generar JAR
    echo "📦 Generando JAR..."
    mvn package -DskipTests -q
    
    if [ $? -eq 0 ]; then
        echo "✅ JAR generado exitosamente"
        echo "📁 Ubicación: target/O365InboxAttachmentToDisk-5.4.1.jar"
        echo "📏 Tamaño: $(du -h target/O365InboxAttachmentToDisk-5.4.1.jar | cut -f1)"
    else
        echo "❌ Error generando JAR"
        exit 1
    fi
else
    echo "❌ Error en compilación"
    exit 1
fi

echo "🎉 Compilación completa!"
