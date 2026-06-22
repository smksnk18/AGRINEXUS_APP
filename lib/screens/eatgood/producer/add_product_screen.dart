import 'package:flutter/material.dart';
import '../../../models/eatgood_product_model.dart';
import '../../../services/eatgood_service.dart';

class AddProductScreen extends StatefulWidget {

  final EatGoodProduct? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController =
  TextEditingController();

  final TextEditingController ingredientsController =
  TextEditingController();

  final TextEditingController caloriesController =
  TextEditingController();

  final TextEditingController sugarController =
  TextEditingController();

  final TextEditingController fatController =
  TextEditingController();

  final TextEditingController proteinController =
  TextEditingController();

  final TextEditingController sodiumController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {

      productNameController.text =
          widget.product!.productName;

      ingredientsController.text =
          widget.product!.ingredients.join('\n');

      caloriesController.text =
          widget.product!.calories.toString();

      sugarController.text =
          widget.product!.sugar.toString();

      fatController.text =
          widget.product!.fat.toString();

      proteinController.text =
          widget.product!.protein.toString();

      sodiumController.text =
          widget.product!.sodium.toString();

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Product",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Register Food Product",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Enter product ingredients and nutritional information",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: productNameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: ingredientsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Ingredients (one per line)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Calories",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: sugarController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Sugar",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: fatController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Fat",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: proteinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Protein",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: sodiumController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Sodium",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    List<String> ingredients =
                    ingredientsController.text
                        .split('\n');
                    EatGoodProduct product =
                    EatGoodProduct(
                      productId:
                      widget.product?.productId ??
                          DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),

                      productName:
                      productNameController.text,

                      ingredients: ingredients,

                      calories:
                      double.parse(
                        caloriesController.text,
                      ),

                      sugar:
                      double.parse(
                        sugarController.text,
                      ),

                      fat:
                      double.parse(
                        fatController.text,
                      ),

                      protein:
                      double.parse(
                        proteinController.text,
                      ),

                      sodium:
                      double.parse(
                        sodiumController.text,
                      ),
                      qrData: productNameController.text,
                    );

                    if (widget.product == null) {
                      EatGoodService.addProduct(
                        product,
                      );
                      debugPrint(
                          "TOTAL PRODUCTS = ${EatGoodService.products.length}");
                      debugPrint("PRODUCT SAVED");
                      debugPrint(
                          EatGoodService.products.length.toString());
                      for (var p in EatGoodService.products) {
                        debugPrint(
                            "${p.productName} : ${p.productId}");
                      }
                    }
                    else {
                      EatGoodService.updateProduct(
                        product,
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.product == null
                              ? "Product added successfully"
                              : "Product updated successfully",
                        ),
                      ),
                    );

                    Navigator.pop(context);

                    debugPrint(
                        product.productName);

                    debugPrint(
                        product.ingredients.toString());

                    debugPrint(
                        product.calories.toString());

                  },



                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: Text(
                      "Save Product",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}