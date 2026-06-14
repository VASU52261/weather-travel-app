import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({super.key, required this.cityName});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String error = '';
  final String apiKey = '32a429fdc961b672dab1b87c20d66312';

  // City background images
  final Map<String, String> cityImages = {
    'bengaluru': 'https://images.unsplash.com/photo-1596176530529-78163a4f7af2?w=1200&q=80',
    'bangalore': 'https://images.unsplash.com/photo-1596176530529-78163a4f7af2?w=1200&q=80',
    'paris': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=1200&q=80',
    'london': 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=1200&q=80',
    'tokyo': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=1200&q=80',
    'dubai': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=1200&q=80',
    'mumbai': 'https://images.unsplash.com/photo-1529253355930-ddbe423a2ac7?w=1200&q=80',
    'delhi': 'https://images.unsplash.com/photo-1587474260584-136574528ed5?w=1200&q=80',
    'himachal pradesh': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=1200&q=80',
    'manali': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=1200&q=80',
    'shimla': 'https://images.unsplash.com/photo-1626621341517-bbf3d9990a23?w=1200&q=80',
    'new york': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=1200&q=80',
    'sydney': 'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=1200&q=80',
    'bali': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=1200&q=80',
    'goa': 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200&q=80',
    'singapore': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=1200&q=80',
    'korea': 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=1200&q=80',
    'seoul': 'https://images.unsplash.com/photo-1517154421773-0529f29ea451?w=1200&q=80',
    'japan': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=1200&q=80',
    'osaka': 'https://images.unsplash.com/photo-1590559899731-a382839e5549?w=1200&q=80',
    'rome': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=1200&q=80',
    'barcelona': 'https://images.unsplash.com/photo-1523531294919-4bcd7c65e216?w=1200&q=80',
    'amsterdam': 'https://images.unsplash.com/photo-1534351590666-13e3e96b5017?w=1200&q=80',
    'thailand': 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=1200&q=80',
    'bangkok': 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=1200&q=80',
    'maldives': 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=1200&q=80',
    'kerala': 'https://images.unsplash.com/photo-1593693397690-362cb9666fc2?w=1200&q=80',
    'jaipur': 'https://images.unsplash.com/photo-1477587458883-47145ed94245?w=1200&q=80',
    'agra': 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=1200&q=80',
    'chennai': 'https://images.unsplash.com/photo-1582510003544-4d00b7f74220?w=1200&q=80',
    'kolkata': 'https://images.unsplash.com/photo-1558431382-27e303142255?w=1200&q=80',
    'hyderabad': 'https://images.unsplash.com/photo-1572445271230-a78d4de2f732?w=1200&q=80',
    'pune': 'https://images.unsplash.com/photo-1591018533408-feb57be8fb89?w=1200&q=80',
    'new zealand': 'https://images.unsplash.com/photo-1507699622108-4be3abd695ad?w=1200&q=80',
    'iceland': 'https://images.unsplash.com/photo-1476610182048-b716b8518aae?w=1200&q=80',
    'switzerland': 'https://images.unsplash.com/photo-1530122037265-a5f1f91d3b99?w=1200&q=80',
    };

  String getBackgroundImage() {
    final city = widget.cityName.toLowerCase().trim();
    return cityImages[city] ??
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1200&q=80';
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?q=${widget.cityName}&appid=$apiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'City not found!';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Check your internet connection!';
        isLoading = false;
      });
    }
  }

  Future<void> saveTrip() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedTrips = prefs.getStringList('saved_trips') ?? [];
    if (!savedTrips.contains(widget.cityName)) {
      savedTrips.add(widget.cityName);
      await prefs.setStringList('saved_trips', savedTrips);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip saved successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip already saved!')),
      );
    }
  }

  String getTravelAdvice(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'Perfect for sightseeing and outdoor activities!';
      case 'clouds':
        return 'Good for walking tours and outdoor dining!';
      case 'rain':
        return 'Visit museums and indoor attractions!';
      case 'snow':
        return 'Great for winter sports and cozy cafes!';
      case 'thunderstorm':
        return 'Stay indoors, visit malls or cinemas!';
      default:
        return 'Enjoy your trip and explore the city!';
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic City Background
          SizedBox.expand(
            child: Image.network(
              getBackgroundImage(),
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: const Color(0xFF1E88E5));
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
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : error.isNotEmpty
    ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
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
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, color: Colors.white, size: 60),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 10),
                  const Text('Please check the city name and try again',
                      style: TextStyle(color: Colors.white60, fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      )
                    : SingleChildScrollView(
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
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // City Name
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    weatherData!['name'],
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    weatherData!['sys']['country'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        letterSpacing: 2),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Weather Icon + Temp
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    getWeatherIcon(
                                        weatherData!['weather'][0]['main']),
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${weatherData!['main']['temp'].round()}°C',
                                    style: const TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    weatherData!['weather'][0]['description']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                        letterSpacing: 2),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Weather Stats Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _statCard(Icons.water_drop_outlined,
                                      '${weatherData!['main']['humidity']}%', 'Humidity'),
                                  _divider(),
                                  _statCard(Icons.air,
                                      '${weatherData!['wind']['speed']} m/s', 'Wind'),
                                  _divider(),
                                  _statCard(Icons.thermostat,
                                      '${weatherData!['main']['feels_like'].round()}°C', 'Feels Like'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Travel Advice Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline,
                                      color: Colors.yellowAccent, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      getTravelAdvice(
                                          weatherData!['weather'][0]['main']),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Save Trip Button
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
                                onPressed: saveTrip,
                                icon: const Icon(Icons.bookmark_add_outlined),
                                label: const Text('Save This Trip',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
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

  Widget _statCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white30,
    );
  }
}