import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'game_mode_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    // Esperar 3 segundos para mostrar el splash screen
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameModeSelection(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF2D3748)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo del Tic Tac Toe más grande
              _buildTicTacToeLogo(),

              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

              // Título de la app
              Text(
                'TIC TAC TOE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.3, end: 0),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              // Subtítulo
              Text(
                'Juego Clásico de Tres en Raya',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w300,
                ),
              ).animate().fadeIn(duration: 1500.ms).slideY(begin: 0.3, end: 0),

              SizedBox(height: MediaQuery.of(context).size.height * 0.08),

              // Indicador de carga
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.7),
                  ),
                ),
              ).animate().fadeIn(duration: 2000.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicTacToeLogo() {
    final size = MediaQuery.of(context).size.width * 0.4; // Logo más grande

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Líneas del tablero
              Positioned.fill(
                child: CustomPaint(painter: TicTacToeBoardPainter()),
              ),

              // X's y O's del logo
              Positioned(
                top: size * 0.1,
                left: size * 0.1,
                child: _buildLogoX(size * 0.25),
              ),
              Positioned(
                top: size * 0.1,
                right: size * 0.1,
                child: _buildLogoO(size * 0.25),
              ),
              Positioned(
                bottom: size * 0.1,
                left: size * 0.1,
                child: _buildLogoO(size * 0.25),
              ),
              Positioned(
                bottom: size * 0.1,
                right: size * 0.1,
                child: _buildLogoX(size * 0.25),
              ),
              Positioned(
                top: size * 0.5 - (size * 0.25) / 2,
                left: size * 0.5 - (size * 0.25) / 2,
                child: _buildLogoX(size * 0.25),
              ),
            ],
          ),
        )
        .animate()
        .scale(duration: 1500.ms, curve: Curves.elasticOut)
        .fadeIn(duration: 1000.ms);
  }

  Widget _buildLogoX(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFF5252).withOpacity(0.1),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: const Color(0xFFFF5252), width: 2),
      ),
      child: Icon(
        Iconsax.close_circle,
        color: const Color(0xFFFF5252),
        size: size * 0.6,
      ),
    );
  }

  Widget _buildLogoO(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF4FC3F7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: const Color(0xFF4FC3F7), width: 2),
      ),
      child: Icon(
        Iconsax.cpu,
        color: const Color(0xFF4FC3F7),
        size: size * 0.6,
      ),
    );
  }
}

class TicTacToeBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Líneas verticales
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Líneas horizontales
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
