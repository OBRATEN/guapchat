import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../utils/storage.dart';
import '../../utils/error_handler.dart';
import '../../core/http_client.dart';
import '../../core/ws_client.dart';

class ChatClient {
  final String _baseUrl;
  final CustomHttpClient _httpClient;
  final ErrorHandler _errorHandler;
  WebSocketClient? _wsClient;

  ChatClient({
    required String baseUrl,
    required CustomHttpClient httpClient,
    ErrorHandler? errorHandler,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient,
        _errorHandler = errorHandler ?? ErrorHandler();

  /// Получить список диалогов
  Future<List<Map<String, dynamic>>> getDialogs() async {
    try {
      final response = await _httpClient.get(
        '/dialogs',
        headers: await _getAuthHeaders(),
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack);
      rethrow;
    }
  }
  Stream get messageStream {
    if (_wsClient == null) {
      return Stream.empty();
    }
      return _wsClient!.stream;
      }

  /// Получить историю сообщений
  Future<List<Message>> getMessages(String dialogId) async {
    try {
      final response = await _httpClient.get(
        '/dialogs/$dialogId/messages',
        headers: await _getAuthHeaders(),
      );
      return response.map<Message>((msg) => Message.fromJson(msg)).toList();
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack);
      rethrow;
    }
  }

  /// Подключиться к WebSocket для чата
void connectToChat() {
  try {
    final token = Storage.getToken();
    final wsUrl = '$_baseUrl/chat?token=$token'.replaceFirst('http', 'ws');
    _wsClient = WebSocketClient(wsUrl); // ✅ Без 'url:'
    _wsClient!.connect();
  } catch (e, stack) {
    _errorHandler.handleError(e, stackTrace: stack);
  }
}
  /// Отправить сообщение через WebSocket
  void sendMessage(String text, String dialogId) {
    if (_wsClient == null) {
      _errorHandler.handleError('WebSocket не подключен');
      return;
    }

    try {
      _wsClient!.send({
        'type': 'message',
        'dialog_id': dialogId,
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack);
    }
  }

  /// Закрыть соединение
  void disconnect() {
    _wsClient?.disconnect();
  }

  /// Получить заголовки с токеном
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await Storage.getToken();
    return {'Authorization': 'Bearer $token'};
  }
}

/// Модель сообщения
class Message {
  final String id;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
    
  }
}