import 'package:flutter/material.dart';
import '../../models/weather_model.dart';

class WeatherHeroCard extends StatelessWidget {

  final WeatherModel weather;

  const WeatherHeroCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: [

          Text(
            "📍 ${weather.location}",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          Image.network(
            "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
            width: 80,
            height: 80,
          ),

          Text(
            "${weather.temperature.round()}°C",
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            weather.condition,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Feels Like ${weather.feelsLike.round()}°C",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}