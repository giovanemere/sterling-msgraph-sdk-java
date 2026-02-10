#!/bin/bash

# Microsoft Graph Sterling - Enhanced Version
# Script de ejecución con nuevas funcionalidades

# Cargar variables de entorno
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Configuración por defecto
JAVA_OPTS="-Xmx512m -Xms256m"
JAR_FILE="target/O365InboxAttachmentToDisk-5.4.0.jar"
MAIN_CLASS="co.com.edtech.msgraph.App"

# Función para mostrar ayuda
show_help() {
    echo "=== Microsoft Graph Sterling - Enhanced Version ==="
    echo "Usage: $0 [mode] [options]"
    echo ""
    echo "Modes:"
    echo "  standard    Standard processing (default)"
    echo "  batch       Batch processing of all messages"
    echo "  list        List messages in processed folder"
    echo "  help        Show this help"
    echo ""
    echo "Environment variables required:"
    echo "  TENANT_ID, CLIENT_ID, CLIENT_SECRET, MAIL_CORREO, PATH_DESTINATION"
    echo ""
    echo "Examples:"
    echo "  $0 standard                    # Standard processing"
    echo "  $0 batch                       # Batch processing"
    echo "  $0 list                        # List processed messages"
    echo ""
}

# Función para validar variables de entorno
validate_env() {
    local missing_vars=()
    
    [ -z "$TENANT_ID" ] && missing_vars+=("TENANT_ID")
    [ -z "$CLIENT_ID" ] && missing_vars+=("CLIENT_ID")
    [ -z "$CLIENT_SECRET" ] && missing_vars+=("CLIENT_SECRET")
    [ -z "$MAIL_CORREO" ] && missing_vars+=("MAIL_CORREO")
    
    if [ ${#missing_vars[@]} -ne 0 ]; then
        echo "❌ Missing required environment variables: ${missing_vars[*]}"
        echo "Please set them in .env file or export them"
        exit 1
    fi
}

# Función para construir el classpath
build_classpath() {
    CLASSPATH="$JAR_FILE"
    if [ -d "target/lib" ]; then
        for jar in target/lib/*.jar; do
            CLASSPATH="$CLASSPATH:$jar"
        done
    fi
}

# Función para ejecutar en modo estándar
run_standard() {
    echo "🚀 Starting Standard Processing Mode"
    
    if [ -z "$PATH_DESTINATION" ]; then
        echo "❌ PATH_DESTINATION is required for standard mode"
        exit 1
    fi
    
    java $JAVA_OPTS -cp "$CLASSPATH" $MAIN_CLASS \
        -client "$CLIENT_ID" \
        -tenant "$TENANT_ID" \
        -secret "$CLIENT_SECRET" \
        -email "$MAIL_CORREO" \
        -dir "$PATH_DESTINATION" \
        ${PROXY_HOST:+-host "$PROXY_HOST"} \
        ${PROXY_PORT:+-port "$PROXY_PORT"} \
        ${PRIVATE_CERTIFICATE:+-certificate "$PRIVATE_CERTIFICATE"} \
        ${CERTIFICATE_PASSWORD:+-certificatePassword "$CERTIFICATE_PASSWORD"}
}

# Función para ejecutar en modo batch
run_batch() {
    echo "📦 Starting Batch Processing Mode"
    
    if [ -z "$PATH_DESTINATION" ]; then
        echo "❌ PATH_DESTINATION is required for batch mode"
        exit 1
    fi
    
    java $JAVA_OPTS -cp "$CLASSPATH" $MAIN_CLASS \
        -client "$CLIENT_ID" \
        -tenant "$TENANT_ID" \
        -secret "$CLIENT_SECRET" \
        -email "$MAIL_CORREO" \
        -dir "$PATH_DESTINATION" \
        -batch true \
        ${PROXY_HOST:+-host "$PROXY_HOST"} \
        ${PROXY_PORT:+-port "$PROXY_PORT"} \
        ${PRIVATE_CERTIFICATE:+-certificate "$PRIVATE_CERTIFICATE"} \
        ${CERTIFICATE_PASSWORD:+-certificatePassword "$CERTIFICATE_PASSWORD"}
}

# Función para listar mensajes procesados
run_list() {
    echo "📋 Listing Processed Messages"
    
    java $JAVA_OPTS -cp "$CLASSPATH" $MAIN_CLASS \
        -client "$CLIENT_ID" \
        -tenant "$TENANT_ID" \
        -secret "$CLIENT_SECRET" \
        -email "$MAIL_CORREO" \
        -list true \
        ${PROXY_HOST:+-host "$PROXY_HOST"} \
        ${PROXY_PORT:+-port "$PROXY_PORT"} \
        ${PRIVATE_CERTIFICATE:+-certificate "$PRIVATE_CERTIFICATE"} \
        ${CERTIFICATE_PASSWORD:+-certificatePassword "$CERTIFICATE_PASSWORD"}
}

# Función principal
main() {
    local mode="${1:-standard}"
    
    case "$mode" in
        "help"|"-h"|"--help")
            show_help
            exit 0
            ;;
        "standard"|"")
            validate_env
            build_classpath
            run_standard
            ;;
        "batch")
            validate_env
            build_classpath
            run_batch
            ;;
        "list")
            validate_env
            build_classpath
            run_list
            ;;
        *)
            echo "❌ Unknown mode: $mode"
            show_help
            exit 1
            ;;
    esac
}

# Verificar que el JAR existe
if [ ! -f "$JAR_FILE" ]; then
    echo "❌ JAR file not found: $JAR_FILE"
    echo "Please run: mvn clean install"
    exit 1
fi

# Ejecutar función principal
main "$@"
