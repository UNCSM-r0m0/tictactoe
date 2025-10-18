# 🎮 Tic Tac Toe - Documentación Técnica

## 📋 Descripción del Proyecto

**Tic Tac Toe** es una aplicación móvil desarrollada en Flutter que implementa el clásico juego de tres en raya con funcionalidades avanzadas y una interfaz moderna.

### 🎯 Necesidad que Suple

- **Entretenimiento**: Juego clásico accesible para todas las edades
- **Aprendizaje**: Demuestra conceptos de programación y lógica de juegos
- **Desarrollo de habilidades**: Mejora el pensamiento estratégico y lógico
- **Accesibilidad**: Interfaz intuitiva y fácil de usar

---

## 🏗️ Arquitectura del Proyecto

### 📁 Estructura de Archivos

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/
│   ├── game_state.dart         # Lógica principal del juego
│   └── database/
│       ├── database_helper.dart # Configuración SQLite
│       ├── game_stats.dart     # Modelo de estadísticas
│       └── stats_service.dart  # Servicio de base de datos
├── screens/
│   ├── splash_screen.dart      # Pantalla de bienvenida
│   ├── game_mode_selection.dart # Selección de modo de juego
│   ├── tic_tac_toe_game.dart   # Pantalla principal del juego
│   └── statistics_screen.dart  # Pantalla de estadísticas
├── services/
│   └── sound_service.dart      # Servicio de audio
└── utils/
    └── app_logger.dart         # Sistema de logging
