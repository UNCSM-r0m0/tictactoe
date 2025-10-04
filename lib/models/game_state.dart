import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'database/stats_service.dart';

enum Player { x, o }

enum GameStatus { playing, won, draw }

enum GameMode { twoPlayers, vsAI }

enum AIDifficulty { easy, medium, hard }

class GameState {
  final List<Player?> board;
  final Player currentPlayer;
  final GameStatus status;
  final Player? winner;
  final List<int> winningLine;
  final int xScore;
  final int oScore;
  final GameMode gameMode;
  final AIDifficulty aiDifficulty;
  final bool isAIThinking;

  const GameState({
    required this.board,
    required this.currentPlayer,
    required this.status,
    this.winner,
    required this.winningLine,
    required this.xScore,
    required this.oScore,
    required this.gameMode,
    required this.aiDifficulty,
    required this.isAIThinking,
  });

  factory GameState.initial() {
    return GameState(
      board: List.filled(9, null),
      currentPlayer: Player.x,
      status: GameStatus.playing,
      winner: null,
      winningLine: [],
      xScore: 0,
      oScore: 0,
      gameMode: GameMode.twoPlayers,
      aiDifficulty: AIDifficulty.medium,
      isAIThinking: false,
    );
  }

  GameState copyWith({
    List<Player?>? board,
    Player? currentPlayer,
    GameStatus? status,
    Player? winner,
    List<int>? winningLine,
    int? xScore,
    int? oScore,
    GameMode? gameMode,
    AIDifficulty? aiDifficulty,
    bool? isAIThinking,
  }) {
    return GameState(
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      winningLine: winningLine ?? this.winningLine,
      xScore: xScore ?? this.xScore,
      oScore: oScore ?? this.oScore,
      gameMode: gameMode ?? this.gameMode,
      aiDifficulty: aiDifficulty ?? this.aiDifficulty,
      isAIThinking: isAIThinking ?? this.isAIThinking,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState.initial());

  final Random _random = Random();
  final StatsService _statsService = StatsService();

  static const List<List<int>> _winningCombinations = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Filas
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columnas
    [0, 4, 8], [2, 4, 6], // Diagonales
  ];

  void makeMove(int index) {
    if (state.board[index] != null ||
        state.status != GameStatus.playing ||
        state.isAIThinking) {
      return;
    }

    final newBoard = List<Player?>.from(state.board);
    newBoard[index] = state.currentPlayer;

    final result = _checkGameResult(newBoard);

    state = state.copyWith(
      board: newBoard,
      currentPlayer: state.currentPlayer == Player.x ? Player.o : Player.x,
      status: result['status'],
      winner: result['winner'],
      winningLine: result['winningLine'] ?? [],
    );

    // Si es modo vs IA y ahora es turno de O (IA), hacer movimiento automático
    if (state.gameMode == GameMode.vsAI &&
        state.currentPlayer == Player.o &&
        state.status == GameStatus.playing) {
      _makeAIMove();
    }
  }

  Map<String, dynamic> _checkGameResult(List<Player?> board) {
    // Verificar combinaciones ganadoras
    for (final combination in _winningCombinations) {
      final a = board[combination[0]];
      final b = board[combination[1]];
      final c = board[combination[2]];

      if (a != null && a == b && b == c) {
        return {
          'status': GameStatus.won,
          'winner': a,
          'winningLine': combination,
        };
      }
    }

    // Verificar empate
    if (!board.contains(null)) {
      return {
        'status': GameStatus.draw,
        'winner': null,
        'winningLine': <int>[],
      };
    }

    // Juego continúa
    return {
      'status': GameStatus.playing,
      'winner': null,
      'winningLine': <int>[],
    };
  }

  void resetGame() {
    state = state.copyWith(
      board: List.filled(9, null),
      currentPlayer: Player.x,
      status: GameStatus.playing,
      winner: null,
      winningLine: [],
    );
  }

