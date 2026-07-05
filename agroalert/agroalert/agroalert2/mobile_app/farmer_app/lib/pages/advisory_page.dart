import 'package:flutter/material.dart';

class AdvisoryPage extends StatefulWidget {
  const AdvisoryPage({super.key});

  @override
  State<AdvisoryPage> createState() => _AdvisoryPageState();
}

class _AdvisoryPageState extends State<AdvisoryPage> {
  String _selectedCategory = 'எல்லாம்';

  final List<Map<String, dynamic>> _tips = [
    {
      'category': 'பயிர்',
      'title': 'நெல் பயிர் பராமரிப்பு',
      'advice': 'அதிக மழையில் நீர் வடிகால் சரிபார்க்கவும். வரப்புகளை உயர்த்தி வெள்ள அபாயம் தவிர்க்கவும்.',
      'icon': '🌾',
      'color': Colors.green,
      'priority': 'high',
    },
    {
      'category': 'பூச்சி',
      'title': 'பூச்சி மேலாண்மை',
      'advice': 'வாரம் ஒருமுறை பயிரை சோதிக்கவும். இலை நுனி மஞ்சளாக இருந்தால் உடனே spray பண்ணவும்.',
      'icon': '🐛',
      'color': Colors.orange,
      'priority': 'medium',
    },
    {
      'category': 'உரம்',
      'title': 'உரம் இடுதல்',
      'advice': 'மழைக்கு முன் உரம் போடுவதை தவிர்க்கவும். மழை நின்ற பிறகு 2 நாள் கழித்து உரம் இடவும்.',
      'icon': '🌱',
      'color': Colors.brown,
      'priority': 'medium',
    },
    {
      'category': 'நீர்',
      'title': 'நீர் பாசனம்',
      'advice': 'மழை அதிகமாக இருப்பதால் பாசனம் தேவையில்லை. வயலில் தேங்கிய நீரை வெளியேற்றவும்.',
      'icon': '💧',
      'color': Colors.blue,
      'priority': 'high',
    },
    {
      'category': 'பயிர்',
      'title': 'கரும்பு பராமரிப்பு',
      'advice': 'கரும்பு வளர்ச்சிக்கு போதுமான சூரிய வெளிச்சம் தேவை. நிழல் தரும் மரங்களை அகற்றவும்.',
      'icon': '🎋',
      'color': Colors.green,
      'priority': 'low',
    },
    {
      'category': 'நோய்',
      'title': 'பயிர் நோய் தடுப்பு',
      'advice': 'அதிக ஈரப்பதத்தால் பூஞ்சை நோய் வரலாம். Copper oxychloride spray பண்ணவும்.',
      'icon': '🔬',
      'color': Colors.red,
      'priority': 'high',
    },
    {
      'category': 'உரம்',
      'title': 'இயற்கை உரம்',
      'advice': 'மண்புழு உரம் மற்றும் இயற்கை உரம் பயன்படுத்தி மண் வளத்தை அதிகரிக்கவும்.',
      'icon': '♻️',
      'color': Colors.teal,
      'priority': 'low',
    },
    {
      'category': 'நீர்',
      'title': 'மழை நீர் சேகரிப்பு',
      'advice': 'அதிக மழை நீரை தொட்டிகளில் சேகரித்து வறட்சி காலத்தில் பயன்படுத்தவும்.',
      'icon': '🪣',
      'color': Colors.indigo,
      'priority': 'medium',
    },
  ];

  final List<String> _categories = [
    'எல்லாம்', 'பயிர்', 'பூச்சி', 'உரம்', 'நீர்', 'நோய்'
  ];

  List<Map<String, dynamic>> get _filteredTips {
    if (_selectedCategory == 'எல்லாம்') return _tips;
    return _tips
        .where((t) => t['category'] == _selectedCategory)
        .toList();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      default: return Colors.green;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'high': return 'அவசரம்';
      case 'medium': return 'முக்கியம்';
      default: return 'சாதாரணம்';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                colors: [Colors.green, Colors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.agriculture,
                    color: Colors.white, size: 48),
                SizedBox(height: 8),
                Text(
                  'பயிர் ஆலோசனை',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'இன்றைய வானிலைக்கு ஏற்ற ஆலோசனைகள்',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Priority Summary
          Row(
            children: [
              _priorityCard('அவசரம்', Colors.red,
                  _tips.where((t) => t['priority'] == 'high').length),
              const SizedBox(width: 8),
              _priorityCard('முக்கியம்', Colors.orange,
                  _tips.where((t) => t['priority'] == 'medium').length),
              const SizedBox(width: 8),
              _priorityCard('சாதாரணம்', Colors.green,
                  _tips.where((t) => t['priority'] == 'low').length),
            ],
          ),
          const SizedBox(height: 16),

          // Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (val) =>
                        setState(() => _selectedCategory = cat),
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.green
                          : Colors.grey.shade700,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Tips List
          ..._filteredTips.map((tip) {
            final color = tip['color'] as Color;
            final priority = tip['priority'] as String;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: color.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          tip['icon'],
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tip['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: color,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(priority),
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getPriorityText(priority),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.tips_and_updates,
                            color: color, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tip['advice'],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _priorityCard(
      String label, Color color, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}