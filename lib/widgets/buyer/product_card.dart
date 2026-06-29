import 'package:flutter/material.dart';

import '../../models/buyer/product_model.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  final VoidCallback onAdd;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const ProductCard({

    super.key,

    required this.product,

    required this.onAdd,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(20),

          boxShadow: [

            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
            ),
          ],
        ),

        child: Padding(

          padding: const EdgeInsets.all(10),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // FAVORITE BUTTON
              Align(

                alignment: Alignment.topRight,

                child: GestureDetector(

                  onTap: onFavorite,

                  child: Icon(

                    product.favorite

                        ? Icons.favorite

                        : Icons.favorite_border,

                    color: Colors.red,
                  ),
                ),
              ),

              // PRODUCT IMAGE
              Expanded(

                child: Center(

                  child: Image.network(
                    product.image,

                    height: 90,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // PRODUCT NAME
              Text(

                product.name,

                style: const TextStyle(

                  fontWeight: FontWeight.bold,

                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 5),

              // PRICE
              Text(

                "₹${product.price}",

                style: const TextStyle(

                  color: Colors.green,

                  fontWeight: FontWeight.bold,

                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 5),

              // RATING
              Row(

                children: [

                  const Icon(
                    Icons.star,

                    color: Colors.orange,

                    size: 18,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    product.rating.toString(),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ADD BUTTON
              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: onAdd,

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.green,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                          12),
                    ),
                  ),

                  child: const Text(

                    "Add",

                    style: TextStyle(
                      color: Colors.white,
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