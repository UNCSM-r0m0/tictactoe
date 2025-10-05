import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger personalizado para la aplicación
/// Solo muestra logs en modo debug, en release no muestra nada
class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  late final Logger _logger;

  /// Inicializa el logger
  void init() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Número de métodos en el stack trace
        errorMethodCount: 8, // Número de métodos en errores
        lineLength: 120, // Ancho de línea
        colors: true, // Colores en consola
        printEmojis: true, // Emojis en los logs
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: ProductionFilter(), // Solo logs en debug, nada en release
    );
  }

  /// Log de depuración (azul) - Para información de desarrollo
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log de información (azul claro) - Para información general
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log de advertencia (naranja) - Para situaciones que podrían ser problemáticas
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log de error (rojo) - Para errores que no rompen la app
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log crítico (rojo intenso) - Para errores graves
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
}

// Instancia global para fácil acceso
final logger = AppLogger();
