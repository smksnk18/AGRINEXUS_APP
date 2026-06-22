import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/forecast_model.dart';
import 'common/agri_card.dart';

class PrecipitationCard extends StatelessWidget {
  final List<ForecastModel> forecast;

  const PrecipitationCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final bool heavyRain =
    forecast.any((e) => e.rainChance > 60);

    return AgriCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Precipitation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: forecast.map((item) {
                final date =
                    DateTime.tryParse(item.time) ??
                        DateTime.now();

                final label =
                DateFormat("ha").format(date);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        Container(
                          height:
                          ((item.rainChance / 100) * 80) +
                              20,

                          decoration: BoxDecoration(
                            color: item.rainChance > 50
                                ? const Color(0xFF003D2A)
                                : const Color(0xFFC8D8D2),

                            borderRadius:
                            BorderRadius.circular(4),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          const Divider(),

          Row(
            children: [
              const Icon(
                Icons.bolt,
                size: 18,
                color: Color(0xFF37474F),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  heavyRain
                      ? "Thunderstorms likely"
                      : "Low precipitation",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),

              Text(
                "${forecast.isNotEmpty ? forecast.first.rainChance.round() : 0}mm expected",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}