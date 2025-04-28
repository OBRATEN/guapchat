import 'package:flutter/material.dart';

class ErrorHandler {
  // Сиглтон-паттерн для глобального доступа
  static final ErrorHandler _instance = ErrorHandler._internal();
  factory ErrorHandler() => _instance;
  ErrorHandler._internal();

  /// Обработка ошибок и вывод сообщений
  void handleError(dynamic error, {StackTrace? stackTrace, BuildContext? context}) {
    // Логирование ошибки
    _logError(error, stackTrace);

    // Преобразование ошибки в сообщение для пользователя
    final message = _getUserFriendlyMessage(error);

    // Показ сообщения (если доступен контекст)
    if (context != null && message.isNotEmpty) {
      _showErrorSnackbar(context, message);
    }

    // Дополнительные действия (например, выход из системы при 401)
    _handleSpecialCases(error, context);
  }

  /// Логирование ошибки
  void _logError(dynamic error, StackTrace? stackTrace) {
    print('ERROR: ${error.toString()}');
    if (stackTrace != null) {
      print('STACKTRACE: $stackTrace');
    }
  }

  /// Преобразование ошибки в понятное сообщение
  String _getUserFriendlyMessage(dynamic error) {
    if (error is String) return error;

    // Обработка HTTP-ошибок
    if (error is NetworkError) {
      switch (error.statusCode) {
        case 401:
          return 'Сессия истекла. Войдите снова.';
        case 404:
          return 'Ресурс не найден';
        case 500:
          return 'Ошибка сервера';
        default:
          return 'Ошибка сети: ${error.statusCode}';
      }
    }

    // Ошибки WebSocket
    if (error is WebSocketError) {
      return 'Ошибка соединения с сервером';
    }

    return 'Неизвестная ошибка';
  }

  /// Показ сообщения в Snackbar
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Обработка специальных сценариев
  void _handleSpecialCases(dynamic error, BuildContext? context) {
    if (error is NetworkError && error.statusCode == 401) {
      // Перенаправление на экран авторизации
      if (context != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }
}

/// Кастомные классы ошибок
class NetworkError implements Exception {
  final int statusCode;
  final String message;

  NetworkError(this.statusCode, [this.message = '']);
}

class WebSocketError implements Exception {
  final String message;

  WebSocketError([this.message = '']);
}