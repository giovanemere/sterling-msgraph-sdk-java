#!/bin/sh
# Version: 5.4.0
# Autor: Edisson Zuñiga
# cd /gfssterling/jar && ./app.5.4.0-test-unit.sh

# Configuración
  CONFIG_FILE="/gfssterling/jar/app-test.conf" # Ruta del archivo de configuración

# Función para cargar las propiedades desde el archivo de configuración
  load_config() {
    while IFS='=' read -r key value; do
      export "$key=$(eval echo "$value")"
    done < "$CONFIG_FILE"
  }

# Cargar las propiedades
  load_config

# Variables
  #echo "PathGFS                = $PathGFS"
  #echo "PathJar                = $PathJar"
  #echo "FileJar                = $FileJar"
  #echo "JAVA_HOME              = $JAVA_HOME"
  #echo "JARPATH                = $JARPATH"
  #echo "REPO                   = $REPO"
  #echo "NETTY_VERSION          = $NETTY_VERSION"
  #echo "NETTY_TCNATIVE_VERSION = $NETTY_TCNATIVE_VERSION"

  #echo "client=$client"
  #echo "tenant=$tenant"
  #echo "privateCertificate=$privateCertificate"
  #echo "certificatePassword=$certificatePassword"
  #echo "proxy=$proxy"
  #echo "proxyPort=$proxyPort"

# Validacion variables
  if [ -z "$client" ] || [ -z "$tenant" ] || [ -z "$MailCorreo" ] || [ -z "$pathd" ] || [ -z "$privateCertificate" ] || [ -z "$certificatePassword" ] || [ -z "$proxy" ] || [ -z "$proxyPort" ]; then
      echo "-------------------------------------------------"
      echo " Variables no definidas"
      echo "-------------------------------------------------"
      exit 1
  fi

# Directorio base (ajusta esto si es necesario)
  BASEDIR="$JARPATH"

# Classpath
  CLASSPATH="$BASEDIR/etc:$REPO/netty-buffer-$NETTY_VERSION.jar:$REPO/netty-codec-$NETTY_VERSION.jar:$REPO/netty-codec-http-$NETTY_VERSION.jar:$REPO/netty-codec-http2-$NETTY_VERSION.jar:$REPO/netty-common-$NETTY_VERSION.jar:$REPO/netty-handler-$NETTY_VERSION.jar:$REPO/netty-handler-proxy-$NETTY_VERSION.jar:$JARPATH/$FileJar:$REPO/netty-tcnative-boringssl-static-$NETTY_TCNATIVE_VERSION.Final.jar"

# Crear Carpet Temporal
  mkdir -p "$pathd"

# Ejecutar Servicio
  "$JAVA_HOME/bin/java" -cp "$CLASSPATH" co.com.edtech.msgraph.App \
    -client "$client" \
    -tenant "$tenant" \
    -certificate "$privateCertificate" \
    -email "$MailCorreo" \
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
      echo " Sin Archivos a procesar"
      echo "-------------------------------------------------"
      cat -b "$pathd/ListF.xml"

  fi

