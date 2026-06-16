import 'package:flutter/material.dart';
import 'common/agri_card.dart';

class IrrigationCard extends StatelessWidget {

  final int soilMoisture;
  final List rainForecast;

  const IrrigationCard({
    super.key,
    required this.soilMoisture,
    required this.rainForecast,
  });

  @override
  Widget build(BuildContext context) {

    double maxRain = 0;

    if (rainForecast.isNotEmpty) {
      maxRain = rainForecast
          .map((e) => e.rainChance)
          .reduce((a, b) => a > b ? a : b);
    }

    String title;
    String advice;
    Color color;
    IconData icon;

    if (maxRain > 60) {

      title = "Do Not Irrigate";
      advice =
      "Rain expected soon. Save water.";

      color = Colors.red;
      icon = Icons.water_drop;

    } else if (soilMoisture > 70) {

      title = "Irrigation Not Needed";
      advice =
      "Soil moisture is sufficient.";

      color = Colors.orange;
      icon = Icons.grass;

    } else {

      title = "Irrigation Recommended";
      advice =
      "Soil moisture is low.";

      color = Colors.green;
      icon = Icons.check_circle;
    }

    return AgriCard(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          color.withOpacity(0.15),

          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        subtitle: Text(advice),
      ),
    );
  }
}