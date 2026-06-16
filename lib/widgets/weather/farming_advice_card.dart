import 'package:flutter/material.dart';
import '../../models/forecast_model.dart';

class FarmingAdviceCard extends StatelessWidget {

  final double temperature;
  final int humidity;
  final double windSpeed;
  final List<ForecastModel> rainForecast;

  const FarmingAdviceCard({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainForecast,
  });

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> advice = [];

    final maxRain =
    rainForecast.isEmpty
        ? 0.0
        : rainForecast
        .map((e) => e.rainChance)
        .reduce(
          (a, b) => a > b ? a : b,
    );

    if (maxRain > 60) {
      advice.add({
        "icon": Icons.water_drop,
        "title": "Avoid Irrigation",
        "subtitle":
        "Rain is expected soon. Save water.",
      });
    }

    if (windSpeed > 15) {
      advice.add({
        "icon": Icons.air,
        "title": "Delay Spraying",
        "subtitle":
        "Strong winds may reduce effectiveness.",
      });
    }

    if (humidity > 80) {
      advice.add({
        "icon": Icons.bug_report,
        "title": "Disease Risk",
        "subtitle":
        "High humidity favors fungal growth.",
      });
    }

    if (temperature > 35) {
      advice.add({
        "icon": Icons.wb_sunny,
        "title": "Heat Stress Alert",
        "subtitle":
        "Monitor crops during peak sunlight.",
      });
    }

    if (advice.isEmpty) {
      advice.add({
        "icon": Icons.check_circle,
        "title": "Good Conditions",
        "subtitle":
        "Current weather is favorable.",
      });
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF0A4D2E),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          const Text(
            "🌱 Farming Advice",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ...advice.map((item) {

            return ListTile(
              contentPadding:
              EdgeInsets.zero,

              leading: CircleAvatar(
                backgroundColor:
                Colors.white24,

                child: Icon(
                  item["icon"],
                  color: Colors.white,
                ),
              ),

              title: Text(
                item["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              subtitle: Text(
                item["subtitle"],
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}