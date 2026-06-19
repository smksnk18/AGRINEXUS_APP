import 'package:flutter/material.dart';
import '../../models/market_price_model.dart';

class MarketPriceCard extends StatelessWidget {
  final MarketPriceModel marketPrice;

  const MarketPriceCard({
    super.key,
    required this.marketPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const Icon(
                  Icons.currency_rupee,
                  color: Colors.green,
                  size: 28,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Today's Market Price",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Column(
                children: [

                  Text(
                    "₹${marketPrice.modalPrice}",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "per ${marketPrice.unit}",
                    style: TextStyle(
                      color:
                      Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              contentPadding:
              EdgeInsets.zero,
              leading: const Icon(
                Icons.store,
                color: Colors.blue,
              ),
              title: const Text(
                "Market",
              ),
              subtitle: Text(
                marketPrice.market,
              ),
            ),

            const Divider(),

            Row(
              children: [

                Expanded(
                  child: _priceBox(
                    title: "Minimum",
                    value:
                    "₹${marketPrice.minPrice}",
                    color:
                    Colors.orange.shade100,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _priceBox(
                    title: "Maximum",
                    value:
                    "₹${marketPrice.maxPrice}",
                    color:
                    Colors.green.shade100,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: Text(
                "District: ${marketPrice.district}",
                style: const TextStyle(
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceBox({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}