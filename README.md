# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 
alias java-17="export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"

mvn clean compile package shade:shade
mv -f target/<filename>.jar artifact/<filename>.jar

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)

Proporciona los siguientes detalles:
URL del token: https://login.microsoftonline.com/{tu_id_de_inquilino}/oauth2/v2.0/token
ID del cliente: El ID de la aplicación registrado.
Secreto del cliente: El secreto generado.
Alcance: https://management.azure.com/.default
Tipo de concesión: "Credenciales del cliente".

name = wvappi03562	
ip = 10.37.0.101
port = 8080

# Colpatria Proxy List
webproxy.bns 8080
applicationproxy.bns 8080
transparentproxy.bns 8080
latam-proxy-SLV.glb.lnm.bns 8000



# JAVA keystore default password
changeit

# Examples
# Secret
java -jar O365InboxAttachmentToDisk-5.0.0-alfa.jar \
-client f15da013-07c1-4e22-8427-9cceef7dca43 \
-tenant d98b231e-79bb-4aff-b916-0157f4cdc5bc \
-secret tDk8Q~yDYhC0fP.r7-WMuecpIeo-EtclTbDlOa-W \
-email mail@example.org \
-dir /gfssterling/jar/media/attachments/

# Certificate
java -jar O365InboxAttachmentToDisk-5.0.0-alfa.jar \
-client f15da013-07c1-4e22-8427-9cceef7dca43 \
-tenant d98b231e-79bb-4aff-b916-0157f4cdc5bc \
-email mail@example.org \
-dir /gfssterling/jar/media/attachments/
-privateCertificate /gfssterling/cert/myCert.pem \
-certificatePassword yDYhC0fP

# Certificate with Proxy
java -jar O365InboxAttachmentToDisk-5.0.0-alfa.jar \
-client f15da013-07c1-4e22-8427-9cceef7dca43 \
-tenant d98b231e-79bb-4aff-b916-0157f4cdc5bc \
-email mail@example.org \
-dir /gfssterling/jar/media/attachments/
-privateCertificate /gfssterling/cert/myCert.pem \
-certificatePassword yDYhC0fP \
-host latam-proxy-SLV.glb.lnm.bns \
-port 8000