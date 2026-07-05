import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _whatsappAlert = true;
  bool _weatherAlert = true;
  bool _pestAlert = true;
  bool _floodAlert = true;
  String _language = 'தமிழ்';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.teal],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(Icons.person,
                      color: Colors.white, size: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  'விவசாயி',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Manathampalayam, Tamil Nadu',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🌾 நெல், கரும்பு பயிரிடுகிறேன்',
                    style: TextStyle(
                        color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Profile Info
          _sectionTitle('👤 தனிப்பட்ட தகவல்'),
          const SizedBox(height: 8),
          _infoTile(Icons.person, 'பெயர்', 'விவசாயி'),
          _infoTile(Icons.phone, 'Phone', '+91 XXXXXXXXXX'),
          _infoTile(Icons.location_on, 'கிராமம்',
              'Manathampalayam'),
          _infoTile(Icons.grass, 'பயிர் வகை',
              'நெல், கரும்பு'),
          const SizedBox(height: 20),

          // Notification Settings
          _sectionTitle('🔔 Alert அமைப்புகள்'),
          const SizedBox(height: 8),
          _switchTile(
            Icons.message,
            'WhatsApp Alert',
            'WhatsApp-ல் alert அனுப்பு',
            _whatsappAlert,
            Colors.green,
            (val) => setState(() => _whatsappAlert = val),
          ),
          _switchTile(
            Icons.cloud,
            'வானிலை Alert',
            'கடுமையான வானிலை எச்சரிக்கை',
            _weatherAlert,
            Colors.blue,
            (val) => setState(() => _weatherAlert = val),
          ),
          _switchTile(
            Icons.bug_report,
            'பூச்சி Alert',
            'பூச்சி தாக்குதல் எச்சரிக்கை',
            _pestAlert,
            Colors.orange,
            (val) => setState(() => _pestAlert = val),
          ),
          _switchTile(
            Icons.water,
            'வெள்ள Alert',
            'வெள்ள அபாய எச்சரிக்கை',
            _floodAlert,
            Colors.red,
            (val) => setState(() => _floodAlert = val),
          ),
          const SizedBox(height: 20),

          // Language Settings
          _sectionTitle('🌐 மொழி அமைப்பு'),
          const SizedBox(height: 8),
          Container(
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
                const Icon(Icons.language,
                    color: Colors.green),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('மொழி தேர்வு',
                      style: TextStyle(
                          fontWeight: FontWeight.w500)),
                ),
                DropdownButton<String>(
                  value: _language,
                  underline: const SizedBox(),
                  items: ['தமிழ்', 'English', 'हिंदी']
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _language = val!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // App Info
          _sectionTitle('ℹ️ App பற்றி'),
          const SizedBox(height: 8),
          _infoTile(Icons.info, 'Version', '1.0.0'),
          _infoTile(Icons.code, 'Developer',
              'AgroAlert Team'),
          _infoTile(Icons.email, 'Support',
              'support@agroalert.in'),
          const SizedBox(height: 20),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
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
                        child: const Text('இல்லை'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
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
                  color: Colors.white),
              label: const Text(
                'வெளியேறு',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
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
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _infoTile(
      IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
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
          Icon(icon, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.grey)),
          ),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Color color,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }
}