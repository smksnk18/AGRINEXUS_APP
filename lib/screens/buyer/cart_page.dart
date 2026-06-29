import 'package:flutter/material.dart';

import '../../models/buyer/product_model.dart';

class CartPage extends StatefulWidget {

  final List<Product> cartItems;

  const CartPage({
    super.key,
    required this.cartItems,
  });

  @override
  State<CartPage> createState() =>
      _CartPageState();
}

class _CartPageState
    extends State<CartPage> {

  @override
  Widget build(BuildContext context) {

    int total = 0;

    for (var product
    in widget.cartItems) {

      total +=
          product.price *
              product.quantity;
    }

    return Scaffold(

      backgroundColor:
      const Color(0xffF4FFF1),

      appBar: AppBar(

        backgroundColor: Colors.green,

        title: const Text(

          "My Cart",

          style: TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: widget.cartItems.isEmpty

          ? const Center(

        child: Text(

          "Cart is Empty",

          style: TextStyle(
            fontSize: 20,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      )

          : Column(

        children: [

          // CART ITEMS
          Expanded(

            child: ListView.builder(

              itemCount:
              widget.cartItems.length,

              itemBuilder:
                  (context, index) {

                Product product =
                widget.cartItems[index];

                return Card(

                  margin:
                  const EdgeInsets.all(
                      10),

                  elevation: 3,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),

                  child: Padding(

                    padding:
                    const EdgeInsets.all(
                        10),

                    child: Row(

                      children: [

                        // PRODUCT IMAGE
                        Image.network(

                          product.image,

                          width: 70,
                          height: 70,
                        ),

                        const SizedBox(
                            width: 15),

                        // PRODUCT DETAILS
                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Text(

                                product.name,

                                style:
                                const TextStyle(

                                  fontSize: 18,

                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(

                                "₹${product.price}",

                                style:
                                const TextStyle(

                                  color:
                                  Colors.green,

                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(

                                "Quantity: ${product.quantity}",

                                style:
                                const TextStyle(

                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // DELETE BUTTON
                        IconButton(

                          onPressed: () {

                            setState(() {

                              widget.cartItems
                                  .removeAt(
                                  index);
                            });

                            ScaffoldMessenger.of(
                                context)
                                .showSnackBar(

                              SnackBar(

                                backgroundColor:
                                Colors.red,

                                content: Text(
                                  "${product.name} removed from cart",
                                ),
                              ),
                            );
                          },

                          icon: const Icon(

                            Icons.delete,

                            color: Colors.red,

                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // TOTAL SECTION
          Container(

            padding:
            const EdgeInsets.all(20),

            decoration:
            const BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.only(

                topLeft:
                Radius.circular(20),

                topRight:
                Radius.circular(20),
              ),
            ),

            child: Column(

              children: [

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    const Text(

                      "Total",

                      style: TextStyle(

                        fontSize: 24,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    Text(

                      "₹$total",

                      style: const TextStyle(

                        fontSize: 24,

                        color: Colors.green,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // CHECKOUT BUTTON
                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(

                    onPressed: () {

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(

                        const SnackBar(

                          backgroundColor:
                          Colors.green,

                          content: Text(
                            "Order Placed Successfully",
                          ),
                        ),
                      );
                    },

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.green,

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                            15),
                      ),
                    ),

                    child: const Text(

                      "Checkout",

                      style: TextStyle(

                        fontSize: 18,

                        color: Colors.white,

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
    );
  }
}