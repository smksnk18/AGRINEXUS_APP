import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'common/agri_card.dart';

class WeatherFactorsCard extends StatelessWidget {
  final int humidity;
  final int cloudCover;

  const WeatherFactorsCard({
    super.key,
    required this.humidity,
    required this.cloudCover,
  });

  @override
  Widget build(BuildContext context) {
    final int humidityPart = (humidity * 0.7).round();
    final int cloudPart = (cloudCover * 0.15).round();

    final int otherPart =
    (100 - humidityPart - cloudPart).clamp(0, 100);

    return AgriCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weather Factors",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 35,
                    sectionsSpace: 0,
                    sections: [
                      PieChartSectionData(
                        value: humidityPart.toDouble(),
                        color: const Color(0xFF214F36),
                        radius: 18,
                        showTitle: false,
                      ),

                      PieChartSectionData(
                        value: cloudPart.toDouble(),
                        color: const Color(0xFFBFE3D4),
                        radius: 18,
                        showTitle: false,
                      ),

                      PieChartSectionData(
                        value: otherPart.toDouble(),
                        color: const Color(0xFFE5E5E5),
                        radius: 18,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  children: [
                    _legend(
                      "Humidity",
                      humidityPart,
                      const Color(0xFF214F36),
                    ),

                    const SizedBox(height: 12),

                    _legend(
                      "Cloud Cover",
                      cloudPart,
                      const Color(0xFFBFE3D4),
                    ),

                    const SizedBox(height: 12),

                    _legend(
                      "Other",
                      otherPart,
                      const Color(0xFFE5E5E5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(
      String label,
      int value,
      Color color,
      ) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),

        Text(
          "$value%",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}