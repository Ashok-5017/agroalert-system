import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _cropController = TextEditingController();
  bool _loading = true;
  bool _editing = false;
  Map<String, dynamic> _profile = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _cropController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    try {
      // RouteArguments-லிருந்து phone எடுக்க
      await Future.delayed(Duration.zero);
      final args = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;
      final phone = args?['phone'] ?? '';

      if (phone.isEmpty) {
        setState(() => _loading = false);
        return;
      }

      final uri =
          Uri.parse('${AppConfig.baseUrl}/farmers/profile')
              .replace(queryParameters: {'phone': phone});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _profile = data;
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _villageController.text = data['village'] ?? '';
          _cropController.text = data['crop_type'] ?? 'நெல்';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> saveProfile() async {
    setState(() => _loading = true);
    try {
      final uri =
          Uri.parse('${AppConfig.baseUrl}/farmers/update')
              .replace(queryParameters: {
        'phone': _phoneController.text,
        'name': _nameController.text,
        'village': _villageController.text,
        'crop_type': _cropController.text,
      });

      final response = await http.put(uri);
      setState(() {
        _loading = false;
        _editing = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile update ஆச்சு!'),
            backgroundColor: Colors.green,
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          '👤 என் Profile',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _editing ? Icons.close : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () =>
                setState(() => _editing = !_editing),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Colors.green))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.3),
                            borderRadius:
                                BorderRadius.circular(45),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 52),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _profile['name'] ?? 'விவசாயி',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _profile['village'] ?? '',
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.2),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            '📱 ${_profile['phone'] ?? ''}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Edit Form
                  if (_editing) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                            '✏️ Profile Edit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Name
                          _buildField(
                            'பெயர்',
                            _nameController,
                            Icons.person,
                          ),
                          const SizedBox(height: 12),

                          // Village
                          _buildField(
                            'கிராமம்',
                            _villageController,
                            Icons.location_on,
                          ),
                          const SizedBox(height: 12),

                          // Crop
                          _buildField(
                            'பயிர் வகை',
                            _cropController,
                            Icons.grass,
                          ),
                          const SizedBox(height: 20),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: saveProfile,
                              icon: const Icon(Icons.save,
                                  color: Colors.white),
                              label: const Text(
                                '💾 Save பண்ணு',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // View Mode
                    _infoCard('👤 பெயர்',
                        _profile['name'] ?? '--'),
                    _infoCard('📱 Phone',
                        _profile['phone'] ?? '--'),
                    _infoCard('🏘️ கிராமம்',
                        _profile['village'] ?? '--'),
                    _infoCard('🌾 பயிர் வகை',
                        _profile['crop_type'] ?? 'நெல்'),

                    const SizedBox(height: 24),

                    // Edit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            setState(() => _editing = true),
                        icon: const Icon(Icons.edit,
                            color: Colors.white),
                        label: const Text(
                          '✏️ Profile Edit பண்ணு',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                  'வெளியேற விரும்புகிறீர்களா?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context),
                                  child:
                                      const Text('இல்லை'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator
                                        .pushReplacementNamed(
                                            context, '/login');
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red,
                                  ),
                                  child: const Text(
                                    'ஆம்',
                                    style: TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout,
                            color: Colors.red),
                        label: const Text(
                          'வெளியேறு',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Colors.green, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(String label, String value) {
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
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}