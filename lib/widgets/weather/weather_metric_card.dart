import 'package:flutter/material.dart';
import 'common/agri_card.dart';

class WeatherMetricCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;

  const WeatherMetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}