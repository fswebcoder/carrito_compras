# Carrito de Compras - Flutter

Aplicación de carrito de compras desarrollada con Flutter, utilizando BLoC para gestión de estado y Clean Architecture para la organización del código.

## 🚀 Cómo ejecutar el proyecto

### Requisitos previos
- Flutter SDK (^3.10.4)
- Dart SDK
- Dispositivo o emulador configurado

### Instalación

```bash
# Clonar el repositorio
git clone <repository-url>

# Navegar al directorio
cd carrito_compras

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
```

### Ejecutar tests

```bash
# Ejecutar todas las pruebas
flutter test

# Ejecutar con cobertura
flutter test --coverage
```

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con una clara separación de capas:

```
lib/
├── core/                          # Funcionalidades compartidas
│   ├── constants/                 # Constantes de la API
│   ├── error/                     # Clases de errores y excepciones
│   ├── theme/                     # Configuración del tema
│   └── usecases/                  # Clase base UseCase
│
├── features/                      # Funcionalidades por dominio
│   ├── products/                  # Feature de productos
│   │   ├── data/                  # Capa de datos
│   │   │   ├── datasources/       # Fuentes de datos remotas
│   │   │   ├── models/            # Modelos con serialización
│   │   │   └── repositories/      # Implementación de repositorios
│   │   ├── domain/                # Capa de dominio
│   │   │   ├── entities/          # Entidades de negocio
│   │   │   ├── repositories/      # Contratos de repositorios
│   │   │   └── usecases/          # Casos de uso
│   │   └── presentation/          # Capa de presentación
│   │       ├── bloc/              # BLoC (eventos, estados, bloc)
│   │       └── pages/             # Pantallas y widgets
│   │
│   ├── cart/                      # Feature del carrito
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── checkout/                  # Feature de checkout
│       └── presentation/
│
├── injection_container.dart       # Inyección de dependencias
└── main.dart                      # Punto de entrada
```

### Flujo de dependencias

```
Presentation → Domain ← Data
     ↓            ↑        ↓
   BLoC      UseCases  DataSources
              Entities   Models
```

Las dependencias apuntan hacia el dominio (Dependency Inversion), permitiendo:
- Testabilidad mediante mocks
- Desacoplamiento entre capas
- Facilidad de mantenimiento

## 📦 Dependencias principales

| Paquete | Uso |
|---------|-----|
| `flutter_bloc` | Gestión de estado con patrón BLoC |
| `equatable` | Comparación de objetos por valor |
| `dartz` | Programación funcional (Either) |
| `get_it` | Inyección de dependencias |
| `shared_preferences` | Persistencia local |
| `http` | Cliente HTTP para API |
| `cached_network_image` | Caché de imágenes |

## 🎯 Decisiones clave

### Persistencia
- **SharedPreferences** para almacenar el carrito en formato JSON
- El carrito se carga automáticamente al iniciar la app
- Cada modificación se persiste inmediatamente
- Se eligió SharedPreferences por simplicidad; para datos más complejos se podría usar Hive o SQLite

### Navegación
- **Navigator standard** de Flutter con rutas imperativas
- Navegación push/pop entre pantallas
- El carrito se accede tocando el ícono en el AppBar (no drawer)
- PopUntil para volver al Home después del pago

### Manejo del contador global
- **CartBloc como Singleton** registrado en GetIt
- Un único BlocProvider a nivel de MaterialApp
- Todas las pantallas acceden al mismo estado del carrito
- Los cambios se reflejan inmediatamente en todas las pantallas

### Sincronización entre pantallas
- BlocBuilder en cada pantalla observa el mismo CartBloc
- Al modificar el carrito en cualquier pantalla, el estado se actualiza globalmente
- El contador del AppBar se actualiza en tiempo real

## 💳 Comportamiento tras el pago

1. **Validación del formulario**: Se validan todos los campos requeridos
2. **Procesamiento simulado**: Delay de 2 segundos simulando el pago
3. **Limpieza del carrito**: Se ejecuta `ClearCartEvent` que:
   - Vacía el estado en memoria
   - Limpia SharedPreferences
4. **Confirmación**: Diálogo de éxito con resumen del pedido
5. **Redirección**: `popUntil` navega de vuelta al Home
6. **Estado limpio**: El carrito queda vacío, listo para nuevas compras

**Justificación**: En una app real, el pago exitoso debería vaciar el carrito para permitir nuevas compras. El usuario ve confirmación visual y puede continuar comprando.

## 📱 Diseño responsive

- **Grid adaptable**: 2 columnas en móvil, 3 en tablet, 4 en pantallas grandes
- **LayoutBuilder** para detectar ancho disponible
- **Breakpoints**: 600px (tablet), 900px (desktop)
- **Bottom sheet** para detalles de producto en móvil

## ✅ Pruebas unitarias

Se incluyen tests para:
- `CartBloc`: Eventos de cargar, agregar, eliminar, actualizar cantidad y limpiar
- `ProductBloc`: Eventos de cargar y filtrar productos
- `CartItem`: Cálculo de subtotal y copyWith
- `ProductModel`: Serialización JSON

```bash
# Ejecutar pruebas específicas
flutter test test/features/cart/presentation/bloc/cart_bloc_test.dart
flutter test test/features/products/presentation/bloc/product_bloc_test.dart
```

## 🔗 API

Se utiliza [Fake Store API](https://fakestoreapi.com/) para obtener productos:
- `GET /products` - Lista de productos
- `GET /products/:id` - Producto individual
- `GET /products/categories` - Categorías

## 📄 Licencia

Este proyecto fue desarrollado como prueba técnica.

