import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CustomHttpClient {
  // Базовый URL сервера
  final String baseUrl;
  final Duration timeout;

  CustomHttpClient({required this.baseUrl, this.timeout = const Duration(seconds: 10)});

  // Метод для отправки GET-запроса
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final mergedHeaders = {...?headers};

      print('''
        Sending GET to: ${url.toString()}
        Headers: ${mergedHeaders.toString()}
      ''');

      final response = await http.get(url, headers: mergedHeaders).timeout(
        timeout,
        onTimeout: () => throw TimeoutException('GET request time out'),
      );
    return _handleResponse(response);
    }

  on TimeoutException catch (e) {
    print('Timeout: ${e.message}');
    rethrow;
    }
  on http.ClientException catch (e) {
    print('Network error: ${e.message}');
    rethrow;
    }
  catch (e) {
    print('Unexpected error: ${e.toString()}');
    rethrow;
    }
  }

  // Метод для отправки POST-запроса
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final defaultHeaders = {
        ...headers ?? {},
        'Content-Type': 'application/json',
      };

      print('''
      Sending POST to: ${url.toString()}
      Headers: ${defaultHeaders.toString()}
      Body: ${body?.toString() ?? "Empty"}
      ''');

    String? encodeBody;
    if (body != null) {
      try {
        encodeBody = jsonEncode(body);
      }
      catch (e){
        throw FormatException("Failed to endcode request bode: ${e.toString()}");
      }
    }

    final response = await http.post(
      url,
      headers: defaultHeaders,
      body: encodeBody,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException('POST request timed out'),
    );

    return _handleResponse(response);
    }

  on FormatException catch (e) {
    print('JSON endcoding error: ${e.message}');
    rethrow;
    }

  on TimeoutException catch (e) {
    print('Request timeout: ${e.message}');
    rethrow;
    }

  on http.ClientException catch (e){
    print('Network error: ${e.message}');
    rethrow;
    }

  catch(e) {
    print('Unexpected error: ${e.toString()}');
    rethrow;
    }
  }

  // Метод для отправки PUT-запроса
  Future<dynamic> put(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final defaultHeaders = {
        ...?headers,
        'Content-Type': 'application/json',
      };
    print('''
    Sending PUT to: ${url.toString()}
    Headers: ${defaultHeaders.toString()}
    Body: ${body?.toString() ?? "Empty"}
    ''');

    String? endcodeBody;
    if (body != null) {
      try {
        endcodeBody = jsonEncode(body);
      } catch (e) {
        throw FormatException("PUT body endcoding failed: ${e.toString()}");
      }
    }

    final response = await http.put(url, headers: defaultHeaders, body: endcodeBody).timeout(
      timeout, onTimeout: () => throw TimeoutException('PUT request timed out'),

    );
    return _handleResponse(response);
    }
  on FormatException catch (e) {
    print('JSON endcoding error: ${e.message}');
    rethrow;
    }

  on TimeoutException catch (e) {
    print('Request timeout: ${e.message}');
    rethrow;
    }

  catch(e) {
    print('Unexpected error: ${e.toString()}');
    rethrow;
    }
  }

  // Метод для отправки DELETE-запроса
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final mergedHeaders = {...?headers};

    print('''
    Sending DELETE to: ${url.toString()}
    Headers: ${mergedHeaders.toString()}
    ''');

    final response = await http.delete(url, headers: mergedHeaders).timeout(
      timeout, onTimeout: () => throw TimeoutException('DELETE request timed out'),

    );
    return _handleResponse(response);
    }

  on TimeoutException catch (e) {
    print('Request timeout: ${e.message}');
    rethrow;
    }

  on http.ClientException catch (e){
    print('Network error: ${e.message}');
    rethrow;
    }

  catch(e) {
    print('Unexpected error: ${e.toString()}');
    rethrow;
    }
  }


  // Вспомогательный метод для обработки ответа сервера
  dynamic _handleResponse(http.Response response) {
    print('''
    Responde received:
    URL: ${response.request?.url ?? 'Unknown'}
    Status: ${response.statusCode}
    Body: ${response.body.length > 200 ? '${response.body.substring(0, 200)}...': response.body}
    ''');

    if (response.body.isEmpty) return null;

    try {
      return jsonDecode(response.body);
    }
    catch (e) {
      print('Response is not JSON. Returing rae body.');
      return response.body;
    }
  }

  Future<dynamic> postFormData(
  String endpoint, {
  required Map<String, String> fields,
  List<http.MultipartFile>? files,
  Map<String, String>? headers,
}) async {
  try {
    final url = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('POST', url);

    // 1. Очистка заголовков от Content-Type
    final cleanedHeaders = Map<String, String>.from(headers ?? {})
      ..remove('Content-Type');

    // 2. Добавление полей и файлов
    request.fields.addAll(fields);
    if (files != null) {
      if (files.isEmpty) {
        throw ArgumentError('Files list must not be empty when provided');
      }
      request.files.addAll(files);
    }

    // 3. Добавление заголовков
    request.headers.addAll(cleanedHeaders);

    // 4. Детальное логирование
    print('''
    FormData Request:
    URL: ${url.toString()}
    Fields: ${fields.toString()}
    Files: ${files?.map((f) => f.filename).join(', ') ?? 'None'}
    Headers: ${cleanedHeaders}
    ''');

    // 5. Отправка с таймаутом
    final responseStream = await request.send()
      .timeout(
        timeout,
        onTimeout: () => throw TimeoutException('FormData timeout after $timeout'),
      );

    // 6. Конвертация ответа
    final response = await http.Response.fromStream(responseStream);
    return _handleResponse(response);
  } 
  on TimeoutException catch (e) {
    print('FormData Timeout: ${e.message}');
    rethrow;
  }
  on ArgumentError catch (e) {
    print('Invalid argument: ${e.message}');
    rethrow;
  }
  on http.ClientException catch (e) {
    print('Network error: ${e.message}');
    rethrow;
  }
  catch (e) {
    print('Unexpected error: ${e.toString()}');
    rethrow;
  }
}
  
}