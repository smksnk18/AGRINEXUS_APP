import 'package:flutter/material.dart';
import '../../models/disease_risk_model.dart';

class DiseaseRiskCard extends StatelessWidget {
  final List<DiseaseRiskModel> diseases;

  const DiseaseRiskCard({
    super.key,
    required this.diseases,
  });

  @override
  Widget build(BuildContext context) {

    if (diseases.isEmpty) {
      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          title: const Text(
            "No Disease Risk Detected",
          ),
          subtitle: const Text(
            "Current weather conditions are favorable.",
          ),
        ),
      );
    }

    return Column(
      children: diseases.map((disease) {

        Color severityColor =
        disease.severity == "High"
            ? Colors.red
            : Colors.orange;

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
                      Icons.warning,
                      color: severityColor,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        disease.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),

                    Chip(
                      label: Text(
                        disease.severity,
                      ),
                      backgroundColor:
                      severityColor.withOpacity(
                        0.15,
                      ),
                    ),
                  ],
                ),

                const Divider(),

                const Text(
                  "Symptoms",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                ...disease.symptoms.map(
                      (s) => Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: Text("• $s"),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "Prevention",
                  style: TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                ...disease.prevention.map(
                      (p) => Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: Text("✓ $p"),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}