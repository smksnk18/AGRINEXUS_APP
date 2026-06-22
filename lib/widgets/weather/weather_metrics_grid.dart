import 'package:flutter/material.dart';
import 'weather_metric_card.dart';

class WeatherMetricsGrid extends StatelessWidget {

  final double windSpeed;
  final int humidity;
  final int uvIndex;
  final double visibility;

  const WeatherMetricsGrid({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.uvIndex,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {

    return GridView.count(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),

      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,

      children: [

        WeatherMetricCard(
          icon: Icons.air,
          title: "Wind Speed",
          value: "${(windSpeed * 3.6).toStringAsFixed(0)} km/h",
        ),

        WeatherMetricCard(
          icon: Icons.water_drop,
          title: "Humidity",
          value: "$humidity%",
        ),

        WeatherMetricCard(
          icon: Icons.wb_sunny,
          title: "UV Index",
          value: uvIndex.toStringAsFixed(1),
        ),

        WeatherMetricCard(
          icon: Icons.visibility,
          title: "Visibility",
          value: "${visibility.toStringAsFixed(0)} km",
        ),
      ],
    );
  }
}