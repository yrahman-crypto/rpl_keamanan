import 'package:flutter/foundation.dart';

/// Class utilitas untuk pencatatan log terstruktur dan aman.
///
/// Log hanya akan dicetak pada saat aplikasi berjalan dalam mode debug
/// menggunakan [kDebugMode] dan secara otomatis menyaring kata kunci data sensitif.
class Logger {
  // Daftar kata kunci data sensitif yang tidak boleh dicatat secara bebas
  static final List<String> _sensitiveKeys = [
    'password',
    'token',
    'secret',
    'api_key',
    'apikey',
    'authorization',
  ];

  /// a) Level log: debug
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('DEBUG', message, error, stackTrace);
  }

  /// a) Level log: info
  static void info(String message) {
    _log('INFO', message);
  }

  /// a) Level log: warning
  static void warning(String message, [dynamic error]) {
    _log('WARNING', message, error);
  }

  /// a) Level log: error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log('ERROR', message, error, stackTrace);
  }

  /// Fungsi internal pembantu untuk memformat dan mencetak log.
  static void _log(
    String level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    // b) Hanya mencatat log saat dalam mode debug
    if (!kDebugMode) return;

    // c) Sensor data sensitif sebelum dicetak
    final safeMessage = _maskSensitiveData(message);
    final timestamp = DateTime.now().toIso8601String();
    final logOutput = '[$timestamp] [$level] $safeMessage';

    debugPrint(logOutput);

    if (error != null) {
      debugPrint('   └─ Detail Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('   └─ StackTrace: $stackTrace');
    }
  }

  /// c) Menyaring pesan dari indikasi token/password sensitif
  static String _maskSensitiveData(String input) {
    String sanitized = input;
    for (final key in _sensitiveKeys) {
      if (sanitized.toLowerCase().contains(key)) {
        sanitized = sanitized.replaceAll(
          RegExp('$key\\s*[:=]\\s*[^,\\s]+', caseSensitive: false),
          '$key=***REDACTED***',
        );
      }
    }
    return sanitized;
  }
}