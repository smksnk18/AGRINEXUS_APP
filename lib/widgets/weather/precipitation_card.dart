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
    forecast.any(
          (e) => e.rainChance > 60,
    );

    return AgriCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
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
              crossAxisAlignment:
              CrossAxisAlignment.end,
              children: forecast.map((item) {

                final date =
                    DateTime.tryParse(
                      item.time,
                    ) ??
                        DateTime.now();

                final label =
                DateFormat("ha")
                    .format(date);

                return Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),

                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [

                        Container(
                          height:
                          ((item.rainChance / 100)
                              * 80) +
                              20,

                          decoration:
                          BoxDecoration(
                            color:
                            Colors.green,
                            borderRadius:
                            BorderRadius
                                .circular(4),
                          ),
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          label,
                          style:
                          const TextStyle(
                            fontSize: 10,
                            color:
                            Colors.grey,
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

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [

              Text(
                heavyRain
                    ? "Thunderstorms likely"
                    : "Low precipitation",
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const Text(
                "Forecast",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}