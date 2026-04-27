#!/bin/bash

# 🔧 Corrector de Rutas en Scripts
# Corrige automáticamente las rutas en todos los scripts

echo "🔧 Corrigiendo rutas en scripts..."
echo "=================================="

# Función para corregir rutas en un script
fix_script_paths() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    echo "📄 Corrigiendo: $script_name"
    
    if [ ! -f "$script_path" ]; then
        echo "   ❌ Script no encontrado: $script_path"
        return 1
    fi
    
    # Backup del script original
    cp "$script_path" "$script_path.backup"
    
    # Correcciones específicas para scripts en /scripts/tests/
    if [[ "$script_path" == *"/scripts/tests/"* ]]; then
        # Corregir rutas a JAR
        sed -i 's|target/O365InboxAttachmentToDisk-|../../target/O365InboxAttachmentToDisk-|g' "$script_path"
        sed -i 's|ls target/|ls ../../target/|g' "$script_path"
        sed -i 's|find target/|find ../../target/|g' "$script_path"
        sed -i 's|java -cp target/|java -cp ../../target/|g' "$script_path"
        sed -i 's|java -jar target/|java -jar ../../target/|g' "$script_path"
        
        # Corregir referencias a scripts de build
        sed -i 's|\./compile\.sh|../../scripts/build/compile.sh|g' "$script_path"
        sed -i 's|\./build\.sh|../../build.sh|g' "$script_path"
    fi
    
    # Correcciones específicas para scripts en /scripts/build/
    if [[ "$script_path" == *"/scripts/build/"* ]]; then
        # Corregir rutas relativas al directorio raíz
        sed -i 's|target/O365InboxAttachmentToDisk-|../../target/O365InboxAttachmentToDisk-|g' "$script_path"
    fi
    
    echo "   ✅ Corregido"
}

# Corregir scripts de test
echo "🧪 Corrigiendo scripts de test:"
for script in ./scripts/tests/*.sh; do
    if [ -f "$script" ]; then
        fix_script_paths "$script"
    fi
done

echo ""
echo "🔨 Corrigiendo scripts de build:"
for script in ./scripts/build/*.sh; do
    if [ -f "$script" ]; then
        fix_script_paths "$script"
    fi
done

echo ""
echo "✅ Corrección completada"
echo "📁 Backups guardados como *.backup"
