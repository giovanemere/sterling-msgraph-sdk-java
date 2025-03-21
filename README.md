# O365InboxAttachmentToDisk

Este proyecto Java, `O365InboxAttachmentToDisk`, es una aplicación que utiliza Microsoft Graph API para descargar archivos adjuntos de correos electrónicos de Office 365 y guardarlos en el disco.

## Estructura del Proyecto

La estructura del proyecto sigue una organización estándar de Maven:

```
├── .idea/                 # Configuración de IntelliJ IDEA
├── .vscode/                # Configuración de Visual Studio Code
├── artifact/              # Artefactos de construcción (JARs)
├── Certificados/          # Certificados de la aplicación
├── src/
│   ├── main/java/co/com/edtech/msgraph/
│   │   ├── App.java        # Punto de entrada de la aplicación
│   │   ├── Client.java     # Lógica para interactuar con Microsoft Graph
│   │   ├── Mailbox.java    # Lógica relacionada con el buzón de correo
│   │   └── Validator.java # Lógica de validación de datos
│   └── test/              # Código de prueba unitaria
│   └── target/            # Archivos generados durante la construcción
├── .gitignore             # Archivos ignorados por Git
├── dependency-reduced-pom.xml # POM reducido generado durante la construcción
├── docker-compose.yml      # Configuración de Docker Compose
├── Jenkinsfile            # Pipeline de construcción de Jenkins
├── pom.xml                # Configuración de Maven
├── pushChanges.sh         # Script para subir cambios a Git
├── README.md              # Este archivo
└── app.5.4.0.sh           # Script para ejecutar la aplicación
```

## `co.com.edtech.msgraph.App`

`App.java` es la clase principal que inicia la aplicación. Esta clase orquesta el flujo de la aplicación, incluyendo la autenticación con Microsoft Graph, la conexión al buzón de correo, la descarga de archivos adjuntos y el guardado de estos en el disco.

## Compilar el Proyecto

El proyecto utiliza Maven para la gestión de dependencias y la construcción. Para compilar el proyecto, sigue estos pasos:

1. Asegúrate de tener instalado Java Development Kit (JDK) 17 o superior y Maven.
2. Abre una terminal y navega al directorio raíz del proyecto (donde se encuentra el archivo `pom.xml`).
3. Ejecuta el siguiente comando:

```bash
    mvn clean install
    ```
Este comando limpiará el proyecto, descargará las dependencias, compilará el código fuente y ejecutará las pruebas unitarias.
## Generar el JAR del Proyecto
Para generar un archivo JAR ejecutable que contenga todas las dependencias necesarias, utiliza el plugin `maven-shade-plugin` configurado en el `pom.xml`.
1.  Asegúrate de haber compilado el proyecto correctamente.
2.  Ejecuta el siguiente comando en la terminal:
```bash
    mvn package
    ```
