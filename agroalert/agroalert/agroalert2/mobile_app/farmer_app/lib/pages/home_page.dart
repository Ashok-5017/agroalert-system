import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import '../config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> weather = {};
  List alerts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final w = await ApiService.getWeather();
    final a = await ApiService.getAlerts();
    setState(() {
      weather = w;
      alerts = a;
      loading = false;
    });
  }

  Future<void> sendWhatsAppAlert() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );

      final uri =
          Uri.parse('${AppConfig.baseUrl}/alerts/send-sms')
              .replace(queryParameters: {
        'village': 'Manathampalayam',
      });

      final response = await http.post(uri);

      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ WhatsApp Alert அனுப்பப்பட்டது!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.green))
        : RefreshIndicator(
            onRefresh: loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  const Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.green, size: 20),
                      SizedBox(width: 4),
                      Text('Manathampalayam, Tamil Nadu',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Weather Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Colors.green, Colors.teal]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('இன்னைக்கு வானிலை',
                            style: TextStyle(
                                color: Colors.white70)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${weather['temperature'] ?? '--'}°C',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Icon(Icons.wb_sunny,
                                color: Colors.yellow, size: 60),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _weatherInfo(
                                Icons.water_drop,
                                'Humidity',
                                '${weather['humidity'] ?? '--'}%'),
                            _weatherInfo(
                                Icons.umbrella,
                                'Rain',
                                '${weather['rainfall'] ?? '--'}mm'),
                            _weatherInfo(
                                Icons.air,
                                'Wind',
                                '${weather['wind_speed'] ?? '--'}km/h'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Alert Banner
                  alerts.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning,
                                  color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '⚠️ ${alerts[0]['message'] ?? 'Alert இருக்கு!'}',
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight:
                                          FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius:
                                BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.green),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                  '✅ எல்லாம் சரியாக இருக்கு!',
                                  style: TextStyle(
                                      color: Colors.green)),
                            ],
                          ),
                        ),

                  const SizedBox(height: 16),

                  // Quick Actions
                  const Text('Quick Actions',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          Icons.agriculture,
                          'பயிர் ஆலோசனை',
                          Colors.green,
                          () => Navigator.pushNamed(
                              context, '/advisory'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          Icons.warning_amber,
                          'Alerts (${alerts.length})',
                          Colors.orange,
                          () => Navigator.pushNamed(
                              context, '/alerts'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _actionCard(
                          Icons.cloud,
                          '7 Day Forecast',
                          Colors.blue,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionCard(
                          Icons.store,
                          'Mandi Price',
                          Colors.purple,
                          () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // WhatsApp Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: sendWhatsAppAlert,
                      icon: const Icon(Icons.message,
                          color: Colors.white),
                      label: const Text(
                        '📱 WhatsApp Alert அனுப்பு',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF25D366),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary Card
                  Container(
                    width: double.infinity,
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
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📊 இன்றைய Summary',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _summaryRow('🌡️ Temperature',
                            '${weather['temperature'] ?? '--'}°C'),
                        _summaryRow('💧 Humidity',
                            '${weather['humidity'] ?? '--'}%'),
                        _summaryRow('🌧️ Rainfall',
                            '${weather['rainfall'] ?? '--'}mm'),
                        _summaryRow('💨 Wind',
                            '${weather['wind_speed'] ?? '--'}km/h'),
                        _summaryRow('⚠️ Alerts',
                            '${alerts.length} active'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
  }

  Widget _weatherInfo(
      IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, Color color,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}