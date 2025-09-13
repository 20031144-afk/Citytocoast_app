import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl =
      "http://10.0.2.2:8000"; // Android Emulator → host machine

  Future<List<Map<String, dynamic>>> fetchReviews() async {
    final res = await http.get(Uri.parse("$baseUrl/reviews"));
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } else {
      throw Exception("Failed to load reviews: ${res.statusCode}");
    }
  }
}
