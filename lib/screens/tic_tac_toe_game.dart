import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../models/game_state.dart';
import 'game_mode_selection.dart';

class TicTacToeGameScreen extends ConsumerStatefulWidget {
  const TicTacToeGameScreen({super.key});

  @override
  ConsumerState<TicTacToeGameScreen> createState() =>
      _TicTacToeGameScreenState();
}

class _TicTacToeGameScreenState extends ConsumerState<TicTacToeGameScreen> {
  void _goBackToModeSelection() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const GameModeSelection(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    // Actualizar puntaje cuando hay ganador
    ref.listen<GameState>(gameProvider, (previous, next) {
      if (previous?.status != GameStatus.won && next.status == GameStatus.won) {
        Future.delayed(const Duration(milliseconds: 500), () {
          gameNotifier.updateScore();
          _showResultDialog(next);
        });
      } else if (previous?.status != GameStatus.draw &&
          next.status == GameStatus.draw) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _showResultDialog(next);
        });
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header con botón de regreso y título
              Row(
                children: [
                  GestureDetector(
                    onTap: _goBackToModeSelection,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F3A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2D3748),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Iconsax.arrow_left_2,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Tic Tac Toe',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ), // Para balancear el botón de regreso
                ],
              ),

              const SizedBox(height: 30),

              // Marcador de jugadores
              _buildScoreBoard(gameState),

              const SizedBox(height: 30),

              // Indicador de turno
              _buildTurnIndicator(gameState),

              const SizedBox(height: 30),

              // Tablero de juego
              Expanded(child: _buildGameBoard(gameState, gameNotifier)),

              const SizedBox(height: 30),

              // Botón de nuevo juego
              _buildNewGameButton(gameNotifier),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard(GameState gameState) {
    return Row(
      children: [
        // Jugador X
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFE57373)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5252).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.close_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      gameState.gameMode == GameMode.vsAI
                          ? 'JUGADOR'
                          : 'JUGADOR X',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  gameState.xScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Jugador O / IA
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF81D4FA)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4FC3F7).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      gameState.gameMode == GameMode.vsAI
                          ? Iconsax.cpu
                          : Iconsax.record_circle,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      gameState.gameMode == GameMode.vsAI ? 'IA' : 'JUGADOR O',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  gameState.oScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTurnIndicator(GameState gameState) {
    if (gameState.status != GameStatus.playing) {
      return const SizedBox();
    }

    final isPlayerXTurn = gameState.currentPlayer == Player.x;
    final color = isPlayerXTurn
        ? const Color(0xFFFF5252)
        : const Color(0xFF4FC3F7);

    String turnText;
    if (gameState.isAIThinking) {
      turnText = 'IA está pensando...';
    } else if (gameState.gameMode == GameMode.vsAI) {
      turnText = isPlayerXTurn ? 'Tu turno' : 'Turno de IA';
    } else {
      turnText = isPlayerXTurn ? 'Turno de X' : 'Turno de O';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (gameState.isAIThinking) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            Icon(
              isPlayerXTurn
                  ? Iconsax.close_circle
                  : (gameState.gameMode == GameMode.vsAI
                        ? Iconsax.cpu
                        : Iconsax.record_circle),
              color: color,
              size: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              turnText,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(GameState gameState, GameNotifier gameNotifier) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2D3748), width: 2),
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final player = gameState.board[index];
            final isWinningCell = gameState.winningLine.contains(index);

            return GestureDetector(
              onTap: () => gameNotifier.makeMove(index),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E27),
                  borderRadius: BorderRadius.circular(15),
                  border: isWinningCell
                      ? Border.all(
                          color: player == Player.x
                              ? const Color(0xFFFF5252)
                              : const Color(0xFF4FC3F7),
                          width: 3,
                        )
                      : Border.all(color: const Color(0xFF2D3748), width: 1),
                  boxShadow: isWinningCell
                      ? [
                          BoxShadow(
                            color:
                                (player == Player.x
                                        ? const Color(0xFFFF5252)
                                        : const Color(0xFF4FC3F7))
                                    .withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: player == null
                      ? null
                      : Icon(
                              player == Player.x
                                  ? Iconsax.close_circle
                                  : Iconsax.record_circle,
                              size: 40,
                              color: player == Player.x
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF4FC3F7),
                            )
                            .animate()
                            .scale(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(
                              duration: const Duration(milliseconds: 200),
                            ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewGameButton(GameNotifier gameNotifier) {
    return GestureDetector(
      onTap: () => gameNotifier.resetGame(),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.refresh, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Nuevo Juego',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(GameState gameState) {
    String title;
    String message;
    Color color;
    IconData icon;

    if (gameState.status == GameStatus.won) {
      if (gameState.winner == Player.x) {
        title = gameState.gameMode == GameMode.vsAI ? '¡Ganador!' : '¡X Gana!';
        message = gameState.gameMode == GameMode.vsAI
            ? '¡Felicidades! Ganaste el juego'
            : 'El Jugador X ganó el juego';
        color = const Color(0xFFFF5252);
        icon = Iconsax.cup;
      } else {
        title = gameState.gameMode == GameMode.vsAI ? '¡Perdiste!' : '¡O Gana!';
        message = gameState.gameMode == GameMode.vsAI
            ? 'La IA ganó esta vez. ¡Inténtalo de nuevo!'
            : 'El Jugador O ganó el juego';
        color = const Color(0xFF4FC3F7);
        icon = Iconsax.cup;
      }
    } else {
      title = 'Empate';
      message = 'Juego empatado';
      color = const Color(0xFFFFD54F);
      icon = Iconsax.people;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(icon, size: 40, color: color),
                ),

                const SizedBox(height: 20),

                // Título
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Mensaje
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 30),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          _goBackToModeSelection();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Salir',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          ref.read(gameProvider.notifier).resetGame();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Jugar de Nuevo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
