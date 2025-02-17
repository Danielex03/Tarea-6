import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'e08f54100c053b343d2a9b212f61a352';
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>> getWeather(String city) async {
    final response = await http.get(Uri.parse('$apiUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error fetching weather data');
    }
  }
}
