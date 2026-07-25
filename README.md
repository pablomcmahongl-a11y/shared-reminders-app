# Shared Reminders App

Una aplicación iOS para crear y compartir recordatorios entre múltiples usuarios.

## 📱 Características

- Crear recordatorios con título, descripción y fecha/hora
- Compartir recordatorios con otros usuarios
- Sincronización en tiempo real
- Notificaciones de recordatorios

## 🏗️ Arquitectura

### Frontend
- **iOS** - Swift + SwiftUI
- **Ubicación**: `/ios`

### Backend
- **Node.js + Express**
- **Base de datos**: SQLite
- **Ubicación**: `/backend`

## 🚀 Quick Start

### Backend (Ubuntu Server)

```bash
cd backend
npm install
npm start
```

El servidor estará disponible en `http://localhost:3000`

### Frontend (iOS)

```bash
cd ios
open SharedReminders.xcodeproj
```

## 📚 Documentación

- [API Documentation](./backend/API.md)
- [Backend Setup](./backend/SETUP.md)
- [iOS Setup](./ios/SETUP.md)

## 📝 Estructura de carpetas

```
shared-reminders-app/
├── backend/           # Servidor Node.js + Express
├── ios/               # Aplicación iOS
└── README.md
```
