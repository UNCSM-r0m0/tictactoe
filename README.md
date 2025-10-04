# 🎮 Tic Tac Toe - Juego de Tres en Raya

Un juego de Tres en Raya (Tic Tac Toe) desarrollado en Flutter con una interfaz moderna y funcionalidades avanzadas como inteligencia artificial y sistema de estadísticas.

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Explicación del Código](#-explicación-del-código)
- [Cómo Funciona el Juego](#-cómo-funciona-el-juego)
- [Algoritmo de IA](#-algoritmo-de-ia)
- [Instalación](#-instalación)
- [Uso](#-uso)
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)

## ✨ Características

- **Modo Multijugador**: Juega contra otro jugador local
- **Modo vs IA**: Juega contra inteligencia artificial con 3 niveles de dificultad
- **Sistema de Estadísticas**: Guarda y consulta estadísticas de partidas en SQLite
- **Interfaz Moderna**: Diseño elegante con animaciones y efectos visuales
- **Responsive**: Optimizado para dispositivos móviles
- **Persistencia de Datos**: Las estadísticas se guardan permanentemente

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/
│   ├── game_state.dart         # Modelo de estado del juego y lógica de IA
│   └── database/
│       ├── database_helper.dart # Configuración de SQLite
│       ├── game_stats.dart     # Modelo de estadísticas
│       └── stats_service.dart  # Servicio para manejar estadísticas
├── screens/
│   ├── game_mode_selection.dart # Pantalla de selección de modo
│   ├── tic_tac_toe_game.dart   # Pantalla principal del juego
│   └── statistics_screen.dart  # Pantalla de estadísticas
└── widgets/
    └── (widgets personalizados)
```

## 🔍 Explicación del Código

### 📄 main.dart

**Propósito**: Punto de entrada de la aplicación Flutter.

**Funcionalidades principales**:

- Configuración de orientación vertical únicamente
- Configuración de la barra de estado transparente
- Inicialización de Riverpod para manejo de estado
- Configuración del tema de la aplicación

**Código clave**:

```dart
// Configurar orientación solo vertical
SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);

// Configurar barra de estado
SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ),
);
```

### 🎯 models/game_state.dart

**Propósito**: Contiene toda la lógica del juego y la inteligencia artificial.

**Clases principales**:

#### Enums

- `Player`: Define los jugadores (X, O)
- `GameStatus`: Estados del juego (playing, won, draw)
- `GameMode`: Modos de juego (twoPlayers, vsAI)
- `AIDifficulty`: Niveles de dificultad de la IA (easy, medium, hard)

#### GameState

**Propósito**: Modelo inmutable que representa el estado actual del juego.

**Propiedades**:

- `board`: Tablero de 3x3 con posiciones de jugadores
- `currentPlayer`: Jugador actual
- `status`: Estado del juego
- `winner`: Ganador (si existe)
- `winningLine`: Línea ganadora
- `xScore`, `oScore`: Puntuaciones
- `gameMode`: Modo de juego
- `aiDifficulty`: Dificultad de la IA
- `isAIThinking`: Estado de pensamiento de la IA

#### GameNotifier

**Propósito**: Maneja la lógica del juego y actualiza el estado.

**Métodos principales**:

1. **makeMove(int index)**:

   - Valida el movimiento
   - Actualiza el tablero
   - Verifica resultado del juego
   - Activa la IA si es necesario

2. **\_checkGameResult()**:

   - Verifica combinaciones ganadoras
   - Detecta empates
   - Retorna el resultado del juego

3. **\_makeAIMove()**:

   - Simula pensamiento de la IA
   - Ejecuta el movimiento de la IA
   - Actualiza el estado

4. **\_getAIMove()**:
   - Selecciona el mejor movimiento según la dificultad
   - Implementa diferentes estrategias

### 🎮 screens/game_mode_selection.dart

**Propósito**: Pantalla inicial para seleccionar el modo de juego.

**Funcionalidades**:

- Botón para modo vs IA con selector de dificultad
- Botón para modo multijugador
- Botón de estadísticas
- Animaciones de entrada
- Tablero de ejemplo decorativo

**Componentes principales**:

- `_buildHeader()`: Tablero de ejemplo con animaciones
- `_buildModeButton()`: Botones de modo con gradientes y efectos
- `_showDifficultyDialog()`: Diálogo para seleccionar dificultad de IA

### 🎯 screens/tic_tac_toe_game.dart

**Propósito**: Pantalla principal del juego donde se desarrolla la partida.

**Funcionalidades**:

- Tablero de juego interactivo
- Marcador de puntuación
- Indicador de turno actual
- Botón de nuevo juego
- Diálogo de resultados
- Navegación de regreso

**Componentes principales**:

- `_buildScoreBoard()`: Marcador con gradientes y efectos
- `_buildTurnIndicator()`: Indicador de turno con animaciones
- `_buildGameBoard()`: Tablero 3x3 con efectos visuales
- `_showResultDialog()`: Diálogo de resultado con opciones

## 🎲 Cómo Funciona el Juego

### Reglas Básicas

1. **Objetivo**: Conseguir 3 símbolos iguales en línea (horizontal, vertical o diagonal)
2. **Turnos**: Los jugadores alternan turnos
3. **Movimientos**: Cada jugador coloca su símbolo en una casilla vacía
4. **Fin del juego**: Victoria, empate o derrota

### Flujo del Juego

1. **Inicio**: Selección de modo de juego
2. **Configuración**: Si es vs IA, selección de dificultad
3. **Partida**: Alternancia de turnos hasta resultado
4. **Resultado**: Diálogo con opciones de continuar o salir
5. **Estadísticas**: Actualización automática de datos

### Estados del Juego

- **Playing**: Juego en curso
- **Won**: Hay un ganador
- **Draw**: Empate (tablero lleno sin ganador)

## 🤖 Algoritmo de IA

### Estrategias por Dificultad

#### 🟢 Fácil (Easy)

- **70%** movimientos aleatorios
- **30%** movimientos inteligentes
- Delay: 0.5-1 segundos

#### 🟡 Normal (Medium)

- **40%** movimientos aleatorios
- **60%** movimientos inteligentes
- Delay: 0.8-1.5 segundos

#### 🔴 Difícil (Hard)

- **100%** movimientos óptimos usando algoritmo Minimax
- Delay: 1.2-2 segundos

### Algoritmo Minimax

**Propósito**: Encuentra el movimiento óptimo para la IA.

**Funcionamiento**:

1. **Evaluación**: Cada posición terminal tiene un valor:

   - Victoria de IA: +10
   - Victoria del jugador: -10
   - Empate: 0

2. **Recursión**: Explora todos los movimientos posibles
3. **Minimización**: Minimiza las opciones del jugador
4. **Maximización**: Maximiza las opciones de la IA

**Código clave**:

```dart
Map<String, dynamic> _minimax(List<Player?> board, Player player, int depth) {
  // Verificar estado terminal
  if (_isWinning(board, Player.x)) {
    return {'score': -10 + depth};
  } else if (_isWinning(board, Player.o)) {
    return {'score': 10 - depth};
  } else if (availableMoves.isEmpty) {
    return {'score': 0};
  }

  // Explorar todos los movimientos posibles
  // Retornar el mejor movimiento
}
```

### Estrategia Inteligente

Para niveles fácil y normal, la IA sigue esta prioridad:

1. **Ganar**: Si puede ganar en el siguiente movimiento
2. **Bloquear**: Si el jugador puede ganar, bloquearlo
3. **Centro**: Tomar la casilla central si está disponible
4. **Esquinas**: Tomar una esquina aleatoria
5. **Aleatorio**: Movimiento aleatorio como último recurso

## 💾 Sistema de Estadísticas

### Base de Datos SQLite

- **Tabla**: `game_stats`
- **Campos**:
  - `id`: Identificador único
  - `player_name`: Nombre del jugador
  - `player_type`: Tipo (human, ai)
  - `games_played`: Partidas jugadas
  - `games_won`: Partidas ganadas
  - `games_lost`: Partidas perdidas
  - `games_drawn`: Partidas empatadas
  - `win_rate`: Porcentaje de victorias
  - `created_at`: Fecha de creación
  - `updated_at`: Fecha de actualización

### Funcionalidades

- **Guardado automático**: Cada partida se registra automáticamente
- **Consultas**: Visualización de estadísticas por jugador
- **Persistencia**: Los datos se mantienen entre sesiones
- **Análisis**: Cálculo de porcentajes y tendencias

## 🚀 Instalación

### Prerrequisitos

- Flutter SDK 3.9.0 o superior
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos

1. **Clonar el repositorio**:

   ```bash
   git clone <url-del-repositorio>
   cd tictactoe
   ```

2. **Instalar dependencias**:

   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

## 📱 Uso

### Modo Multijugador

1. Selecciona "Dos Jugadores"
2. Los jugadores alternan turnos tocando las casillas
3. El juego termina cuando hay un ganador o empate

### Modo vs IA

1. Selecciona "Un Jugador vs IA"
2. Elige la dificultad (Fácil, Normal, Difícil)
3. Juega contra la IA
4. Las estadísticas se guardan automáticamente

### Estadísticas

1. Selecciona "Estadísticas" en el menú principal
2. Visualiza las estadísticas de todos los jugadores
3. Consulta porcentajes de victoria y partidas jugadas

## 🛠 Tecnologías Utilizadas

### Frontend

- **Flutter**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño

### Estado y Datos

- **Riverpod**: Manejo de estado reactivo
- **SQLite**: Base de datos local
- **sqflite**: Plugin de SQLite para Flutter

### UI/UX

- **flutter_animate**: Animaciones fluidas
- **iconsax**: Iconografía moderna
- **Custom Painters**: Elementos visuales personalizados

### Arquitectura

- **StateNotifier**: Patrón de estado inmutable
- **Provider Pattern**: Inyección de dependencias
- **Repository Pattern**: Separación de lógica de datos

## 🎯 Trucos y Estrategias

### Para Ganar Contra la IA

1. **Nivel Fácil**: La IA comete errores, aprovecha las oportunidades
2. **Nivel Normal**: Juega defensivamente, evita que la IA gane
3. **Nivel Difícil**: Es imposible ganar, solo puedes empatar

### Estrategias Generales

1. **Control del Centro**: La casilla central es la más valiosa
2. **Esquinas**: Las esquinas son estratégicamente importantes
3. **Bloqueo**: Siempre bloquea al oponente si puede ganar
4. **Patrones**: Aprende los patrones ganadores comunes

### Patrones Ganadores

```
X | X | X     X |   |       X |   |
---------     ---------     ---------
  |   |         | X |         | X |
---------     ---------     ---------
  |   |         |   | X       |   | X
```

## 📊 Métricas de Rendimiento

- **Tiempo de respuesta**: < 100ms para movimientos humanos
- **IA Delay**: 0.5-2 segundos según dificultad
- **Memoria**: < 50MB de uso
- **Base de datos**: Optimizada para consultas rápidas

## 🔮 Futuras Mejoras

- [ ] Modo multijugador online
- [ ] Más niveles de dificultad
- [ ] Temas personalizables
- [ ] Sonidos y música
- [ ] Modo torneo
- [ ] Análisis de partidas
- [ ] Exportar estadísticas

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👨‍💻 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📞 Contacto

Para preguntas o sugerencias, contacta al desarrollador.

---

**¡Disfruta jugando Tic Tac Toe! 🎮**
