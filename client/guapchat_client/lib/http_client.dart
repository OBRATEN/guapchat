import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpClient {
  // Базовый URL сервера
  final String baseUrl;

  HttpClient({required this.baseUrl});

  // Метод для отправки GET-запроса
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      // Обработка ошибок сети или других исключений
      print('GET запрос failed: $e');
      rethrow; // Переброс исключения для обработки в вызывающем коде
    }
  }

  // Метод для отправки POST-запроса
  Future<dynamic> post(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      print(body);
      print(headers);
      print(url);
      final response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null, // Преобразование тела запроса в JSON
      );

      return _handleResponse(response);
    } catch (e) {
      print('POST запрос failed: $e');
      rethrow;
    }
  }

  // Метод для отправки PUT-запроса
  Future<dynamic> put(String endpoint, {dynamic body, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.put(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null, // Преобразование тела запроса в JSON
      );

      return _handleResponse(response);
    } catch (e) {
      print('PUT запрос failed: $e');
      rethrow;
    }
  }

  // Метод для отправки DELETE-запроса
  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.delete(url, headers: headers);

      return _handleResponse(response);
    } catch (e) {
      print('DELETE запрос failed: $e');
      rethrow;
    }
  }


  // Вспомогательный метод для обработки ответа сервера
  dynamic _handleResponse(http.Response response) {
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        // Успешный запрос: декодируем JSON, если он есть
        if (response.body.isNotEmpty) {
          try {
            return jsonDecode(response.body);
          } catch (e) {
            // Если не удалось декодировать JSON, возвращаем тело как есть (например, строка)
            print('Ошибка декодирования JSON: $e');
            return response.body;
          }
        } else {
          // Если тело пустое, возвращаем null
          return null;
        }
      case 400:
        // Bad Request
        throw Exception('Bad Request: ${response.body}');
      case 401:
        // Unauthorized
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        // Forbidden
        throw Exception('Forbidden: ${response.body}');
      case 404:
        // Not Found
        throw Exception('Not Found: ${response.body}');
      case 500:
        // Internal Server Error
        throw Exception('Internal Server Error: ${response.body}');
      default:
        // Другие статусы (например, 500)
        throw Exception('Request failed with status: ${response.statusCode}. Body: ${response.body}');
    }
  }
}

// Пример использования
void main() async {
  // Замените на URL вашего сервера
  final httpClient = HttpClient(baseUrl: 'https://jsonplaceholder.typicode.com');

  try {
    // GET запрос
    final getResponse = await httpClient.get('posts/1');
    print('GET response: $getResponse');

    // POST запрос
    final postData = {
      'title': 'foo',
      'body': 'bar',
      'userId': 1,
    };
    final postResponse = await httpClient.post('posts', body: postData);
    print('POST response: $postResponse');

    // PUT запрос
    final putData = {
      'id': 1,
      'title': 'foo',
      'body': 'bar',
      'userId': 1,
    };
    final putResponse = await httpClient.put('posts/1', body: putData);
    print('PUT response: $putResponse');

    // DELETE запрос
    final deleteResponse = await httpClient.delete('posts/1');
    print('DELETE response: $deleteResponse'); //  DELETE запросы обычно не возвращают тело ответа

  } catch (e) {
    print('Error: $e');
  }
}