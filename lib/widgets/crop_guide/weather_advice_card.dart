import 'package:flutter/material.dart';

class WeatherAdviceCard extends StatelessWidget {
  final double temperature;
  final int humidity;
  final bool rainExpected;

  const WeatherAdviceCard({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.rainExpected,
  });

  String getAdvice() {
    if (rainExpected) {
      return "Delay irrigation for 24 hours.";
    }

    if (temperature > 35) {
      return "Increase irrigation frequency.";
    }

    if (humidity > 85) {
      return "Monitor crop for fungal diseases.";
    }

    return "Weather conditions are favorable.";
  }

  String getDiseaseRisk() {
    if (humidity > 80 && temperature >= 25 && temperature <= 32) {
      return "Medium Blast Risk";
    }

    return "Low Disease Risk";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                ),
                SizedBox(width: 8),
                Text(
                  "Today's Advice",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Humidity: $humidity%",
            ),

            Text(
              "Temperature: ${temperature.toStringAsFixed(1)}°C",
            ),

            Text(
              "Rain Expected: ${rainExpected ? "Yes" : "No"}",
            ),

            const Divider(height: 24),

            Text(
              "Recommendation",
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(getAdvice()),

            const SizedBox(height: 16),

            Text(
              "Disease Risk",
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(getDiseaseRisk()),
          ],
        ),
      ),
    );
  }
}