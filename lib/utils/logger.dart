import 'package:flutter/foundation.dart';

/// Logger terstruktur dengan level `debug`, `info`, `warning`, dan `error`.
///
/// Log hanya dicetak saat aplikasi berjalan dalam mode debug ([kDebugMode]);
/// pada mode release method ini tidak melakukan apa pun.
///
/// Jangan meneruskan data sensitif (token, PIN, API key, password) ke
/// logger — cukup pesan status, mis. "Token ditemukan".
class Logger {
  /// Mencetak log level debug.
  static void debug(String message) => _log('DEBUG', message);

  /// Mencetak log level info.
  static void info(String message) => _log('INFO', message);

  /// Mencetak log level warning.
  static void warning(String message) => _log('WARNING', message);

  /// Mencetak log level error.
  static void error(String message) => _log('ERROR', message);

  static void _log(String level, String message) {
    if (!kDebugMode) return;
    debugPrint('[$level] $message');
  }
}
