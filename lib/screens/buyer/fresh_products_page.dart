// lib/screens/fresh_products_page.dart

import 'package:flutter/material.dart';

import '../../models/buyer/product_model.dart';
import '../../widgets/buyer/product_card.dart';
import 'product_details_page.dart';

class FreshProductsPage extends StatefulWidget {

  final List<Product> products;

  const FreshProductsPage({
    super.key,
    required this.products,
  });

  @override
  State<FreshProductsPage> createState() =>
      _FreshProductsPageState();
}

class _FreshProductsPageState
    extends State<FreshProductsPage> {

  List<Product> cartItems = [];

  int cartCount = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4FFF1),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,

        title: const Text(
          "Fresh Products",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          // CART ICON
          Padding(
            padding:
            const EdgeInsets.only(right: 15),

            child: Stack(

              alignment: Alignment.center,

              children: [

                const Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),

                Positioned(
                  right: 0,
                  top: 8,

                  child: Container(

                    padding:
                    const EdgeInsets.all(4),

                    decoration:
                    const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),

                    child: Text(
                      cartCount.toString(),

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ================= BODY =================

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: GridView.builder(

          itemCount: widget.products.length,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 2,

            crossAxisSpacing: 12,
            mainAxisSpacing: 12,

            childAspectRatio: 0.70,
          ),

          itemBuilder: (context, index) {

            Product product =
            widget.products[index];

            return ProductCard(

              product: product,

              // ADD TO CART
              onAdd: () {

                setState(() {

                  cartCount++;

                  cartItems.add(product);
                });

                ScaffoldMessenger.of(context)
                    .showSnackBar(

                  SnackBar(
                    backgroundColor:
                    Colors.green,

                    content: Text(
                      "${product.name} added to cart",
                    ),
                  ),
                );
              },

              // FAVORITE
              onFavorite: () {

                setState(() {
                  product.favorite =
                  !product.favorite;
                });
              },

              // PRODUCT DETAILS
              onTap: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsPage(
                          product: product,
                        ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}