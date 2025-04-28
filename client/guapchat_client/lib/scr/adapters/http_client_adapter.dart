import 'package:http/http.dart' as http;
import 'dart:io';

class HttpClientAdapter extends http.BaseClient {
  final HttpClient _httpClient;

  HttpClientAdapter(this._httpClient);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final req = await _httpClient.openUrl(request.method, request.url);
    request.headers.forEach((name, value) => req.headers.set(name, value));
    final response = await req.close();

    // Вручную собираем заголовки в Map<String, String>
    final headers = <String, String>{};
    response.headers.forEach((name, values) {
      headers[name] = values.join(', ');
    });

    return http.StreamedResponse(
      response,
      response.statusCode,
      headers: headers, // Используем подготовленные заголовки
    );
  }
}