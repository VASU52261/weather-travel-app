import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WeatherMapScreen extends StatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen> {
  String _selectedLayer = 'temp_new';
  final String _apiKey = '32a429fdc961b672dab1b87c20d66312';
  final MapController _mapController = MapController();

  final List<Map<String, dynamic>> mapLayers = [
    {'id': 'temp_new', 'label': 'Temperature', 'icon': Icons.thermostat, 'color': Colors.orange},
    {'id': 'precipitation_new', 'label': 'Rainfall', 'icon': Icons.grain, 'color': Colors.blue},
    {'id': 'wind_new', 'label': 'Wind Speed', 'icon': Icons.air, 'color': Colors.teal},
    {'id': 'clouds_new', 'label': 'Clouds', 'icon': Icons.cloud, 'color': Colors.grey},
    {'id': 'pressure_new', 'label': 'Pressure', 'icon': Icons.speed, 'color': Colors.purple},
  ];

  final Map<String, List<Map<String, dynamic>>> legends = {
    'temp_new': [
      {'color': Color(0xFF0000FF), 'label': '< -40°C'},
      {'color': Color(0xFF00AAFF), 'label': '-20°C'},
      {'color': Color(0xFF00FF00), 'label': '0°C'},
      {'color': Color(0xFFFFFF00), 'label': '20°C'},
      {'color': Color(0xFFFF4400), 'label': '> 40°C'},
    ],
    'precipitation_new': [
      {'color': Color(0xFFE0F7FA), 'label': 'Light'},
      {'color': Color(0xFF4FC3F7), 'label': 'Moderate'},
      {'color': Color(0xFF0D47A1), 'label': 'Heavy'},
    ],
    'wind_new': [
      {'color': Color(0xFFE8F5E9), 'label': 'Calm'},
      {'color': Color(0xFF66BB6A), 'label': 'Moderate'},
      {'color': Color(0xFF1B5E20), 'label': 'Strong'},
    ],
    'clouds_new': [
      {'color': Color(0xFFFFFFFF), 'label': 'Clear'},
      {'color': Color(0xFFBDBDBD), 'label': 'Partly'},
      {'color': Color(0xFF424242), 'label': 'Overcast'},
    ],
    'pressure_new': [
      {'color': Color(0xFF4A148C), 'label': 'Low'},
      {'color': Color(0xFF7B1FA2), 'label': 'Normal'},
      {'color': Color(0xFFCE93D8), 'label': 'High'},
    ],
  };

  String _getLayerDescription(String layer) {
    switch (layer) {
      case 'temp_new': return 'Temperature heatmap — find warm or cool destinations.';
      case 'precipitation_new': return 'Rainfall map — plan around rainy regions.';
      case 'wind_new': return 'Wind speed — useful for coastal and mountain travel.';
      case 'clouds_new': return 'Cloud cover — find clear skies for your trip.';
      case 'pressure_new': return 'Atmospheric pressure — low pressure means storms ahead.';
      default: return 'Select a layer to explore weather patterns.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
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
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weather Maps',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Interactive live weather layers',
                              style: TextStyle(fontSize: 12, color: Colors.white60)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Layer Selector
                SizedBox(
                  height: 72,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: mapLayers.length,
                    itemBuilder: (context, index) {
                      final layer = mapLayers[index];
                      final isSelected = _selectedLayer == layer['id'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedLayer = layer['id']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 95,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (layer['color'] as Color).withOpacity(0.35)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? (layer['color'] as Color) : Colors.white24,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(layer['icon'] as IconData,
                                  color: isSelected ? (layer['color'] as Color) : Colors.white54,
                                  size: 22),
                              const SizedBox(height: 4),
                              Text(layer['label'],
                                  style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white54,
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Interactive Map
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: const MapOptions(
                              initialCenter: LatLng(20.5937, 78.9629),
                              initialZoom: 2.5,
                              minZoom: 1,
                              maxZoom: 8,
                            ),
                            children: [
                              // Base OpenStreetMap
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.weather_travel_app',
                                additionalOptions: const {
                                  'language': 'en',
  },
),
                              // Weather Overlay
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openweathermap.org/map/$_selectedLayer/{z}/{x}/{y}.png?appid=$_apiKey',
                                userAgentPackageName: 'com.example.weather_travel_app',
                              ),
                            ],
                          ),

                          // Zoom Controls
                          Positioned(
                            right: 12,
                            bottom: 80,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _mapController.move(
                                      _mapController.camera.center,
                                      _mapController.camera.zoom + 1,
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    _mapController.move(
                                      _mapController.camera.center,
                                      _mapController.camera.zoom - 1,
                                    );
                                  },
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.remove, color: Colors.white, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Layer label
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    mapLayers.firstWhere((l) => l['id'] == _selectedLayer)['icon'] as IconData,
                                    color: Colors.white, size: 12),
                                  const SizedBox(width: 5),
                                  Text(
                                    mapLayers.firstWhere((l) => l['id'] == _selectedLayer)['label'],
                                    style: const TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Legend + Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: (legends[_selectedLayer] ?? []).map((item) {
                            return Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 12, height: 12,
                                    decoration: BoxDecoration(
                                      color: item['color'] as Color,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(item['label'],
                                      style: const TextStyle(color: Colors.white70, fontSize: 10)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.white60, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(_getLayerDescription(_selectedLayer),
                                  style: const TextStyle(color: Colors.white60, fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}