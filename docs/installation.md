# Instalación - Sterling Msgraph Sdk Java

## 📋 Prerrequisitos

- Java 11 o superior
- Maven 3.6+ o Gradle 6+
- Docker (opcional)
- Base de datos (PostgreSQL/MySQL)

## 🚀 Instalación Local

### 1. Clonar Repositorio
```bash
git clone https://github.com/giovanemere/sterling-msgraph-sdk-java.git
cd sterling-msgraph-sdk-java
```

### 2. Configurar Variables de Entorno
```bash
cp .env.example .env
# Editar .env con tus configuraciones
```

### 3. Instalar Dependencias
```bash
./mvnw clean install
```

### 4. Ejecutar Aplicación
```bash
./mvnw spring-boot:run
```
