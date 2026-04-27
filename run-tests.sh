#!/bin/bash

# 🧪 Script Principal de Testing
# Ejecuta todos los tests disponibles para la solución

echo "🧪 Sterling Microsoft Graph SDK - Test Suite"
echo "============================================="

# Verificar que estamos en el directorio correcto
if [ ! -f "pom.xml" ]; then
    echo "❌ Error: Ejecutar desde el directorio raíz del proyecto"
    exit 1
fi

# Función para ejecutar test con logging
run_test() {
    local test_name="$1"
    local test_script="$2"
    
    echo ""
    echo "🔍 Ejecutando: $test_name"
    echo "----------------------------------------"
    
    if [ -f "$test_script" ]; then
        chmod +x "$test_script"
        "$test_script"
        if [ $? -eq 0 ]; then
            echo "✅ $test_name: PASSED"
        else
            echo "❌ $test_name: FAILED"
        fi
    else
        echo "⚠️ $test_name: Script no encontrado ($test_script)"
    fi
}

# Tests disponibles
echo "📋 Tests disponibles:"
echo "   1. Build y compilación"
echo "   2. Configuración simplificada (deleteditems)"
echo "   3. Integración con Microsoft Graph"
echo "   4. Validación de permisos"
echo "   5. Funcionalidad completa"
echo ""

# Ejecutar tests
run_test "Build y Compilación" "scripts/build/compile.sh"
run_test "Test Carpeta Eliminados" "scripts/tests/test-deleteditems.sh"
run_test "Test Integración" "scripts/tests/test-integration.sh"
run_test "Test Permisos" "scripts/tests/test-permissions.sh"
run_test "Test Funcionalidad" "scripts/tests/test-functionality.sh"

echo ""
echo "🎉 Test Suite completado"
echo "📁 Logs individuales disponibles en cada script"
