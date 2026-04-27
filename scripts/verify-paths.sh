#!/bin/bash

# 🔍 Verificador de Rutas en Scripts
# Verifica que todos los scripts tengan rutas correctas

echo "🔍 Verificando rutas en scripts..."
echo "=================================="

# Función para verificar script
check_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    echo "📄 Verificando: $script_name"
    
    if [ ! -f "$script_path" ]; then
        echo "   ❌ Script no encontrado: $script_path"
        return 1
    fi
    
    # Verificar rutas comunes problemáticas
    local issues=0
    
    # Buscar referencias a JAR con ruta incorrecta
    if grep -q "target/.*\.jar" "$script_path" && [[ "$script_path" == *"/scripts/"* ]]; then
        echo "   ⚠️ Posible ruta incorrecta a JAR (debe ser ../../target/)"
        issues=$((issues + 1))
    fi
    
    # Buscar referencias a otros scripts con ruta incorrecta
    if grep -q "\./[^/]*\.sh" "$script_path" && [[ "$script_path" == *"/scripts/"* ]]; then
        echo "   ⚠️ Posible ruta incorrecta a script local"
        issues=$((issues + 1))
    fi
    
    if [ $issues -eq 0 ]; then
        echo "   ✅ Rutas OK"
    fi
    
    return $issues
}

# Verificar scripts principales
echo "🚀 Scripts principales:"
check_script "./build.sh"
check_script "./run-tests.sh"

echo ""
echo "🔨 Scripts de build:"
check_script "./scripts/build/compile.sh"
check_script "./scripts/build/check-hardcoded.sh"

echo ""
echo "🧪 Scripts de test:"
for script in ./scripts/tests/*.sh; do
    if [ -f "$script" ]; then
        check_script "$script"
    fi
done

echo ""
echo "🚀 Scripts de deployment:"
for script in ./scripts/deployment/*.sh; do
    if [ -f "$script" ]; then
        check_script "$script"
    fi
done

echo ""
echo "✅ Verificación completada"
