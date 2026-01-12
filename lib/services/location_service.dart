import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  // Nominatim requires a User-Agent identifying the application
  final String _userAgent = 'citytocoast_app';

  Future<List<dynamic>> getPlaceSuggestions(String input) async {
    if (input.isEmpty) return [];

    final String request =
        'https://nominatim.openstreetmap.org/search?q=$input&format=json&addressdetails=1&limit=5';

    try {
      final response = await http.get(
        Uri.parse(request),
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = json.decode(response.body);
        return result;
      } else {
        throw Exception('Failed to fetch suggestions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return [];
    }
  }
}
