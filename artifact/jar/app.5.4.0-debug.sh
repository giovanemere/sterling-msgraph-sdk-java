#!/bin/sh
# app.5.0.0.sh
# Script para ejecutar la aplicación O365InboxAttachmentToDisk con configuración cifrada.
# Ejemplo de Ejecución
#cd /gfssterling/jar && ./app.5.4.0.sh "sfg_domiciliacion@edtech.com.co" "12345"


# Configuración
CONFIG_FILE="/gfssterling/jar/app.conf" # Ruta del archivo de configuración
MAIL_LIST_FILE="/gfssterling/jar/mail_list" # Ruta del archivo mail_list

# Funciones
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        while IFS='=' read -r key value; do
            export "$key=$(eval echo "$value")"
        done < "$CONFIG_FILE"
    else
        echo "Error: Archivo de configuración '$CONFIG_FILE' no encontrado."
        exit 1
    fi
}

decrypt_config() {
    local email="$1"
    local ruta_cipher="$PathGFS/cipher"
    local ruta_file="$ruta_cipher"
    local file_cipher="$ruta_file/clave.enc"
    local key_private="$ruta_file/llavecifrado.key"
    local key_cipher="--pwdfile $file_cipher --pwdkey $key_private"

    if [ ! -f "$MAIL_LIST_FILE" ]; then
        echo "Error: Archivo mail_list '$MAIL_LIST_FILE' no encontrado."
        return 1
    fi

    local filter_user=$(awk -F':' -v email="$email" '$1 ~ email {print $2}' "$MAIL_LIST_FILE")
    if [ -z "$filter_user" ]; then
        echo "Error: Correo electrónico '$email' no encontrado en mail_list."
        return 1
    fi


    echo "filter_user=$filter_user"
    
    local correo_convenio="$filter_user"
    local file_dec="$correo_convenio.enc"
    local file_out="$correo_convenio"_out
    local name_certificate="$correo_convenio"

    echo "name_certificate : $name_certificate"
    echo "file_dec : $ruta_file/$file_dec"
    echo "file_out : $ruta_file/$file_out"
    echo "key_cipher : $key_cipher"

    if [ -z "$ruta_file" ] || [ -z "$file_out" ]; then
        echo "Error: Variables ruta_file o file_out vacías."
        return 1
    fi

    echo "-------------------------------------------------"
    echo "Variables a cargar"
    read -p "Press [Enter] key to continue..." readEnterKey

    
    exec_decryt="decrypt -n $name_certificate -i $ruta_file/$file_dec -o $ruta_file/$file_out $key_cipher"
    echo exec_decryt

    # ejecutar desencriptación
    cd "$ruta_cipher" && ./CipherConsole $exec_decryt


    if [ $? -ne 0 ]; then
        echo "Error: Falló la desencriptación del archivo de configuración."
        return 1
    fi

    eval "$(cat "$ruta_file/$file_out" | sed 's/^/export /')"
    #rm "$ruta_file/$file_out"

    echo "client=$client"
    echo "tenant=$tenant"
    echo "privateCertificate=$privateCertificate"
    echo "certificatePassword=$certificatePassword"
    echo "proxy=$proxy"
    echo "proxyPort=$proxyPort"

    echo "-------------------------------------------------"
    echo "Variables a cargar"
    read -p "Press [Enter] key to continue..." readEnterKey

    return 0
}

# Inicio del script
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Se requieren dos parámetros (correo electrónico y WFID)."
    exit 1
fi

# Cargar configuración global (config.properties)
load_config

# Validar variables necesarias para la aplicación
mail_correo="$1"
wfid="$2"
pathd="$PathJar/mail-attachment/$wfid"


echo "PathGFS                = $PathGFS"
echo "PathJar                = $PathJar"
echo "FileJar                = $FileJar"
echo "JAVA_HOME              = $JAVA_HOME"
echo "JARPATH                = $JARPATH"
echo "REPO                   = $REPO"
echo "NETTY_VERSION          = $NETTY_VERSION"
echo "NETTY_TCNATIVE_VERSION = $NETTY_TCNATIVE_VERSION"
echo "pathd                  = $pathd"

echo "-------------------------------------------------"
echo "Variables a cargar"
read -p "Press [Enter] key to continue..." readEnterKey

# Desencriptar configuración específica del usuario
if ! decrypt_config "$mail_correo"; then
    exit 1
fi

# Validar variables necesarias para la aplicación
if [ -z "$client" ] || [ -z "$tenant" ] || [ -z "$mail_correo" ] || [ -z "$pathd" ] || [ -z "$privateCertificate" ] || [ -z "$certificatePassword" ] || [ -z "$proxy" ] || [ -z "$proxyPort" ]; then
    echo "Error: Variables de configuración no definidas."
    exit 1
fi


# Directorio base (ajusta esto si es necesario)
BASEDIR="$JARPATH"

# Classpath
CLASSPATH="$BASEDIR/etc:$REPO/netty-buffer-$NETTY_VERSION.jar:$REPO/netty-codec-$NETTY_VERSION.jar:$REPO/netty-codec-http-$NETTY_VERSION.jar:$REPO/netty-codec-http2-$NETTY_VERSION.jar:$REPO/netty-common-$NETTY_VERSION.jar:$REPO/netty-handler-$NETTY_VERSION.jar:$REPO/netty-handler-proxy-$NETTY_VERSION.jar:$JARPATH/$FileJar:$REPO/netty-tcnative-boringssl-static-$NETTY_TCNATIVE_VERSION.Final.jar"


### Crear Carpet Temporal
  mkdir -p "$pathd"

### Ejecutar Servicio
  "$JAVA_HOME/bin/java" -cp "$CLASSPATH" co.com.edtech.msgraph.App \
    -client "$client" \
    -tenant "$tenant" \
    -certificate "$privateCertificate" \
    -email "$mail_correo" \
    -dir "$pathd/" \
    -certificatePassword "$certificatePassword" \
    -host "$proxy" \
    -port "$proxyPort"
  
  # Verificar el código de salida
  if [ $? -ne 0 ]; then
      echo "Error: La aplicación Java falló."
      exit 1
  fi

  valListF=$(find "$pathd/" -type f -name '*.*' | wc -l )
  if [ "$valListF" -eq 0 ]
    then
        echo "-------------------------------------------------"
        echo " Sin Archivos a procesar"
        echo "-------------------------------------------------"
        exit 1
    else

      echo '<root>' > "$pathd/ListF.xml" & find "$pathd/" -type f -name '*.*' | xargs -i echo "<filename>{}</filename>" >> "$pathd/ListF.xml" && echo '</root>' >> "$pathd/ListF.xml"
      echo "-------------------------------------------------"
      echo " Archivos procesados"
      echo "-------------------------------------------------"
      cat -b "$pathd/ListF.xml"

  fi

