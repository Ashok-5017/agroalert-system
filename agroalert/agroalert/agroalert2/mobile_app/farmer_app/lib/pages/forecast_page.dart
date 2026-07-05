import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({super.key});

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  List forecastData = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}/weather/forecast7')
          .replace(queryParameters: {
        'lat': '11.0168',
        'lng': '77.0025',
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final forecasts = data['forecasts'] as List;
        final days = [
          'இன்று', 'நாளை', 'மறுநாள்',
          'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு'
        ];
        setState(() {
          forecastData = forecasts.asMap().entries.map((entry) {
            final i = entry.key;
            final f = entry.value;
            final rainfall = (f['rainfall_mm'] as num).toDouble();
            final humidity = (f['humidity'] as num).toDouble();
            return {
              'day': i < days.length ? days[i] : 'Day ${i + 1}',
              'date': _getDate(i),
              'temp': f['temperature'],
              'humidity': humidity,
              'rainfall': rainfall,
              'icon': _getWeatherIcon(rainfall, humidity),
              'condition': _getCondition(rainfall, humidity),
            };
          }).toList();
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        forecastData = List.generate(
            7, (i) => _dayData(_getDayName(i), i, 32, 60, 0));
        loading = false;
      });
    }
  }

  Map<String, dynamic> _dayData(String day, int offset,
      double temp, double humidity, double rainfall) {
    return {
      'day': day,
      'date': _getDate(offset),
      'temp': temp,
      'humidity': humidity,
      'rainfall': rainfall,
      'icon': _getWeatherIcon(rainfall, humidity),
      'condition': _getCondition(rainfall, humidity),
    };
  }

  String _getDate(int offset) {
    final date = DateTime.now().add(Duration(days: offset));
    return '${date.day}/${date.month}';
  }

  String _getDayName(int index) {
    const days = [
      'இன்று', 'நாளை', 'மறுநாள்',
      'வியாழன்', 'வெள்ளி', 'சனி', 'ஞாயிறு'
    ];
    return days[index % 7];
  }

  IconData _getWeatherIcon(double rainfall, double humidity) {
    if (rainfall > 50) return Icons.thunderstorm;
    if (rainfall > 20) return Icons.grain;
    if (rainfall > 5) return Icons.cloud;
    if (humidity > 80) return Icons.wb_cloudy;
    return Icons.wb_sunny;
  }

  Color _getWeatherColor(double rainfall, double humidity) {
    if (rainfall > 50) return Colors.indigo;
    if (rainfall > 20) return Colors.blue;
    if (rainfall > 5) return Colors.blueGrey;
    if (humidity > 80) return Colors.grey;
    return Colors.orange;
  }

  String _getCondition(double rainfall, double humidity) {
    if (rainfall > 50) return 'கனமழை';
    if (rainfall > 20) return 'மழை';
    if (rainfall > 5) return 'சாரல்';
    if (humidity > 80) return 'மேகமூட்டம்';
    return 'தெளிவான வானம்';
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.green))
        : RefreshIndicator(
            onRefresh: loadForecast,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.teal],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.cloud, color: Colors.white, size: 48),
                        SizedBox(height: 8),
                        Text(
                          '7 நாள் வானிலை',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Manathampalayam, Tamil Nadu',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 7 Day List
                  ...forecastData.map((day) {
                    final color = _getWeatherColor(
                      (day['rainfall'] as num).toDouble(),
                      (day['humidity'] as num).toDouble(),
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Day & Date
                          SizedBox(
                            width: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day['day'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  day['date'],
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Weather Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              day['icon'] as IconData,
                              color: color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Condition
                          Expanded(
                            child: Text(
                              day['condition'],
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Stats
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${day['temp']}°C',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '💧${day['humidity']}%',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                              if ((day['rainfall'] as num) > 0)
                                Text(
                                  '🌧️${day['rainfall']}mm',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Legend
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _LegendItem(
                            icon: Icons.wb_sunny,
                            color: Colors.orange,
                            label: 'தெளிவு'),
                        _LegendItem(
                            icon: Icons.grain,
                            color: Colors.blue,
                            label: 'மழை'),
                        _LegendItem(
                            icon: Icons.thunderstorm,
                            color: Colors.indigo,
                            label: 'கனமழை'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}