  void updateScore() {
    if (state.winner == Player.x) {
      state = state.copyWith(xScore: state.xScore + 1);
    } else if (state.winner == Player.o) {
      state = state.copyWith(oScore: state.oScore + 1);
    }

    // Guardar estadísticas en la base de datos
    _saveGameStats();
  }

  Future<void> _saveGameStats() async {
    if (state.status == GameStatus.won) {
      // Guardar estadísticas del ganador
      if (state.winner == Player.x) {
        if (state.gameMode == GameMode.vsAI) {
          // Jugador X ganó contra IA
          await _statsService.updatePlayerStats(
            playerName: 'Jugador X',
            playerType: 'human',
            result: 'won',
          );
          await _statsService.updatePlayerStats(
            playerName: 'IA',
            playerType: 'ai',
            result: 'lost',
          );
        } else {
          // Jugador X ganó contra Jugador O
          await _statsService.updatePlayerStats(
            playerName: 'Jugador X',
            playerType: 'human',
            result: 'won',
          );
          await _statsService.updatePlayerStats(
            playerName: 'Jugador O',
            playerType: 'human',
            result: 'lost',
          );
        }
      } else {
        // Jugador O ganó
        if (state.gameMode == GameMode.vsAI) {
          // IA ganó contra Jugador X
          await _statsService.updatePlayerStats(
            playerName: 'IA',
            playerType: 'ai',
            result: 'won',
          );
          await _statsService.updatePlayerStats(
            playerName: 'Jugador X',
            playerType: 'human',
            result: 'lost',
          );
        } else {
          // Jugador O ganó contra Jugador X
          await _statsService.updatePlayerStats(
            playerName: 'Jugador O',
            playerType: 'human',
            result: 'won',
          );
          await _statsService.updatePlayerStats(
            playerName: 'Jugador X',
            playerType: 'human',
            result: 'lost',
          );
        }
      }
    } else if (state.status == GameStatus.draw) {
      // Empate - ambos jugadores empatan
      if (state.gameMode == GameMode.vsAI) {
        await _statsService.updatePlayerStats(
          playerName: 'Jugador X',
          playerType: 'human',
          result: 'drawn',
        );
        await _statsService.updatePlayerStats(
          playerName: 'IA',
          playerType: 'ai',
          result: 'drawn',
        );
      } else {
        await _statsService.updatePlayerStats(
          playerName: 'Jugador X',
          playerType: 'human',
          result: 'drawn',
        );
        await _statsService.updatePlayerStats(
          playerName: 'Jugador O',
          playerType: 'human',
          result: 'drawn',
        );
      }
    }
  }

  void resetScores() {
    state = state.copyWith(xScore: 0, oScore: 0);
  }

  void setGameMode(GameMode mode) {
    state = state.copyWith(gameMode: mode);
  }

  void setAIDifficulty(AIDifficulty difficulty) {
    state = state.copyWith(aiDifficulty: difficulty);
  }

  Future<void> _makeAIMove() async {
    if (state.status != GameStatus.playing) return;

    // Mostrar que la IA está pensando
    state = state.copyWith(isAIThinking: true);

    // Delay para simular pensamiento de IA
    await Future.delayed(Duration(milliseconds: _getAIDelay()));

    final aiMove = _getAIMove();
    if (aiMove != -1) {
      final newBoard = List<Player?>.from(state.board);
      newBoard[aiMove] = Player.o;

      final result = _checkGameResult(newBoard);

      state = state.copyWith(
        board: newBoard,
        currentPlayer: Player.x,
        status: result['status'],
        winner: result['winner'],
        winningLine: result['winningLine'] ?? [],
        isAIThinking: false,
      );
    } else {
      state = state.copyWith(isAIThinking: false);
    }
  }

  int _getAIDelay() {
    switch (state.aiDifficulty) {
      case AIDifficulty.easy:
        return 500 + _random.nextInt(500); // 0.5-1s
      case AIDifficulty.medium:
        return 800 + _random.nextInt(700); // 0.8-1.5s
      case AIDifficulty.hard:
        return 1200 + _random.nextInt(800); // 1.2-2s
    }
  }