Este comando empaquetará el proyecto y generará un JAR ejecutable en el directorio `target/`. El nombre del JAR generado dependerá de la configuración del proyecto (por ejemplo, `O365InboxAttachmentToDisk-5.4.0.jar`).
## Ejecutar la Aplicación con `app.5.4.0.sh`
El script `app.5.4.0.sh` se proporciona para facilitar la ejecución de la aplicación.
### Contenido del Script (`app.5.4.0.sh`):
```sh
#!/bin/sh
# Version: 5.0.0
## Variables Dinamicas Cipher
PathGFS="/gfssterling"
FileJar="O365InboxAttachmentToDisk-5.4.0.jar"
JAVA_HOME="$PathGFS/java/temurin-jre-17.0.13"
JARPATH="/gfssterling/jar/5.0.0"
REPO="$JARPATH/jars/4.1.118"
NETTY_VERSION="4.1.118.Final"
NETTY_TCNATIVE_VERSION="2.0.65.Final" #Added netty tcnative version
client="f15da013-07c1-4e22-8427-9cceef7dca43"
tenant="d98b231e-79bb-4aff-b916-0157f4cdc5bc"
MailCorreo="sfg_domiciliacion@edtech.com.co"
pathd="/gfssterling/jar/mail-attachment/91212"
privateCertificate="/gfssterling/jar/certs/account/edtech.com.co-full.pem"
certificatePassword="ndFRYXsrNETfbF"
proxy="latam-proxy-SLV.glb.lnm.bns"
proxyPort="3128"
### Validacion variables
if [ -z "$client" ] || [ -z "$tenant" ] || [ -z "$MailCorreo" ] || [ -z "$pathd" ] || [ -z "$privateCertificate" ] || [ -z "$certificatePassword" ] || [ -z "$proxy" ] || [ -z "$proxyPort" ]
then
    echo "-------------------------------------------------"
    echo " Variables no definidas"
    echo "-------------------------------------------------"
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
    -email "$MailCorreo" \
    -dir "$pathd/" \
    -certificatePassword "$certificatePassword" \
    -host "$proxy" \
    -port "$proxyPort"
# Verificar el código de salida
if [ <span class="math-inline">? \-ne 0 \]; then
echo "Error\: La aplicación Java falló\."
exit 1
fi
valListF\=</span>(find "$pathd/" -type f -name '*.*' | wc -l )
if [ "$valListF" -eq 0 ]
then
    echo "-------------------------------------------------"
    echo " Sin Archivos a procesar"
    echo "-------------------------------------------------"
    exit 1
else
    echo '<root>' > "$pathd/ListF.xml" & find "$pathd/" -type f -name '*.*' | xargs -i echo "<filename>{}</filename>" >> "$pathd/ListF.xml" && echo '</root>' >> "$pathd/ListF.xml"
    cat -b "$pathd/ListF.xml"
fi
Pasos para Ejecutar con app.5.4.0.sh
    1. Configurar las Variables:
        ○ Crea un archivo (por ejemplo, config.properties) y define las variables necesarias:
Properties

client="f15da013-07c1-4e22-8427-9cceef7dca43"
tenant="d98b231e-79bb-4aff-b916-0157f4cdc5bc"
MailCorreo="sfg_domiciliacion@edtech.com.co"
pathd="/gfssterling/jar/mail-attachment/91212"
privateCertificate="/gfssterling/jar/certs/account/edtech.com.co-full.pem"
certificatePassword="ndFRYXsrNETfbF"
proxy="latam-proxy-SLV.glb.lnm.bns"
proxyPort="3128"
PathGFS="/gfssterling"
JARPATH="/gfssterling/jar/5.0.0"
REPO="/gfssterling/jar/jars/4.1.118"
JAVA_HOME="/gfssterling/java/temurin-jre-17.0.13"
        ○ Importante: Ajusta los valores de las variables (especialmente client, tenant, MailCorreo, privateCertificate, pathd, PathGFS, JARPATH, REPO, JAVA_HOME) con los valores correctos para tu entorno. Asegúrate que los directorios y archivos referenciados existan y tengan los permisos correctos.
    2. Modificar el Script (Opcional - Recomendado):
        ○ Puedes modificar el script app.5.4.0.sh para que lea las variables desde el archivo config.properties para mayor flexibilidad y evitar hardcodear valores en el script. Agrega esto al inicio del script:
Bash

#!/bin/bash
# Load configuration
if [ -f config.properties ]; then
  source config.properties
else
  echo "Error: config.properties file not found."
  exit 1
fi

# Rest of the script...

This addition checks if config.properties exists and loads it. If not, it prints an error and exits.
    3. Hacer el Script Ejecutable:
        ○ Asegúrate de que el script app.5.4.0.sh tenga permisos de ejecución:
Bash

chmod +x app.5.4.0.sh
    4. Ejecutar el Script:
        ○ Abre una terminal y ejecuta el script:
Bash

./app.5.4.0.sh
        ○ El script ejecutará la aplicación Java con las opciones y variables definidas.
Importante:
    • Asegúrate de que las versiones de Netty y otras dependencias sean compatibles con las librerías utilizadas en el proyecto.
    • Verifica que las rutas de los archivos y directorios en el script sean correctas para tu sistema.
    • Revisa los logs de la aplicación para detectar posibles errores o warnings durante la ejecución.
    • Seguridad: Maneja los valores de las variables (especialmente certificatePassword, privateCertificate) con cuidado y no los expongas en repositorios públicos. Considera usar variables de entorno o un sistema de gestión de secretos más robusto en un entorno de producción.
```
