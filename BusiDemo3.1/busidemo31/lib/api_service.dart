import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<dynamic>> fetchNews() async {
    final response = await http.get(Uri.parse('$baseUrl/api/cnn-news/nasional'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Ambil array 'data' dari respons JSON
    } else {
      throw Exception('Failed to load news');
    }
  }
}

