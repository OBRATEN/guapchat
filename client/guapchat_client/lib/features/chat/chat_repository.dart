import 'package:flutter/material.dart';
import 'chat_client.dart';
import '../../utils/storage.dart';
import '../../utils/error_handler.dart';

class ChatRepository {
  final ChatClient _chatClient;
  final ErrorHandler _errorHandler;

  ChatRepository({
    required ChatClient chatClient,
    ErrorHandler? errorHandler,
  })  : _chatClient = chatClient,
        _errorHandler = errorHandler ?? ErrorHandler();

  /// Получить список диалогов
  Future<List<Map<String, dynamic>>> getDialogs({BuildContext? context}) async {
    try {
      return await _chatClient.getDialogs();
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Получить историю сообщений
  Future<List<Message>> getMessages(String dialogId, {BuildContext? context}) async {
    try {
      return await _chatClient.getMessages(dialogId);
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Отправить сообщение
  Future<void> sendMessage({
    required String text,
    required String dialogId,
    BuildContext? context,
  }) async {
    try {
      _chatClient.sendMessage(text, dialogId);
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Подключиться к чату через WebSocket
  void connectToChat() {
    try {
      _chatClient.connectToChat();
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack);
    }
  }

  /// Отключиться от чата
  void disconnect() {
    _chatClient.disconnect();
  }

  /// Поток входящих сообщений (опционально)
  Stream<Message> get messageStream {
    return _chatClient.messageStream.map((data) => Message.fromJson(data));
  }
}