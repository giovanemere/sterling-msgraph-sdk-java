#!/bin/bash

# Test script para verificar carpeta processed
echo "🔍 Verificando configuración de carpeta processed..."

# Load environment
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ Variables cargadas desde .env"
else
    echo "❌ Archivo .env no encontrado"
fi

echo "📁 PROCESSED_FOLDER configurado: '$PROCESSED_FOLDER'"

# Compilar y ejecutar con debug
echo "🔨 Compilando..."
mvn compile -q

if [ $? -eq 0 ]; then
    echo "✅ Compilación exitosa"
    
    # Ejecutar con variables de entorno
    echo "🚀 Ejecutando con debug..."
    echo "   PROCESSED_FOLDER=$PROCESSED_FOLDER"
    echo "   MAIL_CORREO=$MAIL_CORREO"
    
    # Simular ejecución (sin ejecutar realmente)
    echo "📧 Simulando procesamiento..."
    echo "   - Buscando carpeta: '$PROCESSED_FOLDER'"
    echo "   - Nivel: Raíz del buzón (mismo nivel que inbox)"
    echo "   - Usuario: $MAIL_CORREO"
    
else
    echo "❌ Error en compilación"
fi
