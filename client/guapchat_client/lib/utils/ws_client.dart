import 'package:web_socket_channel/web_socket_channel.dart';

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

  /// Send a message to the WebSocket server
  void sendMessage(String message) {
    if (_channel.sink != null) {
      _channel.sink.add(message);
    } else {
      if (onError != null) {
        onError!("WebSocket sink is not available");
      }
    }
  }

  /// Close the WebSocket connection
  void close() {
    _channel.sink.close();
  }
}