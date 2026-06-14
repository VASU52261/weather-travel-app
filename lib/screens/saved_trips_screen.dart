import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_screen.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> {
  List<String> savedTrips = [];

  @override
  void initState() {
    super.initState();
    loadTrips();
  }

  Future<void> loadTrips() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTrips = prefs.getStringList('saved_trips') ?? [];
    });
  }

  Future<void> deleteTrip(String city) async {
    final prefs = await SharedPreferences.getInstance();
    savedTrips.remove(city);
    await prefs.setStringList('saved_trips', savedTrips);
    setState(() {});
  }

  String capitalize(String text) {
    return text.split(' ').map((word) =>
        word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : word
    ).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.network(
              'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=1200&q=80',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
                  ),
                ),
              ),
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
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
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

                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    'Saved Trips',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    'Your favourite destinations',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),

                  const SizedBox(height: 8),

                  // Count badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Text(
                      '${savedTrips.length} ${savedTrips.length == 1 ? 'destination' : 'destinations'} saved',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // List or empty state
                  Expanded(
                    child: savedTrips.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: const Icon(Icons.bookmark_border,
                                      color: Colors.white54, size: 48),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'No saved trips yet!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Search a city and tap\n"Save This Trip" to add it here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white60, fontSize: 14),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: savedTrips.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WeatherScreen(cityName: savedTrips[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.location_city,
                                            color: Colors.white, size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              capitalize(savedTrips[index]),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              'Tap to view current weather',
                                              style: TextStyle(
                                                  color: Colors.white60, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios,
                                          color: Colors.white54, size: 16),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => deleteTrip(savedTrips[index]),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.delete_outline,
                                              color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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