import 'package:flutter/material.dart';
import '../../models/crop_models.dart';

class VarietyProfileCard extends StatelessWidget {
  final PaddyVariety variety;

  const VarietyProfileCard({
    super.key,
    required this.variety,
  });

  Widget buildInfoTile(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.shade100,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: Colors.green,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor:
                  Color(0xFFE8F5E9),
                  child: Icon(
                    Icons.grass,
                    color: Colors.green,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        variety.name,
                        style:
                        const TextStyle(
                          fontSize: 22,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Text(
                        variety.season,
                        style:
                        TextStyle(
                          color:
                          Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Information Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Duration",
                      "${variety.durationDays} Days",
                      Icons.schedule,
                    ),
                  ),

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Yield",
                      "${variety.avgYield} kg/acre",
                      Icons.bar_chart,
                    ),
                  ),

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Water Need",
                      variety.waterRequirement,
                      Icons.water_drop,
                    ),
                  ),

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Market Price",
                      "₹${variety.marketPrice.toStringAsFixed(0)}",
                      Icons.currency_rupee,
                    ),
                  ),

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Cultivation Cost",
                      "₹${variety.costCultivation.toStringAsFixed(0)}",
                      Icons.account_balance_wallet,
                    ),
                  ),

                  SizedBox(
                    width: 280,
                    child: buildInfoTile(
                      "Estimated Profit",
                      "₹${variety.estimatedProfit.toStringAsFixed(0)}",
                      Icons.trending_up,
                    ),
                  ),
                ],


            ),

            const SizedBox(height: 20),

            /// Disease Resistance
            const Text(
              "Disease Resistance",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: variety.resistances
                  .map(
                    (e) => Chip(
                  label: Text(e),
                  backgroundColor:
                  Colors.green.shade100,
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}