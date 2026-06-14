import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'weather_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final TextEditingController _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _savedItineraries = [];
  String _selectedMood = '';

  final List<Map<String, dynamic>> moodDestinations = [
    {
      'mood': 'Beach',
      'icon': Icons.beach_access,
      'cities': ['Goa', 'Maldives', 'Bali', 'Miami', 'Phuket']
    },
    {
      'mood': 'Snow',
      'icon': Icons.ac_unit,
      'cities': ['Manali', 'Shimla', 'Switzerland', 'Iceland', 'Aspen']
    },
    {
      'mood': 'Culture',
      'icon': Icons.account_balance,
      'cities': ['Paris', 'Rome', 'Kyoto', 'Istanbul', 'Jaipur']
    },
    {
      'mood': 'Adventure',
      'icon': Icons.terrain,
      'cities': ['Rishikesh', 'New Zealand', 'Nepal', 'Patagonia', 'Costa Rica']
    },
    {
      'mood': 'City',
      'icon': Icons.location_city,
      'cities': ['Dubai', 'Tokyo', 'New York', 'Singapore', 'London']
    },
    {
      'mood': 'Nature',
      'icon': Icons.forest,
      'cities': ['Kerala', 'Amazon', 'Banff', 'Patagonia', 'Coorg']
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadItineraries();
  }

  Future<void> _loadItineraries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('itineraries') ?? '[]';
    setState(() {
      _savedItineraries = List<Map<String, dynamic>>.from(json.decode(data));
    });
  }

  Future<void> _saveItinerary() async {
    if (_destinationController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
      return;
    }
    final trip = {
      'destination': _destinationController.text,
      'startDate': _startDate!.toIso8601String(),
      'endDate': _endDate!.toIso8601String(),
      'days': _endDate!.difference(_startDate!).inDays + 1,
    };
    _savedItineraries.add(trip);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('itineraries', json.encode(_savedItineraries));
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Itinerary saved!')),
    );
    _destinationController.clear();
    _startDate = null;
    _endDate = null;
  }

  Future<void> _deleteItinerary(int index) async {
    _savedItineraries.removeAt(index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('itineraries', json.encode(_savedItineraries));
    setState(() {});
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              'https://images.unsplash.com/photo-1488085061387-422e29b40080?w=1200&q=80',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: const Color(0xFF1E88E5)),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Plan Your Trip',
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text('Choose destination and dates',
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 30),

                  // Mood Selector
                  const Text('TRAVEL MOOD',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 2)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: moodDestinations.length,
                      itemBuilder: (context, index) {
                        final mood = moodDestinations[index];
                        final isSelected = _selectedMood == mood['mood'];
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedMood = mood['mood']);
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? Colors.white : Colors.white30,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(mood['icon'] as IconData, color: Colors.white, size: 24),
                                const SizedBox(height: 6),
                                Text(mood['mood'],
                                    style: const TextStyle(color: Colors.white, fontSize: 11)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Suggested Cities
                  if (_selectedMood.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('SUGGESTED CITIES',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 2)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (moodDestinations
                              .firstWhere((m) => m['mood'] == _selectedMood)['cities'] as List<String>)
                          .map((city) => GestureDetector(
                                onTap: () {
                                  _destinationController.text = city;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white30),
                                  ),
                                  child: Text(city,
                                      style: const TextStyle(color: Colors.white, fontSize: 13)),
                                ),
                              ))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Destination Input
                  const Text('DESTINATION',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: TextField(
                      controller: _destinationController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Enter destination city...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white70),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date Pickers
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(true),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DEPARTURE',
                                    style: TextStyle(fontSize: 10, color: Colors.white60, letterSpacing: 1)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                    const SizedBox(width: 6),
                                    Text(_formatDate(_startDate),
                                        style: const TextStyle(color: Colors.white, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(false),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('RETURN',
                                    style: TextStyle(fontSize: 10, color: Colors.white60, letterSpacing: 1)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                    const SizedBox(width: 6),
                                    Text(_formatDate(_endDate),
                                        style: const TextStyle(color: Colors.white, fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _saveItinerary,
                      icon: const Icon(Icons.add_location_alt_outlined),
                      label: const Text('Save Itinerary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Saved Itineraries
                  if (_savedItineraries.isNotEmpty) ...[
                    const Text('YOUR ITINERARIES',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white60, letterSpacing: 2)),
                    const SizedBox(height: 12),
                    ..._savedItineraries.asMap().entries.map((entry) {
                      final i = entry.key;
                      final trip = entry.value;
                      final start = DateTime.parse(trip['startDate']);
                      final end = DateTime.parse(trip['endDate']);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flight_takeoff, color: Colors.white70),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                        trip['destination'].toString().split(' ').map((word) =>
                                            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : word
                                        ).join(' '),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(
                                    '${_formatDate(start)} → ${_formatDate(end)}  •  ${trip['days']} days',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WeatherScreen(cityName: trip['destination']),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.cloud_outlined, color: Colors.white, size: 18),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _deleteItinerary(i),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.delete_outline, color: Colors.white70, size: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}