# 💰 Fund Management System

Una aplicación Flutter completa para la gestión de fondos de inversión con arquitectura limpia, BLoC para manejo de estado y diseño responsivo.

## 🚀 Características Principales

- **Gestión de Fondos**: Visualización, suscripción y desuscripción de fondos
- **Sistema de Notificaciones**: Notificaciones automáticas para transacciones
- **Balance en Tiempo Real**: Seguimiento del monto disponible para inversiones
- **Formularios Dinámicos**: Sistema de formularios reutilizable con validaciones
- **Diseño Responsivo**: Interfaz adaptable para móvil, tablet y desktop
- **Navegación con Sidebar**: Navegación lateral profesional con go_router
- **Tabla Paginada**: Visualización de datos con paginación y ordenamiento
- **Arquitectura Limpia**: Separación clara entre dominio, infraestructura y UI

## 📋 Requisitos Previos

Antes de ejecutar la aplicación, asegúrate de tener instalado:

- **Flutter SDK**: Versión 3.8.1 o superior
- **Dart SDK**: Incluido con Flutter
- **IDE**: Android Studio, VS Code o IntelliJ IDEA
- **Emulador/Dispositivo**: Para pruebas móviles (opcional)

### Verificar Instalación de Flutter

```bash
flutter doctor
```

## 🛠️ Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone <repository-url>
cd test_fund_managment
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Verificar Dependencias

La aplicación utiliza las siguientes dependencias principales:

```yaml
dependencies:
  flutter_bloc: ^8.1.3    # Manejo de estado
  go_router: ^14.0.0      # Navegación
  dio: ^5.4.0             # Cliente HTTP
  dartz: ^0.10.1          # Programación funcional
  get_it: ^8.0.3          # Inyección de dependencias
  intl: ^0.20.2           # Internacionalización
```

## 🚀 Ejecución de la Aplicación

### Ejecutar en Modo Debug

```bash
flutter run
```

### Ejecutar en Dispositivo Específico

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>
```

### Ejecutar en Web

```bash
flutter run -d chrome
```

### Ejecutar en Windows

```bash
flutter run -d windows
```

## 🎯 Funcionalidades Disponibles

### 1. **Dashboard Principal**
- Navegación lateral con menú colapsible
- Acceso rápido a todas las secciones

### 2. **Gestión de Fondos** (`/funds`)
- **Visualización**: Tabla paginada con información completa de fondos
- **Suscripción**: Formulario dinámico con validaciones en tiempo real
- **Desuscripción**: Proceso de cancelación con recuperación de fondos
- **Balance**: Componente que muestra monto disponible ($500,000 COP inicial)
- **Detalles**: Modal con información completa del fondo

### 3. **Sistema de Notificaciones** (`/notifications`)
- Notificaciones automáticas para suscripciones/desuscripciones
- Gestión de estado con BLoC
- Acciones: marcar como leída, eliminar, limpiar todas



## 🏗️ Arquitectura del Proyecto

```
lib/
├── config/                 # Configuración e inyección de dependencias
├── domain/                 # Entidades y casos de uso
├── infraestructure/        # Repositorios y servicios externos
├── shared/                 # Componentes reutilizables
│   ├── components/         # Widgets compartidos
│   │   ├── forms/         # Sistema de formularios dinámicos
│   │   ├── modals/        # Modales reutilizables
│   │   └── tables/        # Tablas paginadas
│   └── utils/             # Utilidades y helpers
└── ui/                    # Interfaz de usuario
    ├── bloc/              # Gestión de estado con BLoC
    ├── pages/             # Páginas de la aplicación
    └── helpers/           # Helpers de UI y navegación
```

## 🧪 Ejecutar Pruebas

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar pruebas con cobertura
flutter test --coverage
```

## 📱 Plataformas Soportadas

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 18.04+)

## 🎨 Características de UI/UX

### Diseño Responsivo
- **Móvil** (< 768px): Vista de tarjetas optimizada
- **Tablet** (768px - 1024px): Tabla compacta
- **Desktop** (> 1024px): Tabla completa con sidebar expandido

### Componentes Reutilizables
- **BalanceCard**: Visualización elegante de montos
- **PaginatedTable**: Tablas con paginación y ordenamiento
- **DynamicForm**: Formularios con validación reactiva
- **AppModal**: Sistema de modales consistente

## 🔧 Configuración de Desarrollo

### Variables de Entorno

La aplicación utiliza datos mockeados por defecto. Para conectar con una API real:

1. Modificar `HttpServiceFactory` en `lib/infraestructure/http/http_service_factory.dart`
2. Cambiar `useMockData: false`
3. Configurar `baseUrl` con la URL de tu API

### Estructura de Datos

La aplicación maneja las siguientes entidades principales:

- **Fund**: Información de fondos de inversión
- **Notification**: Sistema de notificaciones

## 🐛 Solución de Problemas

### Error: "Flutter SDK not found"
```bash
flutter doctor
flutter config --android-studio-dir <path-to-android-studio>
```

### Error: "Pub get failed"
```bash
flutter clean
flutter pub get
```

### Error: "No connected devices"
```bash
flutter devices
# Para web:
flutter run -d chrome
```

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Go Router Documentation](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

**Desarrollado con ❤️ usando Flutter y arquitectura limpia**
