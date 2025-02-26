import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService._privateConstructor(this.baseUrl);

  static HttpService? _instance;

  factory HttpService({required String baseUrl}) {
    _instance ??= HttpService._privateConstructor(baseUrl);
    return _instance!;
  }

  Future<dynamic> get(
    String endpoint,
  ) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en la solicitud GET: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud GET: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error en la solicitud POST: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud POST: $e');
    }
  }
}
