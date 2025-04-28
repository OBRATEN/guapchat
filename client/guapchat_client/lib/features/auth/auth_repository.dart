import 'package:flutter/material.dart';
import 'auth_client.dart';
import '../../utils/storage.dart';
import '../../utils/error_handler.dart';

class AuthRepository {
  final AuthClient _authClient;
  final ErrorHandler _errorHandler;

  AuthRepository({
    required AuthClient authClient,
    ErrorHandler? errorHandler,
  })  : _authClient = authClient,
        _errorHandler = errorHandler ?? ErrorHandler();

  /// Регистрация пользователя
  Future<bool> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    BuildContext? context,
  }) async {
    try {
      await _authClient.register(
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
        context: context,
      );
      return true;
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      return false;
    }
  }

  /// Вход пользователя
  Future<bool> login({
    required String username,
    required String password,
    BuildContext? context,
  }) async {
    try {
      await _authClient.login(
        username: username,
        password: password,
        context: context,
      );
      return true;
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      return false;
    }
  }

  /// Выход пользователя
  Future<bool> logout({BuildContext? context}) async {
    try {
      await _authClient.logout(context: context);
      return true;
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      return false;
    }
  }

  /// Проверка аутентификации
  Future<bool> isAuthenticated() async {
    final token = await Storage.getToken();
    return token != null && token.isNotEmpty;
  }
}