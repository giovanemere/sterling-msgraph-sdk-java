#!/bin/bash

# Test para verificar estructura de carpetas
echo "🔍 Verificando estructura de carpetas Microsoft Graph..."

echo "📚 Documentación Microsoft Graph:"
echo ""
echo "✅ CORRECTO - Carpeta en raíz del buzón:"
echo "   POST /users/{id}/mailFolders"
echo "   Resultado: Carpeta al mismo nivel que Inbox"
echo ""
echo "❌ INCORRECTO - Subcarpeta de Inbox:"
echo "   POST /users/{id}/mailFolders/inbox/childFolders"
echo "   Resultado: Carpeta DENTRO de Inbox"
echo ""

echo "🔧 Código actual en createRootFolder():"
echo "   client.users().byUserId(userId).mailFolders().post(newFolder)"
echo "   ↑ Esto DEBERÍA crear en raíz"
echo ""

echo "🎯 Estructura esperada:"
echo "📧 Buzón"
echo "├── 📁 Inbox"
echo "├── 📁 processed ← AQUÍ (mismo nivel)"
echo "└── 📁 Sent Items"
echo ""

echo "❓ Si sigue creando en inbox, puede ser:"
echo "1. 🔍 El cliente Graph está interpretando mal el endpoint"
echo "2. 🔧 Hay permisos que fuerzan subcarpetas"
echo "3. 📧 El buzón tiene configuración especial"
echo "4. 🐛 Bug en el SDK de Microsoft Graph"
echo ""

echo "💡 Soluciones alternativas:"
echo "1. Usar API REST directa en lugar del SDK"
echo "2. Crear carpeta con parentFolderId explícito como null"
echo "3. Usar wellKnownFolderName diferente"
