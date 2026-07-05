import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class ApiService {
  
  static const String village = 'Manathampalayam';
  static const double lat = 11.0168;
  static const double lng = 77.0025;

  static Future<Map<String, dynamic>> getWeather() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/weather/current')
          .replace(queryParameters: {
        'village': village,
        'lat': lat.toString(),
        'lng': lng.toString(),
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Weather Error: $e');
    }
    return {};
  }

  static Future<List> getAlerts() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/alerts/active')
          .replace(queryParameters: {
        'village': village,
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['alerts'] ?? [];
      }
    } catch (e) {
      print('Alerts Error: $e');
    }
    return [];
  }

  static Future<List> getFarmers() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/farmers/all'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['farmers'] ?? [];
      }
    } catch (e) {
      print('Farmers Error: $e');
    }
    return [];
  }
}