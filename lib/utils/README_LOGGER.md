# Sistema de Logging de la Aplicación

## 📋 Descripción

Sistema de logging profesional usando el paquete `logger` que **automáticamente desactiva todos los logs en modo Release**.

## 🎯 Características

- ✅ **Logs solo en Debug**: En modo Release no se ejecuta ningún log
- 🎨 **Colores y emojis**: Fácil identificación visual en consola
- 📊 **Niveles de log**: Debug, Info, Warning, Error, Fatal
- 🔍 **Stack traces**: Muestra el contexto del error
- ⚡ **Singleton**: Instancia única accesible globalmente

## 🚀 Uso

### Importar el logger

```dart
import '../utils/app_logger.dart';
```

### Ejemplos de uso

```dart
// Debug - Para información de desarrollo (azul) 🐛
logger.debug('Iniciando proceso de carga');
logger.debug('Usuario seleccionó dificultad: $difficulty');

// Info - Para información general (azul claro) 💡
logger.info('Juego iniciado correctamente');
logger.info('Dificultad seleccionada: $selectedDifficulty');

// Warning - Para advertencias (naranja) ⚠️
logger.warning('Conexión a internet lenta');
logger.warning('Cache casi lleno: ${cacheSize}MB');

// Error - Para errores no críticos (rojo) ⚠️
logger.error('Error al reproducir sonido', error, stackTrace);
logger.error('Fallo al cargar estadísticas', e);

// Fatal - Para errores graves (rojo intenso) 🚨
logger.fatal('Error crítico en la base de datos', error, stackTrace);
```

## 📝 Niveles de Log

| Nivel       | Emoji | Color        | Uso                       |
| ----------- | ----- | ------------ | ------------------------- |
| `debug()`   | 🐛    | Azul         | Información de desarrollo |
| `info()`    | 💡    | Azul claro   | Información general       |
| `warning()` | ⚠️    | Naranja      | Advertencias              |
| `error()`   | ⚠️    | Rojo         | Errores manejados         |
| `fatal()`   | 🚨    | Rojo intenso | Errores críticos          |

## 🔒 Seguridad en Release

El logger utiliza `kDebugMode` de Flutter, lo que garantiza que:

- ✅ En **Debug**: Todos los logs se muestran
- ✅ En **Release**: NO se ejecuta ningún log
- ✅ En **Profile**: NO se ejecuta ningún log

## 🎯 Buenas Prácticas

### ✅ Hacer

```dart
// Usar logger en lugar de print
logger.info('Usuario inició sesión');

// Incluir contexto relevante
logger.error('Error al guardar', error, stackTrace);

// Usar el nivel apropiado
logger.debug('Variable temporal: $temp');
logger.warning('Operación lenta: ${duration}ms');
```

### ❌ No hacer

```dart
// NO usar print()
print('Hola'); // ❌

// NO olvidar el stackTrace en errores
logger.error('Error', error); // ⚠️ Falta stackTrace

// NO usar info para debugging
logger.info('Variable x = $x'); // ❌ Usar debug()
```

## 🔧 Configuración

El logger está configurado en `lib/utils/app_logger.dart` con:

- **methodCount**: 2 métodos en stack trace
- **errorMethodCount**: 8 métodos en errores
- **lineLength**: 120 caracteres
- **colors**: Habilitados
- **printEmojis**: Habilitados
- **dateTimeFormat**: Solo tiempo y tiempo transcurrido

## 📦 Dependencias

Requiere el paquete `logger` en `pubspec.yaml`:

```yaml
dependencies:
  logger: ^2.0.2
```

## 🚀 Inicialización

El logger se inicializa automáticamente en `main.dart`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar logger
  logger.init();

  runApp(const MyApp());
}
```

## 🧪 Testing

En modo Release, verifica que no hay logs:

```bash
# Compilar en modo release
flutter build apk --release

# Los logs NO aparecerán en la consola
```

## 📱 Ejemplo Real

```dart
class SoundService {
  Future<void> playCellSelectionSound() async {
    try {
      logger.debug('Intentando reproducir sonido');
      await _audioPlayer.play(AssetSource('sounds/4.mp3'));
      logger.info('Sonido reproducido correctamente');
    } catch (e, stackTrace) {
      logger.error('Error reproduciendo sonido', e, stackTrace);
    }
  }
}
```

## 🎓 Más Información

- [Documentación de logger](https://pub.dev/packages/logger)
- [kDebugMode en Flutter](https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html)