```

---

## 🧠 Lógica del Juego

### 🎲 Estados del Juego

```dart
enum Player { x, o }           // Jugadores
enum GameStatus { playing, won, draw }  // Estados del juego
enum GameMode { twoPlayers, vsAI }      // Modos de juego
enum AIDifficulty { easy, medium, hard } // Dificultades de IA
```

### 🎯 Algoritmo de Verificación de Victoria

```dart
static const List<List<int>> _winningCombinations = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], // Filas horizontales
  [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columnas verticales
  [0, 4, 8], [2, 4, 6],            // Diagonales
];
```

**Funcionamiento:**

1. Se verifica cada combinación ganadora
2. Si tres casillas consecutivas tienen el mismo jugador → Victoria
3. Si no hay ganador y el tablero está lleno → Empate
4. Si no se cumple ninguna condición → Juego continúa

### 🤖 Inteligencia Artificial

#### **Dificultad Fácil (70% aleatorio, 30% inteligente)**

```dart
int _getEasyMove(List<int> availableMoves) {
  if (_random.nextDouble() < 0.7) {
    return availableMoves[_random.nextInt(availableMoves.length)];
  } else {
    return _getBestMove(availableMoves);
  }
}
```

#### **Dificultad Media (40% aleatorio, 60% inteligente)**

```dart
int _getMediumMove(List<int> availableMoves) {
  if (_random.nextDouble() < 0.4) {
    return availableMoves[_random.nextInt(availableMoves.length)];
  } else {
    return _getBestMove(availableMoves);
  }
}
```

#### **Dificultad Difícil (100% óptimo con Minimax)**

```dart
int _getHardMove(List<int> availableMoves) {
  return _minimax(state.board, Player.o, 0)['index'] ?? availableMoves.first;
}
```

### 🧮 Algoritmo Minimax

**Estrategia de la IA Difícil:**

1. **Maximizar** para la IA (Player.o)
2. **Minimizar** para el jugador (Player.x)
3. **Evaluación de puntuación:**
   - Victoria de IA: +10
   - Victoria de jugador: -10
   - Empate: 0
4. **Profundidad**: Considera todos los movimientos posibles

### 🎯 Estrategia de Movimientos Inteligentes

```dart
int _getBestMove(List<int> availableMoves) {
  // 1. Intentar ganar
  for (final move in availableMoves) {
    if (_isWinning(testBoard, Player.o)) return move;
  }

  // 2. Bloquear al jugador
  for (final move in availableMoves) {
    if (_isWinning(testBoard, Player.x)) return move;
  }

  // 3. Tomar el centro
  if (availableMoves.contains(4)) return 4;

  // 4. Tomar una esquina
  // 5. Movimiento aleatorio
}
```

---

## 🎨 Mejoras Implementadas

### 🔊 **1. Sistema de Sonidos**

**Implementación:**

```dart
class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playCellSelectionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/4.mp3'));
    } catch (e, stackTrace) {
      logger.error('Error reproduciendo sonido', e, stackTrace);
    }
  }
}
```

**Características:**

- ✅ Sonido al seleccionar casilla
- ✅ Manejo de errores silencioso
- ✅ No interrumpe el juego si falla
- ✅ Singleton para eficiencia

### 🗄️ **2. Base de Datos SQLite**

**Estructura de la Base de Datos:**

```sql
CREATE TABLE game_stats (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  player_name TEXT NOT NULL,
  player_type TEXT NOT NULL,  -- 'human' o 'ai'
  games_played INTEGER DEFAULT 0,
  games_won INTEGER DEFAULT 0,
  games_lost INTEGER DEFAULT 0,
  games_drawn INTEGER DEFAULT 0,
  win_rate REAL DEFAULT 0.0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

**Funcionalidades:**

- ✅ Guardado automático de estadísticas
- ✅ Cálculo de porcentaje de victorias
- ✅ Estadísticas por tipo de jugador (humano/IA)
- ✅ Estadísticas generales del juego
- ✅ Opción de limpiar datos

### 📊 **3. Sistema de Estadísticas**

**Métricas Registradas:**

- Partidas jugadas
- Victorias/Derrotas/Empates
- Porcentaje de victorias
- Estadísticas por dificultad de IA
- Estadísticas generales

**Pantalla de Estadísticas:**

- Visualización de datos en tarjetas
- Gráficos de rendimiento
- Estadísticas por jugador
- Opción de resetear datos

### 🎭 **4. Interfaz Personalizada**

**Características Visuales:**

- ✅ Diseño moderno con gradientes
- ✅ Animaciones fluidas con `flutter_animate`
- ✅ Iconos personalizados con `iconsax`
- ✅ Colores temáticos por jugador
- ✅ Efectos de resplandor en casillas ganadoras
- ✅ Transiciones suaves entre pantallas

**Responsive Design:**

- ✅ Adaptable a diferentes tamaños de pantalla
- ✅ Optimizado para dispositivos móviles
- ✅ Interfaz intuitiva y clara

### 🔧 **5. Sistema de Logging Profesional**

**Implementación:**

```dart
class AppLogger {
  void debug(dynamic message) {
    if (kDebugMode) _logger.d(message);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
```

**Características:**

- ✅ Solo funciona en modo Debug
- ✅ Colores y emojis para identificación
- ✅ Stack traces para debugging
- ✅ Niveles de log (debug, info, warning, error, fatal)

---

## 🎮 Modos de Juego

### 👥 **Dos Jugadores**

- Turnos alternados
- Sin limitaciones de tiempo
- Estadísticas individuales

### 🤖 **Un Jugador vs IA**

- Tres niveles de dificultad
- Simulación de pensamiento de IA
- Estadísticas comparativas

---

## 📱 Funcionalidades de la Interfaz

### 🎨 **Pantalla de Bienvenida (Splash Screen)**

- Animación de logo personalizado
- Partículas flotantes
- Transición automática
- Información de versión

### 🎯 **Selección de Modo de Juego**

- Tablero de ejemplo animado
- Botones con efectos visuales
- Diálogo de selección de dificultad
- Acceso directo a estadísticas

### 🎮 **Pantalla Principal del Juego**

- Tablero interactivo 3x3
- Marcador en tiempo real
- Indicador de turno
- Efectos visuales en casillas ganadoras
- Botón de nuevo juego

### 📊 **Pantalla de Estadísticas**

- Tarjetas de estadísticas generales
- Lista de jugadores con rendimiento
- Gráficos de porcentajes
- Opción de limpiar datos

---

## 🛠️ Tecnologías Utilizadas

### 📦 **Dependencias Principales**

```yaml
dependencies:
  flutter_riverpod: ^2.4.9 # Gestión de estado
  flutter_animate: ^4.5.0 # Animaciones
  iconsax: ^0.0.8 # Iconos personalizados
  sqflite: ^2.3.0 # Base de datos SQLite
  audioplayers: ^6.0.0 # Reproducción de audio
  logger: ^2.0.2 # Sistema de logging
```

### 🏗️ **Arquitectura**

- **State Management**: Riverpod
- **Base de Datos**: SQLite con SQFlite
- **Audio**: AudioPlayers
- **Animaciones**: Flutter Animate
- **Logging**: Logger con filtros de producción

---

## 🎯 Justificación de Mejoras

### 🔊 **Sistema de Sonidos**

- **Necesidad**: Mejorar la experiencia de usuario
- **Beneficio**: Feedback auditivo inmediato
- **Implementación**: Servicio singleton eficiente

### 🗄️ **Base de Datos SQLite**

- **Necesidad**: Persistencia de datos de juego
- **Beneficio**: Historial de partidas y estadísticas
- **Implementación**: Arquitectura limpia con servicios

### 🎨 **Interfaz Personalizada**

- **Necesidad**: Diferenciación y modernidad
- **Beneficio**: Experiencia visual atractiva
- **Implementación**: Diseño responsive y animado

### 📊 **Sistema de Estadísticas**

- **Necesidad**: Seguimiento de progreso
- **Beneficio**: Motivación y análisis de rendimiento
- **Implementación**: Cálculos automáticos y visualización

---

## 🚀 Características Técnicas Avanzadas

### ⚡ **Optimizaciones de Rendimiento**

- Estado inmutable con `copyWith`
- Lazy loading de servicios
- Gestión eficiente de memoria
- Logging condicional (solo Debug)

### 🔒 **Manejo de Errores**

- Try-catch en operaciones críticas
- Logging detallado de errores
- Fallbacks para operaciones de audio
- Validación de estados del juego

### 🎯 **Experiencia de Usuario**

- Animaciones fluidas y naturales
- Feedback visual inmediato
- Interfaz intuitiva y clara
- Responsive design

---

## 📈 Métricas de Calidad

### 🧪 **Código Limpio**

- ✅ Separación de responsabilidades
- ✅ Nomenclatura descriptiva
- ✅ Documentación en código
- ✅ Manejo de errores robusto

### 🎨 **Interfaz de Usuario**

- ✅ Diseño moderno y atractivo
- ✅ Navegación intuitiva
- ✅ Feedback visual y auditivo
- ✅ Accesibilidad mejorada

### ⚡ **Rendimiento**

- ✅ Carga rápida de pantallas
- ✅ Animaciones fluidas
- ✅ Gestión eficiente de memoria
- ✅ Optimización para dispositivos móviles

---

## 🎓 Aprendizajes Técnicos

### 🏗️ **Arquitectura de Software**

- Patrón Singleton para servicios
- Separación de lógica de negocio
- Gestión de estado reactiva
- Inyección de dependencias

### 🎮 **Desarrollo de Juegos**

- Algoritmos de IA (Minimax)
- Lógica de verificación de victoria
- Gestión de turnos y estados
- Feedback de usuario

### 📱 **Desarrollo Móvil**

- Diseño responsive
- Gestión de assets
- Persistencia de datos
- Integración de audio

---

## 🔮 Posibles Mejoras Futuras

### 🎮 **Funcionalidades de Juego**

- Modo multijugador online
- Torneos y ligas
- Diferentes tamaños de tablero
- Power-ups y efectos especiales

### 📊 **Analytics y Datos**

- Gráficos más detallados
- Exportación de estadísticas
- Comparación de rendimiento
- Historial de partidas

### 🎨 **Personalización**

- Temas personalizables
- Sonidos personalizados
- Avatares de jugadores
- Configuraciones avanzadas

---

## 📝 Conclusión

Este proyecto demuestra la implementación de un juego clásico con tecnologías modernas, incorporando:

- **Lógica de juego robusta** con IA avanzada
- **Interfaz moderna** con animaciones fluidas
- **Persistencia de datos** con SQLite
- **Experiencia de usuario** mejorada con sonidos
- **Arquitectura limpia** y mantenible
- **Sistema de logging** profesional

La aplicación combina entretenimiento, aprendizaje y desarrollo técnico, proporcionando una base sólida para futuras expansiones y mejoras.
