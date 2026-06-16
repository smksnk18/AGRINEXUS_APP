import 'package:flutter/material.dart';
import 'common/agri_card.dart';

class SoilMoistureCard extends StatelessWidget {
  final int moisture;

  const SoilMoistureCard({
    super.key,
    required this.moisture,
  });

  @override
  Widget build(BuildContext context) {
    return AgriCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SOIL MOISTURE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$moisture%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius:
            BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: moisture / 100,
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            moisture < 40
                ? "Below optimal. Consider irrigation."
                : moisture < 75
                ? "Optimal levels for most crops."
                : "High moisture. Check drainage.",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}