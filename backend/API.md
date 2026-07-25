# API Documentation - Shared Reminders

## Base URL
```
http://localhost:3000/api
```

## Endpoints

### 1. Obtener recordatorios de un usuario
**GET** `/reminders/:userId`

```bash
curl http://localhost:3000/api/reminders/user-123
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "abc123",
      "userId": "user-123",
      "title": "Comprar leche",
      "description": "En el supermercado",
      "dueDate": "2026-07-26T10:00:00",
      "createdAt": "2026-07-25T10:00:00",
      "completed": false
    }
  ]
}
```

---

### 2. Crear recordatorio
**POST** `/reminders`

**Body:**
```json
{
  "userId": "user-123",
  "title": "Comprar leche",
  "description": "En el supermercado",
  "dueDate": "2026-07-26T10:00:00"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "abc123",
    "userId": "user-123",
    "title": "Comprar leche",
    "description": "En el supermercado",
    "dueDate": "2026-07-26T10:00:00",
    "createdAt": "2026-07-25T10:00:00",
    "completed": false
  }
}
```

---

### 3. Actualizar recordatorio
**PUT** `/reminders/:reminderId`

**Body:**
```json
{
  "title": "Comprar leche (2 litros)",
  "completed": true
}
```

**Response:**
```json
{
  "success": true,
  "data": { ... }
}
```

---

### 4. Eliminar recordatorio
**DELETE** `/reminders/:reminderId`

**Response:**
```json
{
  "success": true,
  "message": "Recordatorio eliminado"
}
```

---

### 5. Compartir recordatorio
**POST** `/reminders/:reminderId/share`

**Body:**
```json
{
  "sharedWithUserId": "user-456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Recordatorio compartido"
}
```

---

### 6. Obtener recordatorios compartidos
**GET** `/reminders/shared/:userId`

```bash
curl http://localhost:3000/api/reminders/shared/user-456
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "abc123",
      "userId": "user-123",
      "title": "Comprar leche",
      "description": "En el supermercado",
      "dueDate": "2026-07-26T10:00:00",
      "createdAt": "2026-07-25T10:00:00",
      "completed": false
    }
  ]
}
```

---

### Health Check
**GET** `/health`

```bash
curl http://localhost:3000/health
```

## Códigos de estado HTTP

- **200** - OK
- **201** - Created
- **400** - Bad Request
- **500** - Server Error
