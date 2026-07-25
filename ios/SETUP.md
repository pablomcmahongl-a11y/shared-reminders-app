# Setup iOS - Swift + SwiftUI

## Requisitos previos

- **macOS** con Xcode 13 o superior
- **iOS 14** o superior como target

## Instalación

### 1. Crear el proyecto Xcode

```bash
cd ios
open SharedReminders.xcodeproj
```

Si la carpeta no existe, crear el proyecto en Xcode:
- File → New → Project
- iOS → App
- Language: Swift
- Interface: SwiftUI

### 2. Estructura del proyecto

```
ios/
├── SharedReminders/
│   ├── Models/
│   │   └── Reminder.swift
│   ├── ViewModels/
│   │   └── RemindersViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── ReminderListView.swift
│   │   └── AddReminderView.swift
│   ├── Services/
│   │   └── APIClient.swift
│   └── SharedRemindersApp.swift
└── README.md
```

### 3. Configuración de la API

En `Services/APIClient.swift`, configura la URL de tu servidor:

```swift
let API_BASE_URL = "http://192.168.x.x:3000/api"  // Tu IP del servidor
```

Reemplaza `192.168.x.x` con la IP real de tu Ubuntu Server.

### 4. Ejecutar la app

1. Abre Xcode
2. Selecciona un simulador o dispositivo físico
3. Presiona ▶️ (Run)

## Características principales

### Models (Modelos de datos)

- `Reminder` - Estructura del recordatorio

### ViewModels (Lógica de negocio)

- `RemindersViewModel` - Gestiona los recordatorios y conexión con la API

### Views (Interfaz de usuario)

- `ContentView` - Pantalla principal
- `ReminderListView` - Lista de recordatorios
- `AddReminderView` - Crear nuevo recordatorio

### Services (Servicios)

- `APIClient` - Comunicación con el backend

## Conectar iPhone físico

1. Conecta tu iPhone con USB
2. En Xcode: Devices and Simulators
3. Confía en el certificado del desarrollador
4. Selecciona tu dispositivo y presiona Run

## Troubleshooting

**"Cannot connect to server"**
- Verifica que el backend está corriendo: `curl http://localhost:3000/health`
- Verifica la IP en APIClient.swift
- Asegúrate de que el iPhone está en la misma red WiFi

**"Team required for development"**
- Xcode → Preferences → Accounts
- Agrega tu Apple ID

**Port already in use**
- Cambia el puerto en backend (PORT=3001 npm start)
- Actualiza APIClient.swift con el nuevo puerto

## Testing

Antes de correr la app iOS, verifica que el backend funciona:

```bash
cd backend
npm start

# En otra terminal
curl http://localhost:3000/health
```
