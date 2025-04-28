import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketClient {
  late final WebSocketChannel _channel;
  final String _url;

  // Callbacks for handling events
  Function(String)? onMessageReceived;
  Function(dynamic)? onError;
  Function()? onConnectionClosed; // Replace VoidCallback with Function()

  WebSocketClient(this._url);

  /// Connect to the WebSocket server
  void connect() {
    try {
      print(_url);
      _channel = WebSocketChannel.connect(Uri.parse(_url));

      _channel.stream.listen(
        (message) {
          if (onMessageReceived != null) {
            onMessageReceived!(message.toString());
          }
        },
        onError: (error) {
          if (onError != null) {
            onError!(error);
          }
        },
        onDone: () {
          if (onConnectionClosed != null) {
            onConnectionClosed!(); // Call the function directly
          }
        },
      );
    } catch (e) {
      if (onError != null) {
        onError!(e);
      }
    }
  }

/// Геттер для потока данных
  Stream get stream => _channel.stream;
  
/// Отправка сообщения
  void send(dynamic data) {
    if (_channel.sink != null) {
      _channel.sink.add(jsonEncode(data)); // Преобразование в JSON-строку
    }
  }

  /// Закрытие соединения
  void disconnect() {
    _channel.sink.close();
  }
}