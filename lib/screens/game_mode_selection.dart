import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../models/game_state.dart';
import 'tic_tac_toe_game.dart';

class GameModeSelection extends ConsumerStatefulWidget {
  const GameModeSelection({super.key});

  @override
  ConsumerState<GameModeSelection> createState() => _GameModeSelectionState();
}

class _GameModeSelectionState extends ConsumerState<GameModeSelection> {
  AIDifficulty selectedDifficulty = AIDifficulty.medium;

  void _startGame(GameMode mode) {
    final gameNotifier = ref.read(gameProvider.notifier);
    gameNotifier.setGameMode(mode);
    if (mode == GameMode.vsAI) {
      gameNotifier.setAIDifficulty(selectedDifficulty);
    }
    gameNotifier.resetGame();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TicTacToeGameScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(1.0, 0.0),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header con el tablero de ejemplo
              _buildHeader(),

              const SizedBox(height: 40),

              // Botones de modo de juego
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildModeButton(
                      title: 'Un Jugador vs IA',
                      icon: Iconsax.user,
                      color: const Color(0xFF4FC3F7),
                      onTap: () => _showDifficultyDialog(),
                    ),

                    const SizedBox(height: 20),

                    _buildModeButton(
                      title: 'Dos Jugadores',
                      icon: Iconsax.people,
                      color: const Color(0xFFFF5252),
                      onTap: () => _startGame(GameMode.twoPlayers),
                    ),

                    const SizedBox(height: 20),

                    _buildModeButton(
                      title: 'Estadísticas',
                      icon: Iconsax.chart,
                      color: const Color(0xFFFFD54F),
                      onTap: () {
                        // TODO: Implementar estadísticas
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Tablero de ejemplo con X y O
        Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F3A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2D3748), width: 2),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  String symbol = '';
                  Color color = Colors.transparent;

                  // Patrón de ejemplo del tablero
                  switch (index) {
                    case 0:
                    case 4:
                    case 8:
                      symbol = 'X';
                      color = const Color(0xFFFF5252);
                      break;
                    case 2:
                    case 6:
                      symbol = 'O';
                      color = const Color(0xFF4FC3F7);
                      break;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E27),
                      borderRadius: BorderRadius.circular(8),
                      border: index == 0 || index == 4 || index == 8
                          ? Border.all(color: const Color(0xFFFF5252), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: symbol.isNotEmpty
                          ? Text(
                              symbol,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800))
            .scale(
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
            ),
      ],
    );
  }

  Widget _buildModeButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(
            milliseconds: title == 'Un Jugador vs IA'
                ? 200
                : title == 'Dos Jugadores'
                ? 400
                : 600,
          ),
          duration: const Duration(milliseconds: 600),
        )
        .slideX(
          delay: Duration(
            milliseconds: title == 'Un Jugador vs IA'
                ? 200
                : title == 'Dos Jugadores'
                ? 400
                : 600,
          ),
          begin: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
        );
  }

  void _showDifficultyDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2D3748), width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                const Text(
                  'Elegir Dificultad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Opciones de dificultad
                _buildDifficultyOption(
                  'Fácil',
                  AIDifficulty.easy,
                  const Color(0xFF4CAF50),
                ),

                const SizedBox(height: 16),

                _buildDifficultyOption(
                  'Normal',
                  AIDifficulty.medium,
                  const Color(0xFFFF9800),
                ),

                const SizedBox(height: 16),

                _buildDifficultyOption(
                  'Difícil',
                  AIDifficulty.hard,
                  const Color(0xFFF44336),
                ),

                const SizedBox(height: 30),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D3748),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
                          _startGame(GameMode.vsAI);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4FC3F7).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Continuar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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

  Widget _buildDifficultyOption(
    String title,
    AIDifficulty difficulty,
    Color color,
  ) {
    final isSelected = selectedDifficulty == difficulty;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDifficulty = difficulty;
        });
      },
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF0A0E27),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : const Color(0xFF2D3748),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : const Color(0xFF2D3748),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
