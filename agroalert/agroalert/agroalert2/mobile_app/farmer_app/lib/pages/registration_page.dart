import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _cropController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _cropController.dispose();
    super.dispose();
  }

  Future<void> registerFarmer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final uri =
          Uri.parse('${AppConfig.baseUrl}/farmers/register')
              .replace(queryParameters: {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'village': _villageController.text,
        'crop_type': _cropController.text,
      });
      final response = await http.post(uri);
      setState(() => _loading = false);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ பதிவு வெற்றிகரமாக முடிந்தது!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        _nameController.clear();
        _phoneController.clear();
        _villageController.clear();
        _cropController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${response.body}'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.person_add,
                      color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'விவசாயி பதிவு',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'AgroAlert-ல் பதிவு பண்ணுங்க',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel('👤 பெயர்'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration(
                  'உங்கள் பெயர்', Icons.person),
              validator: (v) =>
                  v!.isEmpty ? 'பெயர் உள்ளிடுங்க' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('📱 Phone Number'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: _inputDecoration(
                  '10 digit number', Icons.phone),
              validator: (v) {
                if (v!.isEmpty) return 'Phone உள்ளிடுங்க';
                if (v.length != 10) return '10 digits வேணும்';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('🏘️ கிராமம்'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _villageController,
              decoration: _inputDecoration(
                  'உங்கள் கிராமம்', Icons.location_on),
              validator: (v) =>
                  v!.isEmpty ? 'கிராமம் உள்ளிடுங்க' : null,
            ),
            const SizedBox(height: 16),

            _buildLabel('🌾 பயிர் வகை'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _cropController,
              decoration: _inputDecoration(
                  'நெல், கரும்பு, வாழை...', Icons.grass),
              validator: (v) =>
                  v!.isEmpty ? 'பயிர் வகை உள்ளிடுங்க' : null,
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : registerFarmer,
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle,
                        color: Colors.white),
                label: Text(
                  _loading
                      ? 'பதிவு ஆகுது...'
                      : '✅ பதிவு பண்ணு',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _inputDecoration(
      String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: Colors.green, width: 2),
      ),
    );
  }
}