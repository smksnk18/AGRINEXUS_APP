import 'package:flutter/material.dart';
import '../../models/forecast_model.dart';

class WeatherAlertCard extends StatelessWidget {

  final int humidity;
  final double windSpeed;
  final List<ForecastModel> rainForecast;

  const WeatherAlertCard({
    super.key,
    required this.humidity,
    required this.windSpeed,
    required this.rainForecast,
  });

  @override
  Widget build(BuildContext context) {

    final maxRain =
    rainForecast.isEmpty
        ? 0.0
        : rainForecast
        .map((e) => e.rainChance)
        .reduce(
          (a, b) => a > b ? a : b,
    );

    String title = "No Alerts";
    String message =
        "Weather conditions are stable.";

    Color color = Colors.green;

    if (maxRain > 70) {

      title = "Heavy Rain Alert";

      message =
      "Rain expected. Avoid irrigation and spraying.";

      color = Colors.red;
    }
    else if (windSpeed > 20) {

      title = "Strong Wind Alert";

      message =
      "Delay pesticide spraying.";

      color = Colors.orange;
    }
    else if (humidity > 85) {

      title = "Disease Risk Alert";

      message =
      "High humidity may encourage fungal diseases.";

      color = Colors.orange;
    }

    return Container(
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: color,
        ),
      ),

      child: Row(
        children: [

          Icon(
            Icons.warning_amber,
            color: color,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}