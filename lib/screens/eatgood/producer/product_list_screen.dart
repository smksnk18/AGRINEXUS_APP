import 'package:flutter/material.dart';
import '../../../services/eatgood_service.dart';
import 'add_product_screen.dart';
import 'qr_generate_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() =>
      _ProductListScreenState();
}

class _ProductListScreenState
    extends State<ProductListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product List",
        ),
      ),
      body: ListView.builder(
        itemCount: EatGoodService.products.length,
        itemBuilder: (context, index) {
          final product =
          EatGoodService.products[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ingredients:",
                  ),
                  Text(
                    product.ingredients.join(", "),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Calories : ${product.calories}",
                  ),
                  Text(
                    "Sugar : ${product.sugar}",
                  ),
                  Text(
                    "Fat : ${product.fat}",
                  ),
                  Text(
                    "Protein : ${product.protein}",
                  ),
                  Text(
                    "Sodium : ${product.sodium}",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                  FilledButton.icon(
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              QRGenerateScreen(
                                product: product,
                              ),
                        ),
                      );

                    },
                    icon: const Icon(
                      Icons.qr_code,
                    ),
                    label: const Text(
                      "Generate QR",
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(
                            product: product,
                          ),
                        ),
                      );
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                    label: const Text(
                      "Edit",
                    ),
                  ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            EatGoodService.deleteProduct(
                              product.productId,
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                        label: const Text(
                          "Delete",
                        ),
                      ),
                  ],
              ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
