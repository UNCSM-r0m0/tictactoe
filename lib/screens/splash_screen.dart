import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'game_mode_selection.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _navigateToMainScreen();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const GameModeSelection(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con degradado animado
          _buildAnimatedBackground(),

          // Partículas flotantes de fondo
          _buildFloatingParticles(),

          // Contenido principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.08,
                    vertical: screenSize.height * 0.05,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo con animación de pulso mejorada
                      _buildEnhancedLogo(screenSize, isSmallScreen),

                      SizedBox(height: screenSize.height * 0.06),

                      // Título con estilo premium
                      _buildPremiumTitle(screenSize, isSmallScreen),

                      SizedBox(height: screenSize.height * 0.015),

                      // Subtítulo elegante
                      _buildSubtitle(screenSize, isSmallScreen),

                      SizedBox(height: screenSize.height * 0.04),

                      // Características destacadas
                      _buildFeatureChips(screenSize, isSmallScreen),

                      SizedBox(height: screenSize.height * 0.06),

                      // Indicador de carga moderno
                      _buildModernLoadingIndicator(screenSize),

                      SizedBox(height: screenSize.height * 0.03),

                      // Texto de carga
                      _buildLoadingText(screenSize, isSmallScreen),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Versión en la parte inferior
          _buildVersionInfo(screenSize),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0E27),
                Color(0xFF1A1F3A),
                Color(0xFF2D3748),
                Color(0xFF1A1F3A),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 3000.ms,
          color: Colors.white.withValues(alpha: 0.03),
        );
  }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(
        8,
        (index) => Positioned(
          left: (index * 47) % 100.0,
          top: (index * 83) % 100.0,
          child:
              Container(
                    width: 4 + (index % 3) * 2,
                    height: 4 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeIn(duration: 2000.ms)
                  .then(delay: (index * 200).ms)
                  .moveY(
                    begin: 0,
                    end: -50,
                    duration: (3000 + index * 500).ms,
                    curve: Curves.easeInOut,
                  )
                  .fadeOut(duration: 1000.ms),
        ),
      ),
    );
  }

  Widget _buildEnhancedLogo(Size screenSize, bool isSmallScreen) {
    final logoSize = isSmallScreen
        ? screenSize.width * 0.45
        : screenSize.width * 0.5;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child:
              Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(logoSize * 0.2),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A1F3A),
                          const Color(0xFF0A0E27),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4FC3F7).withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFF5252).withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(-10, -10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Líneas del tablero con efecto neón
                        Positioned.fill(
                          child: CustomPaint(
                            painter: EnhancedTicTacToeBoardPainter(),
                          ),
                        ),

                        // Símbolos con posiciones estratégicas
                        _buildLogoSymbol(logoSize, 0.12, 0.12, true),
                        _buildLogoSymbol(logoSize, 0.12, 0.63, false),
                        _buildLogoSymbol(logoSize, 0.63, 0.12, false),
                        _buildLogoSymbol(logoSize, 0.63, 0.63, true),
                        _buildLogoSymbol(logoSize, 0.375, 0.375, true),
                      ],
                    ),
                  )
                  .animate()
                  .scale(
                    duration: 1200.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                  )
                  .fadeIn(duration: 800.ms),
        );
      },
    );
  }

  Widget _buildLogoSymbol(
    double logoSize,
    double topFraction,
    double leftFraction,
    bool isX,
  ) {
    final symbolSize = logoSize * 0.2;

    return Positioned(
      top: logoSize * topFraction,
      left: logoSize * leftFraction,
      child:
          Container(
                width: symbolSize,
                height: symbolSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isX
                        ? [const Color(0xFFFF5252), const Color(0xFFFF1744)]
                        : [const Color(0xFF4FC3F7), const Color(0xFF0288D1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isX
                                  ? const Color(0xFFFF5252)
                                  : const Color(0xFF4FC3F7))
                              .withValues(alpha: 0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  isX ? Iconsax.close_circle5 : Iconsax.record_circle,
                  color: Colors.white,
                  size: symbolSize * 0.6,
                ),
              )
              .animate()
              .fadeIn(delay: (topFraction * 1000).ms, duration: 600.ms)
              .scale(begin: const Offset(0, 0), curve: Curves.elasticOut),
    );
  }

  Widget _buildPremiumTitle(Size screenSize, bool isSmallScreen) {
    final fontSize = isSmallScreen
        ? screenSize.width * 0.09
        : screenSize.width * 0.11;

    return ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFF4FC3F7), Color(0xFFFF5252)],
            stops: [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: Text(
            'TIC TAC TOE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              height: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 800.ms)
        .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildSubtitle(Size screenSize, bool isSmallScreen) {
    final fontSize = isSmallScreen
        ? screenSize.width * 0.038
        : screenSize.width * 0.042;

    return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.012,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            'Juego Clásico de Tres en Raya',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              height: 1.4,
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildFeatureChips(Size screenSize, bool isSmallScreen) {
    final features = [
      {'icon': Iconsax.game, 'text': '3 Dificultades'},
      {'icon': Iconsax.chart, 'text': 'Estadísticas'},
      {'icon': Iconsax.people, 'text': '2 Jugadores'},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: screenSize.width * 0.03,
      runSpacing: screenSize.height * 0.015,
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04,
                vertical: screenSize.height * 0.01,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    color: const Color(0xFF4FC3F7),
                    size: isSmallScreen ? 16 : 18,
                  ),
                  SizedBox(width: screenSize.width * 0.02),
                  Text(
                    feature['text'] as String,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isSmallScreen
                          ? screenSize.width * 0.032
                          : screenSize.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(delay: (800 + index * 150).ms, duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut);
      }).toList(),
    );
  }

  Widget _buildModernLoadingIndicator(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.12,
      height: screenSize.width * 0.12,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo exterior
          SizedBox(
            width: screenSize.width * 0.12,
            height: screenSize.width * 0.12,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4FC3F7),
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          // Círculo interior
          SizedBox(
                width: screenSize.width * 0.08,
                height: screenSize.width * 0.08,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFF5252),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 1500.ms),
        ],
      ),
    ).animate().fadeIn(delay: 1400.ms, duration: 800.ms);
  }

  Widget _buildLoadingText(Size screenSize, bool isSmallScreen) {
    return Text(
          'Cargando experiencia...',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: isSmallScreen
                ? screenSize.width * 0.032
                : screenSize.width * 0.035,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .fadeIn(duration: 1000.ms)
        .then(delay: 500.ms)
        .fadeOut(duration: 1000.ms);
  }

  Widget _buildVersionInfo(Size screenSize) {
    return Positioned(
      bottom: screenSize.height * 0.03,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.height * 0.008,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            'v1.0.0 • Premium Edition',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: screenSize.width * 0.028,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 2000.ms, duration: 800.ms);
  }
}

// Painter mejorado con efecto neón
class EnhancedTicTacToeBoardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.3)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Dibujar efecto de resplandor primero
    _drawGridLines(canvas, size, glowPaint);

    // Dibujar líneas principales encima
    _drawGridLines(canvas, size, paint);
  }

  void _drawGridLines(Canvas canvas, Size size, Paint paint) {
    final padding = size.width * 0.1;
    final gridSize = size.width - (padding * 2);
    final cellSize = gridSize / 3;

    // Líneas verticales
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(padding + (cellSize * i), padding),
        Offset(padding + (cellSize * i), size.height - padding),
        paint,
      );
    }

    // Líneas horizontales
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(padding, padding + (cellSize * i)),
        Offset(size.width - padding, padding + (cellSize * i)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
