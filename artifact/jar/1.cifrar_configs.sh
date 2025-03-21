Archv de variables
client=f15da013-07c1-4e22-8427-9cceef7dca43
tenant=d98b231e-79bb-4aff-b916-0157f4cdc5bc
MailCorreo=sfg_domiciliacion@edtech.com.co
pathd=${PathGFS}/jar/mail-attachment/91212
privateCertificate=/gfssterling/jar/certs/account/edtech.com.co-full.pem
certificatePassword=ndFRYXsrNETfbF
proxy=latam-proxy-SLV.glb.lnm.bns
proxyPort=3128


## Ingresar a ruta cipher
cd /gfssterling/cipher

## Crear Archivo de configurción
## Asegurese de actualizar las variables client, tenant, privateCertificate, certificatePassword, proxy, proxyPort
File="sfg_domiciliacion"
FileDec="$File.enc"
FileOut="$File"_out
pathSalida="/gfssterling/cipher/$FileOut"
>$pathSalida
echo "client=\"f15da013-07c1-4e22-8427-9cceef7dca43\"" >>$pathSalida
echo "tenant=\"d98b231e-79bb-4aff-b916-0157f4cdc5bc\"" >>$pathSalida
echo "privateCertificate=\"/gfssterling/jar/certs/account/edtech.com.co-full.pem\"" >>$pathSalida
echo "certificatePassword=\"ndFRYXsrNETfbF\"" >>$pathSalida
echo "proxy=\"latam-proxy-SLV.glb.lnm.bns\"" >>$pathSalida
echo "proxyPort=\"3128\"" >>$pathSalida
cat $pathSalida

## Fin creación archivo

## Pasos de Crear llave de cifrado para el archivo en cipher
cd /gfssterling/cipher && sh SetupCipher.sh

Opcion 5
nombre llave sfg_domiciliacion
Z para salir


#Listar llaves Cipher y verificar que se haya creado la llave sfg_domiciliacion
RutaCipher=/gfssterling/cipher
RutaFile=/gfssterling/cipher
FileCipher=$RutaFile/clave.enc
KeyPrivate=$RutaFile/llavecifrado.key
KeyCipher="--pwdfile $FileCipher --pwdkey $KeyPrivate"
cd $RutaCipher && ./CipherConsole list --all $KeyCipher


# Cifrar archivo de configuración con Cipher
File="sfg_domiciliacion"
FileDec="$File.enc"
FileOut="$File"_out
pathCipher="/gfssterling/cipher"
pathSalida="$pathCipher/$FileOut"
RutaCipher=$pathCipher
RutaFile=$pathCipher
FileCipher=$RutaFile/clave.enc
KeyPrivate=$RutaFile/llavecifrado.key
KeyCipher="--pwdfile $FileCipher --pwdkey $KeyPrivate"
cd $RutaCipher && ./CipherConsole encrypt -i $FileOut -o $FileDec -f enc -n $File $KeyCipher
ls -ltr $pathCipher/$FileDec
rm -rf $pathCipher/$FileOut
ls -ltr $pathCipher

