import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  bool _loading = false;
  bool _showRegister = false;

  // Register controllers
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _cropController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _villageController.dispose();
    _cropController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('10 digit phone number உள்ளிடுங்க!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final uri =
          Uri.parse('${AppConfig.baseUrl}/farmers/login')
              .replace(queryParameters: {
        'phone': _phoneController.text,
      });

      final response = await http.post(uri);
      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Login success - MainScreen-க்கு போ
        Navigator.pushReplacementNamed(
            context, '/home',
            arguments: data);
      } else {
        // Not registered - Register page காட்டு
        setState(() => _showRegister = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '⚠️ பதிவு இல்லை! கீழே register பண்ணுங்க'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> register() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _villageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('எல்லா details-உம் உள்ளிடுங்க!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final uri =
          Uri.parse('${AppConfig.baseUrl}/farmers/register')
              .replace(queryParameters: {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'village': _villageController.text,
        'crop_type': _cropController.text.isEmpty
            ? 'நெல்'
            : _cropController.text,
      });

      final response = await http.post(uri);
      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ பதிவு முடிந்தது! Login ஆகுது...'),
            backgroundColor: Colors.green,
          ),
        );
        // Auto login
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacementNamed(
            context, '/home',
            arguments: data);
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '❌ ${error['detail'] ?? 'Error occurred'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                  20, 60, 20, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: const Column(
                children: [
                  Text('🌾', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 12),
                  Text(
                    'AgroAlert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'விவசாயிகளுக்கான Smart App',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Login Section
                  const Text(
                    '📱 உங்கள் Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '10 digit number',
                      prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.green),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : login,
                      icon: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.login,
                              color: Colors.white),
                      label: Text(
                        _loading
                            ? 'Login ஆகுது...'
                            : '🔑 Login',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // Register Section
                  if (_showRegister) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📝 புதிய பதிவு',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Name
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'உங்கள் பெயர்',
                              prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.green),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Village
                          TextFormField(
                            controller: _villageController,
                            decoration: InputDecoration(
                              hintText: 'கிராமம்',
                              prefixIcon: const Icon(
                                  Icons.location_on,
                                  color: Colors.green),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Crop
                          TextFormField(
                            controller: _cropController,
                            decoration: InputDecoration(
                              hintText:
                                  'பயிர் வகை (நெல், கரும்பு...)',
                              prefixIcon: const Icon(
                                  Icons.grass,
                                  color: Colors.green),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Register Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _loading ? null : register,
                              icon: const Icon(
                                  Icons.person_add,
                                  color: Colors.white),
                              label: const Text(
                                '✅ பதிவு பண்ணு',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange,
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'உங்கள் phone number-ஐ உள்ளிட்டு login பண்ணுங்க. புதியவர்கள் register பண்ணலாம்.',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}