# Despliegue - Sterling Msgraph Sdk Java

## 🚀 Despliegue Local

```bash
git clone https://github.com/giovanemere/sterling-msgraph-sdk-java.git
cd sterling-msgraph-sdk-java

# Compilar proyecto
./mvnw clean install

# Ejecutar aplicación
./mvnw spring-boot:run
```

## 🐳 Docker

```bash
# Construir imagen
docker build -t sterling-msgraph-sdk-java .

# Ejecutar contenedor
docker run -p 8080:8080 sterling-msgraph-sdk-java
```
