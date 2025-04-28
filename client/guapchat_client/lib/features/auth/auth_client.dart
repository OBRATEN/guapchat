import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/storage.dart';
import '../../utils/error_handler.dart';


class AuthClient {
  final String _baseUrl;
  final http.Client _httpClient;
  final ErrorHandler _errorHandler;

  AuthClient({
    required String baseUrl,
    http.Client? httpClient,
    ErrorHandler? errorHandler,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client(),
        _errorHandler = errorHandler ?? ErrorHandler();

  /// Регистрация пользователя
  Future<void> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    BuildContext? context,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/register');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'username': username,
            'password': password,
            'firstname': firstName,
            'lastname': lastName,
          },
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Registration failed: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      await _saveTokens(data);
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Вход пользователя
  Future<void> login({
    required String username,
    required String password,
    BuildContext? context,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/login');
      final response = await _httpClient.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'username': username,
            'password': password,
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Login failed: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      await _saveTokens(data);
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Выход пользователя
  Future<void> logout({BuildContext? context}) async {
    try {
      final uri = Uri.parse('$_baseUrl/api/logout');
      await _httpClient.post(uri);
      await Storage.deleteAllTokens();
    } catch (e, stack) {
      _errorHandler.handleError(e, stackTrace: stack, context: context);
      rethrow;
    }
  }

  /// Сохранение токенов
  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw Exception('Invalid tokens in response');
    }

    await Storage.saveToken(accessToken);
    await Storage.saveRefreshToken(refreshToken);
  }
}