  int _getAIMove() {
    final availableMoves = <int>[];
    for (int i = 0; i < 9; i++) {
      if (state.board[i] == null) {
        availableMoves.add(i);
      }
    }

    if (availableMoves.isEmpty) return -1;

    switch (state.aiDifficulty) {
      case AIDifficulty.easy:
        return _getEasyMove(availableMoves);
      case AIDifficulty.medium:
        return _getMediumMove(availableMoves);
      case AIDifficulty.hard:
        return _getHardMove(availableMoves);
    }
  }

  int _getEasyMove(List<int> availableMoves) {
    // 70% movimiento aleatorio, 30% movimiento inteligente
    if (_random.nextDouble() < 0.7) {
      return availableMoves[_random.nextInt(availableMoves.length)];
    } else {
      return _getBestMove(availableMoves);
    }
  }

  int _getMediumMove(List<int> availableMoves) {
    // 40% movimiento aleatorio, 60% movimiento inteligente
    if (_random.nextDouble() < 0.4) {
      return availableMoves[_random.nextInt(availableMoves.length)];
    } else {
      return _getBestMove(availableMoves);
    }
  }

  int _getHardMove(List<int> availableMoves) {
    // Siempre movimiento óptimo usando minimax
    return _minimax(state.board, Player.o, 0)['index'] ?? availableMoves.first;
  }

  int _getBestMove(List<int> availableMoves) {
    // 1. Intentar ganar
    for (final move in availableMoves) {
      final testBoard = List<Player?>.from(state.board);
      testBoard[move] = Player.o;
      if (_isWinning(testBoard, Player.o)) {
        return move;
      }
    }

    // 2. Bloquear al jugador
    for (final move in availableMoves) {
      final testBoard = List<Player?>.from(state.board);
      testBoard[move] = Player.x;
      if (_isWinning(testBoard, Player.x)) {
        return move;
      }
    }

    // 3. Tomar el centro si está disponible
    if (availableMoves.contains(4)) {
      return 4;
    }

    // 4. Tomar una esquina
    final corners = [0, 2, 6, 8];
    final availableCorners = corners.where(availableMoves.contains).toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[_random.nextInt(availableCorners.length)];
    }

    // 5. Movimiento aleatorio
    return availableMoves[_random.nextInt(availableMoves.length)];
  }

  bool _isWinning(List<Player?> board, Player player) {
    for (final combination in _winningCombinations) {
      if (board[combination[0]] == player &&
          board[combination[1]] == player &&
          board[combination[2]] == player) {
        return true;
      }
    }
    return false;
  }

  Map<String, dynamic> _minimax(List<Player?> board, Player player, int depth) {
    final availableMoves = <int>[];
    for (int i = 0; i < 9; i++) {
      if (board[i] == null) {
        availableMoves.add(i);
      }
    }

    // Verificar estado terminal
    if (_isWinning(board, Player.x)) {
      return {'score': -10 + depth};
    } else if (_isWinning(board, Player.o)) {
      return {'score': 10 - depth};
    } else if (availableMoves.isEmpty) {
      return {'score': 0};
    }

    final moves = <Map<String, dynamic>>[];

    for (final move in availableMoves) {
      final testBoard = List<Player?>.from(board);
      testBoard[move] = player;

      final result = _minimax(
        testBoard,
        player == Player.x ? Player.o : Player.x,
        depth + 1,
      );

      moves.add({'index': move, 'score': result['score']});
    }

    Map<String, dynamic> bestMove;
    if (player == Player.o) {
      // Maximizar para IA
      bestMove = moves.reduce(
        (a, b) => (a['score'] as int) > (b['score'] as int) ? a : b,
      );
    } else {
      // Minimizar para jugador
      bestMove = moves.reduce(
        (a, b) => (a['score'] as int) < (b['score'] as int) ? a : b,
      );
    }

    return bestMove;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
