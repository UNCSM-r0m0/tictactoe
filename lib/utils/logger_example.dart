// ignore_for_file: unused_element

import 'app_logger.dart';

/// Ejemplos de uso del logger
/// Este archivo es solo para referencia y no se usa en la app
class LoggerExample {
  /// Ejemplo básico de todos los niveles
  void _basicExample() {
    logger.debug('Esto es un mensaje de debug');
    logger.info('Esto es información general');
    logger.warning('Esto es una advertencia');
    logger.error('Esto es un error');
    logger.fatal('Esto es un error crítico');
  }

  /// Ejemplo con variables
  void _variablesExample() {
    final userName = 'Juan';
    final score = 150;

    logger.debug('Usuario: $userName, Puntuación: $score');
    logger.info('El jugador $userName alcanzó $score puntos');
  }

  /// Ejemplo con errores y stack traces
  Future<void> _errorExample() async {
    try {
      // Simular operación que puede fallar
      await _riskyOperation();
    } catch (e, stackTrace) {
      // Forma correcta de loggear errores
      logger.error('Error en operación riesgosa', e, stackTrace);
    }
  }

  /// Ejemplo de logging en diferentes contextos
  void _contextExample() {
    // Durante desarrollo
    logger.debug('Inicializando servicio...');
    logger.debug('Configuración cargada: ${_getConfig()}');

    // Eventos importantes
    logger.info('Usuario autenticado correctamente');
    logger.info('Datos sincronizados con el servidor');

    // Situaciones inusuales
    logger.warning('Caché lleno, limpiando...');
    logger.warning('Conexión lenta detectada');

    // Errores manejados
    logger.error('Fallo al cargar imagen, usando placeholder');

    // Errores críticos
    logger.fatal('Base de datos corrupta, requiere intervención');
  }

  /// Ejemplo comparando print vs logger
  void _comparisonExample() {
    // ❌ MAL - Usando print (aparece en Release)
    // print('Usuario inició sesión');

    // ✅ BIEN - Usando logger (NO aparece en Release)
    logger.info('Usuario inició sesión');

    // ❌ MAL - Print con error
    // print('Error: $error');

    // ✅ BIEN - Logger con error y stackTrace
    try {
      throw Exception('Error de ejemplo');
    } catch (e, stackTrace) {
      logger.error('Error capturado', e, stackTrace);
    }
  }

  /// Simulación de operación riesgosa
  Future<void> _riskyOperation() async {
    throw Exception('Algo salió mal');
  }

  /// Simulación de configuración
  Map<String, dynamic> _getConfig() {
    return {'debug': true, 'version': '1.0.0'};
  }
}

/// Salida esperada en consola (solo en Debug):
/// 
/// 🐛 [D] Esto es un mensaje de debug
/// 💡 [I] Esto es información general
/// ⚠️  [W] Esto es una advertencia
/// ⚠️  [E] Esto es un error
/// 🚨 [F] Esto es un error crítico
/// 
/// En modo Release: (sin salida, completamente silencioso)

