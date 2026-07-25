# Setup Backend - Ubuntu Server

## Requisitos previos

- Node.js instalado (v14 o superior)
- npm instalado

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/pablomcmahongl-a11y/shared-reminders-app.git
cd shared-reminders-app/backend
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Iniciar el servidor

```bash
npm start
```

Deberías ver:
```
✅ Conectado a la base de datos SQLite
🚀 Servidor ejecutándose en http://localhost:3000
📱 Base de datos: reminders.db
```

### 4. Probar la API

```bash
# Health check
curl http://localhost:3000/health

# Crear recordatorio
curl -X POST http://localhost:3000/api/reminders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user-123",
    "title": "Mi primer recordatorio",
    "description": "Esto es una prueba",
    "dueDate": "2026-07-26T10:00:00"
  }'
```

## Modo desarrollo con nodemon

Para desarrollar con auto-reinicio al cambiar archivos:

```bash
npm install -D nodemon
npm run dev
```

## Usar con IP del servidor

Si accedes desde otra máquina (como desde el iPhone), reemplaza `localhost` con la IP de tu servidor:

```
http://192.168.x.x:3000
```

Para encontrar tu IP:
```bash
hostname -I
```

## Base de datos

La base de datos SQLite se crea automáticamente en `reminders.db`.

Para ver los datos directamente:
```bash
sqlite3 reminders.db
.tables
SELECT * FROM reminders;
```

## Troubleshooting

**Puerto 3000 ya está en uso:**
```bash
PORT=3001 npm start
```

**Permisos de archivo:**
```bash
chmod +x index.js
```

**Reinstalar dependencias:**
```bash
rm -rf node_modules package-lock.json
npm install
```
