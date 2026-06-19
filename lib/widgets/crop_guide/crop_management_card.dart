import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/crop_models.dart';

class CropManagementCard extends StatelessWidget {
  final PaddyVariety variety;
  final DateTime plantingDate;

  const CropManagementCard({
    super.key,
    required this.variety,
    required this.plantingDate,
  });

  Widget _activityTile(
      String activity,
      DateTime date,
      ) {
    return ListTile(
      dense: true,
      leading: const Icon(
        Icons.event,
        color: Colors.green,
      ),
      title: Text(activity),
      subtitle: Text(
        DateFormat(
          "dd MMM yyyy",
        ).format(date),
      ),
    );
  }

  Widget _buildCropCalendar() {
    final nurseryDate = plantingDate;

    final transplantingDate = plantingDate.add(
      const Duration(days: 15),
    );

    final tilleringDate = plantingDate.add(
      const Duration(days: 30),
    );

    final floweringDate = plantingDate.add(
      const Duration(days: 60),
    );

    final harvestDate = plantingDate.add(
      Duration(
        days: variety.durationDays,
      ),
    );

    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  "Crop Calendar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _activityTile(
              "Nursery Preparation",
              nurseryDate,
            ),

            _activityTile(
              "Transplanting",
              transplantingDate,
            ),

            _activityTile(
              "Tillering",
              tilleringDate,
            ),

            _activityTile(
              "Flowering",
              floweringDate,
            ),

            _activityTile(
              "Harvest",
              harvestDate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title,
      List<String> items,
      IconData icon,
      ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ...items.map(
                  (e) => Padding(
                padding:
                const EdgeInsets.only(
                  bottom: 6,
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expectedHarvestDate =
    plantingDate.add(
      Duration(
        days: variety.durationDays,
      ),
    );

    final daysLeft =
        expectedHarvestDate
            .difference(
          DateTime.now(),
        )
            .inDays;

    final double progress =
    (1 -
        (daysLeft /
            variety.durationDays))
        .clamp(0.0, 1.0)
        .toDouble();

    return Column(
      children: [
        _buildCropCalendar(),

        _buildSection(
          "Fertilizer Schedule",
          variety.fertilizerSchedule,
          Icons.science,
        ),

        _buildSection(
          "Irrigation Plan",
          variety.irrigationPlan,
          Icons.water_drop,
        ),

        _buildSection(
          "Disease Alerts",
          variety.diseaseAlerts,
          Icons.warning_amber,
        ),

        Card(
          child: Padding(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.agriculture,
                    color: Colors.green,
                  ),
                  title: const Text(
                    "Harvest Countdown",
                  ),
                  subtitle: Text(
                    "$daysLeft days remaining",
                  ),
                ),

                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius:
                  BorderRadius.circular(
                    10,
                  ),
                  color: Colors.green,
                  backgroundColor:
                  Colors.green.shade100,
                ),

                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(
                    Icons.event,
                    color: Colors.green,
                  ),
                  title: const Text(
                    "Expected Harvest Date",
                  ),
                  subtitle: Text(
                    DateFormat(
                      "dd MMM yyyy",
                    ).format(
                      expectedHarvestDate,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}