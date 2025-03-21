#!/bin/sh
# app.5.0.0.sh
# Script para ejecutar la aplicación O365InboxAttachmentToDisk con configuración cifrada.
# Ejemplo de Ejecución:
# cd /gfssterling/jar && ./app.5.0.0.sh "sfg_domiciliacion@edtech.com.co" "12345"

# Configuración
  CONFIG_FILE="/gfssterling/jar/app.conf" # Ruta del archivo de configuración global
  MAIL_LIST_FILE="/gfssterling/jar/mail_list" # Ruta del archivo mail_list

# Funciones
  # load_config: Carga las variables de configuración desde el archivo app.conf.
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

  # decrypt_config: Desencripta la configuración específica del usuario desde el archivo cifrado.
    decrypt_config() {
        local email="$1"
        local ruta_cipher="$PathGFS/cipher"
        local ruta_file="$ruta_cipher"
        local file_cipher="$ruta_file/clave.enc"
        local key_private="$ruta_file/llavecifrado.key"
        local key_cipher="--pwdfile $file_cipher --pwdkey $key_private"

        # Validar la existencia del archivo mail_list
        if [ ! -f "$MAIL_LIST_FILE" ]; then
            echo "Error: Archivo mail_list '$MAIL_LIST_FILE' no encontrado."
            return 1
        fi

        # Obtener el nombre del archivo cifrado desde mail_list
        local filter_user=$(awk -F':' -v email="$email" '$1 ~ email {print $2}' "$MAIL_LIST_FILE")
        if [ -z "$filter_user" ]; then
            echo "Error: Correo electrónico '$email' no encontrado en mail_list."
            return 1
        fi

        local correo_convenio="$filter_user"
        local file_dec="$correo_convenio.enc"
        local file_out="${correo_convenio}_out"
        local name_certificate="$correo_convenio"

        # Validar rutas y nombres de archivos
        if [ -z "$ruta_file" ] || [ -z "$file_out" ]; then
            echo "Error: Variables ruta_file o file_out vacías."
            return 1
        fi

        local exec_decryt="decrypt -n $name_certificate -i $ruta_file/$file_dec -o $ruta_file/$file_out $key_cipher"

        # Desencriptar el archivo de configuración
        cd "$ruta_cipher" && ./CipherConsole $exec_decryt
        if [ $? -ne 0 ]; then
            echo "Error: Falló la desencriptación del archivo de configuración."
            return 1
        fi

        # Cargar las variables desencriptadas
        eval "$(cat "$ruta_file/$file_out" | sed 's/^/export /')"
        rm -rf "$ruta_file/$file_out"

        return 0
    }

# Inicio del script

# Validar parámetros de entrada
  if [ -z "$1" ] || [ -z "$2" ]; then
      echo "Error: Se requieren dos parámetros (correo electrónico y WFID)."
      exit 1
  fi

# Cargar configuración global
  load_config

  mail_correo="$1"
  wfid="$2"
  pathd="$PathJar/mail-attachment/$wfid"

# Desencriptar configuración específica del usuario
  if ! decrypt_config "$mail_correo"; then
      exit 1
  fi

# Validar variables necesarias para la aplicación
  if [ -z "$client" ] || [ -z "$tenant" ] || [ -z "$mail_correo" ] || [ -z "$pathd" ] || [ -z "$privateCertificate" ] || [ -z "$certificatePassword" ] || [ -z "$proxy" ] || [ -z "$proxyPort" ]; then
      echo "Error: Variables de configuración no definidas."
      exit 1
  fi

# Directorio base y classpath
  basedir="$JARPATH"
  classpath="$basedir/etc:$REPO/netty-buffer-$NETTY_VERSION.jar:$REPO/netty-codec-$NETTY_VERSION.jar:$REPO/netty-codec-http-$NETTY_VERSION.jar:$REPO/netty-codec-http2-$NETTY_VERSION.jar:$REPO/netty-common-$NETTY_VERSION.jar:$REPO/netty-handler-$NETTY_VERSION.jar:$REPO/netty-handler-proxy-$NETTY_VERSION.jar:$JARPATH/$FileJar:$REPO/netty-tcnative-boringssl-static-$NETTY_TCNATIVE_VERSION.Final.jar"

# Crear directorio temporal
  mkdir -p "$pathd"

# Ejecutar servicio Java
  "$JAVA_HOME/bin/java" -cp "$classpath" co.com.edtech.msgraph.App \
      -client "$client" \
      -tenant "$tenant" \
      -certificate "$privateCertificate" \
      -email "$mail_correo" \
      -dir "$pathd/" \
      -certificatePassword "$certificatePassword" \
      -host "$proxy" \
      -port "$proxyPort" 2>&1

  if [ $? -ne 0 ]; then
      echo "Error: La aplicación Java falló."
      echo "Salida de error de Java:"
      "$JAVA_HOME/bin/java" -cp "$classpath" co.com.edtech.msgraph.App \
      -client "$client" \
      -tenant "$tenant" \
      -certificate "$privateCertificate" \
      -email "$mail_correo" \
      -dir "$pathd/" \
      -certificatePassword "$certificatePassword" \
      -host "$proxy" \
      -port "$proxyPort" 2>&1 >&2
      exit 1
  fi

# Procesar archivos
  val_list_f=$(find "$pathd/" -type f -name '*.*' | wc -l)
  if [ "$val_list_f" -eq 0 ]; then
      echo "Sin archivos a procesar."
      exit 1
  else
      echo '<root>' > "$pathd/ListF.xml"
      find "$pathd/" -type f -name '*.*' | xargs -i echo "<filename>{}</filename>" >> "$pathd/ListF.xml"
      echo '</root>' >> "$pathd/ListF.xml"
      echo "-------------------------------------------------"
      echo "Archivos procesados"
      echo "-------------------------------------------------"
      cat -b "$pathd/ListF.xml"
  fi

exit 0