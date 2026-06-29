// lib/screens/wishlist_page.dart

import 'package:flutter/material.dart';

import '../../models/buyer/product_model.dart';

class WishlistPage extends StatefulWidget {

  final List<Product> wishlistItems;

  const WishlistPage({

    super.key,
    required this.wishlistItems,
  });

  @override
  State<WishlistPage> createState() =>
      _WishlistPageState();
}

class _WishlistPageState
    extends State<WishlistPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4FFF1),

      appBar: AppBar(
        backgroundColor: Colors.green,

        title: const Text(
          "Wishlist",
        ),
      ),

      body: widget.wishlistItems.isEmpty

          ? const Center(
        child: Text(
          "Wishlist is Empty",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      )

          : ListView.builder(

        itemCount:
        widget.wishlistItems.length,

        itemBuilder: (context, index) {

          Product product =
          widget.wishlistItems[index];

          return Card(

            margin:
            const EdgeInsets.all(10),

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(15),
            ),

            child: ListTile(

              leading: Image.network(
                product.image,
                width: 60,
              ),

              title: Text(
                product.name,
              ),

              subtitle: Text(
                "₹${product.price}",
              ),

              trailing: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}