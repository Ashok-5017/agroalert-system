import 'package:flutter/material.dart';

class MandiPage extends StatefulWidget {
  const MandiPage({super.key});

  @override
  State<MandiPage> createState() => _MandiPageState();
}

class _MandiPageState extends State<MandiPage> {
  String _selectedCrop = 'எல்லாம்';

  final List<Map<String, dynamic>> _mandiPrices = [
    {
      'crop': 'நெல்',
      'crop_en': 'Rice',
      'price': 2200,
      'unit': 'குவிண்டால்',
      'change': 50,
      'market': 'Erode',
      'icon': '🌾',
    },
    {
      'crop': 'கரும்பு',
      'crop_en': 'Sugarcane',
      'price': 3200,
      'unit': 'டன்',
      'change': -100,
      'market': 'Coimbatore',
      'icon': '🎋',
    },
    {
      'crop': 'வாழை',
      'crop_en': 'Banana',
      'price': 1500,
      'unit': 'குவிண்டால்',
      'change': 200,
      'market': 'Salem',
      'icon': '🍌',
    },
    {
      'crop': 'தக்காளி',
      'crop_en': 'Tomato',
      'price': 800,
      'unit': 'குவிண்டால்',
      'change': -50,
      'market': 'Hosur',
      'icon': '🍅',
    },
    {
      'crop': 'வெங்காயம்',
      'crop_en': 'Onion',
      'price': 1200,
      'unit': 'குவிண்டால்',
      'change': 100,
      'market': 'Namakkal',
      'icon': '🧅',
    },
    {
      'crop': 'மிளகாய்',
      'crop_en': 'Chilli',
      'price': 5500,
      'unit': 'குவிண்டால்',
      'change': 300,
      'market': 'Guntur',
      'icon': '🌶️',
    },
    {
      'crop': 'பருத்தி',
      'crop_en': 'Cotton',
      'price': 6200,
      'unit': 'குவிண்டால்',
      'change': -200,
      'market': 'Coimbatore',
      'icon': '🌿',
    },
    {
      'crop': 'சோளம்',
      'crop_en': 'Maize',
      'price': 1800,
      'unit': 'குவிண்டால்',
      'change': 80,
      'market': 'Erode',
      'icon': '🌽',
    },
  ];

  final List<String> _filters = [
    'எல்லாம்', 'நெல்', 'காய்கறி', 'பழம்', 'பணப்பயிர்'
  ];

  List<Map<String, dynamic>> get _filteredPrices {
    if (_selectedCrop == 'எல்லாம்') return _mandiPrices;
    if (_selectedCrop == 'காய்கறி') {
      return _mandiPrices.where((p) =>
        ['தக்காளி', 'வெங்காயம்', 'மிளகாய்']
            .contains(p['crop'])).toList();
    }
    if (_selectedCrop == 'பழம்') {
      return _mandiPrices.where((p) =>
        ['வாழை'].contains(p['crop'])).toList();
    }
    if (_selectedCrop == 'பணப்பயிர்') {
      return _mandiPrices.where((p) =>
        ['கரும்பு', 'பருத்தி'].contains(p['crop'])).toList();
    }
    return _mandiPrices.where((p) =>
        p['crop'] == _selectedCrop).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.store,
                    color: Colors.white, size: 48),
                const SizedBox(height: 8),
                const Text(
                  'மண்டி விலை',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'இன்றைய சந்தை விலை',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🕐 Updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedCrop == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCrop = filter);
                    },
                    selectedColor: Colors.purple.shade100,
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.purple
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

          ..._filteredPrices.map((item) {
            final change = item['change'] as int;
            final isUp = change > 0;
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
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        item['icon'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['crop'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '📍 ${item['market']} Market',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${item['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        '/${item['unit']}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUp
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isUp
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isUp
                                  ? Colors.green
                                  : Colors.red,
                              size: 12,
                            ),
                            Text(
                              '₹${change.abs()}',
                              style: TextStyle(
                                color: isUp
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.amber, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'விலைகள் தோராயமானவை. உண்மையான விலைக்கு உள்ளூர் சந்தையை தொடர்பு கொள்ளவும்.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}