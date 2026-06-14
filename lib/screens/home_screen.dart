import 'package:flutter/material.dart';
import 'dart:async';
import 'weather_screen.dart';
import 'saved_trips_screen.dart';
import 'trip_planner_screen.dart';
import 'weather_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Timer _timer;
  String _currentTime = '';
  String _currentDate = '';

  final List<Map<String, dynamic>> popularCities = [
    {'name': 'Mumbai', 'icon': Icons.waves},
    {'name': 'Delhi', 'icon': Icons.account_balance},
    {'name': 'London', 'icon': Icons.castle},
    {'name': 'Paris', 'icon': Icons.location_city},
    {'name': 'Tokyo', 'icon': Icons.temple_buddhist},
    {'name': 'Dubai', 'icon': Icons.business},
  ];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _currentDate = _getFormattedDate(now);
    });
  }

  String _getFormattedDate(DateTime now) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  void _searchCity(String cityName) {
    if (cityName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherScreen(cityName: cityName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.network(
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&q=80',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1B5E20), Color(0xFF76FF03)],
                    ),
                  ),
                );
              },
            ),
          ),

          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentTime,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            _currentDate,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.travel_explore, size: 30, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Hero Title
                  const Text(
                    'Explore The\nWorld\'s Weather',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Plan smarter trips with real-time weather',
                    style: TextStyle(fontSize: 15, color: Colors.white70, letterSpacing: 0.5),
                  ),

                  const SizedBox(height: 40),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Search any city...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                        suffixIcon: GestureDetector(
                          onTap: () => _searchCity(_searchController.text),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.arrow_forward, color: Colors.black87),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      ),
                      onSubmitted: _searchCity,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () => _searchCity(_searchController.text),
                      icon: const Icon(Icons.cloud_outlined, size: 18),
                      label: const Text('Search Weather',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Saved Trips Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SavedTripsScreen()),
                        );
                      },
                      icon: const Icon(Icons.bookmark_outline, size: 18),
                      label: const Text('Saved Trips', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Plan a Trip Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TripPlannerScreen()),
                        );
                      },
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Plan a Trip', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Weather Maps Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeatherMapScreen()),
                        );
                      },
                      icon: const Icon(Icons.public, size: 18),
                      label: const Text('Weather Maps', style: TextStyle(fontSize: 18)),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Popular Destinations
                  const Text(
                    'POPULAR DESTINATIONS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: popularCities.map((city) {
                      return GestureDetector(
                        onTap: () => _searchCity(city['name']),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(city['icon'] as IconData, color: Colors.white70, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                city['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Bottom Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.wb_sunny_outlined, color: Colors.white70, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Real-time weather data for smarter travel planning',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}