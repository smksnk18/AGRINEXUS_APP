// lib/screens/dashboard_page.dart

import 'package:flutter/material.dart';

import '../../models/buyer/product_model.dart';
import '../../widgets/buyer/category_card.dart';
import '../../widgets/buyer/offer_banner.dart';
import '../../widgets/buyer/product_card.dart';

import 'cart_page.dart';
import 'fresh_products_page.dart';
import 'notifications_page.dart';
import 'product_details_page.dart';
import 'profile_page.dart';
import 'wishlist_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {

  int cartCount = 0;

  int selectedIndex = 0;

  String search = "";

  String selectedCategory = "All";

  TextEditingController searchController =
  TextEditingController();

  // CART ITEMS
  List<Product> cartItems = [];

  // WISHLIST ITEMS
  List<Product> wishlistItems = [];

  // PRODUCTS
  List<Product> products = [

    // VEGETABLES

    Product(
      name: "Tomato",
      price: 40,
      image:
      "https://img.icons8.com/color/480/tomato.png",
      description:
      "Fresh organic tomatoes.",
      rating: 4.5,
      category: "Vegetables",
    ),

    Product(
      name: "Potato",
      price: 30,
      image:
      "https://img.icons8.com/color/480/potato.png",
      description:
      "Premium quality potatoes.",
      rating: 4.3,
      category: "Vegetables",
    ),

    Product(
      name: "Carrot",
      price: 50,
      image:
      "https://img.icons8.com/color/480/carrot.png",
      description:
      "Healthy carrots.",
      rating: 4.7,
      category: "Vegetables",
    ),

    Product(
      name: "Onion",
      price: 35,
      image:
      "https://img.icons8.com/color/480/onion.png",
      description:
      "Fresh onions.",
      rating: 4.4,
      category: "Vegetables",
    ),

    Product(
      name: "Cabbage",
      price: 45,
      image:
      "https://img.icons8.com/color/480/cabbage.png",
      description:
      "Organic cabbage.",
      rating: 4.2,
      category: "Vegetables",
    ),

    Product(
      name: "Corn",
      price: 70,
      image:
      "https://img.icons8.com/color/480/corn.png",
      description:
      "Fresh organic corn.",
      rating: 4.5,
      category: "Vegetables",
    ),

    // FRUITS

    Product(
      name: "Apple",
      price: 120,
      image:
      "https://img.icons8.com/color/480/apple.png",
      description:
      "Fresh apples.",
      rating: 4.8,
      category: "Fruits",
    ),

    Product(
      name: "Banana",
      price: 50,
      image:
      "https://img.icons8.com/color/480/banana.png",
      description:
      "Healthy bananas.",
      rating: 4.6,
      category: "Fruits",
    ),

    Product(
      name: "Orange",
      price: 80,
      image:
      "https://img.icons8.com/color/480/orange.png",
      description:
      "Juicy oranges.",
      rating: 4.7,
      category: "Fruits",
    ),

    Product(
      name: "Mango",
      price: 150,
      image:
      "https://img.icons8.com/color/480/mango.png",
      description:
      "Sweet mangoes.",
      rating: 4.9,
      category: "Fruits",
    ),

    Product(
      name: "Pineapple",
      price: 90,
      image:
      "https://img.icons8.com/color/480/pineapple.png",
      description:
      "Fresh pineapple.",
      rating: 4.5,
      category: "Fruits",
    ),

    // ORGANIC

    Product(
      name: "Rice",
      price: 95,
      image:
      "https://img.icons8.com/color/480/rice-bowl.png",
      description:
      "Healthy organic rice.",
      rating: 4.8,
      category: "Organic",
    ),

    Product(
      name: "Honey",
      price: 250,
      image:
      "https://img.icons8.com/color/480/honey.png",
      description:
      "Pure organic honey.",
      rating: 4.9,
      category: "Organic",
    ),

    // FLOWERS

    Product(
      name: "Rose",
      price: 100,
      image:
      "https://img.icons8.com/color/480/rose.png",
      description:
      "Fresh red roses.",
      rating: 4.8,
      category: "Flowers",
    ),

    Product(
      name: "Sunflower",
      price: 120,
      image:
      "https://img.icons8.com/color/480/sunflower.png",
      description:
      "Bright sunflower flowers.",
      rating: 4.7,
      category: "Flowers",
    ),
  ];

  @override
  Widget build(BuildContext context) {

    List<Product> filteredProducts =
    products.where((product) {

      final productName =
      product.name.toLowerCase();

      final searchText =
      search.toLowerCase();

      bool matchesSearch =
      productName.contains(searchText);

      bool matchesCategory =
          selectedCategory == "All" ||
              product.category ==
                  selectedCategory;

      return matchesSearch &&
          matchesCategory;

    }).toList();

    return Scaffold(

      backgroundColor:
      const Color(0xffF4FFF1),

      appBar: AppBar(

        backgroundColor: Colors.green,

        elevation: 0,

        title: const Text(

          "Buyer Dashboard",

          style: TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: 24,
          ),
        ),

        actions: [

          // NOTIFICATION
          IconButton(

            icon: const Icon(
              Icons.notifications,

              color: Colors.white,
            ),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                  const NotificationsPage(),
                ),
              );
            },
          ),

          // CART
          Padding(

            padding:
            const EdgeInsets.only(right: 15),

            child: InkWell(

              onTap: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      cartItems: cartItems,
                    ),
                  ),
                );
              },

              child: Stack(

                alignment: Alignment.center,

                children: [

                  const Icon(
                    Icons.shopping_cart,

                    size: 30,

                    color: Colors.white,
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
          ),
        ],
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding:
            const EdgeInsets.all(15),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                // OFFER BANNER
                const OfferBanner(),

                const SizedBox(height: 20),

                // SEARCH BAR
                TextField(

                  controller:
                  searchController,

                  decoration: InputDecoration(

                    hintText:
                    "Search products...",

                    prefixIcon:
                    const Icon(Icons.search),

                    suffixIcon:
                    search.isNotEmpty

                        ? IconButton(

                      onPressed: () {

                        searchController
                            .clear();

                        setState(() {

                          search = "";
                        });
                      },

                      icon: const Icon(
                        Icons.close,
                      ),
                    )

                        : null,

                    filled: true,
                    fillColor:
                    Colors.white,

                    border:
                    OutlineInputBorder(

                      borderRadius:
                      BorderRadius.circular(
                          18),

                      borderSide:
                      BorderSide.none,
                    ),
                  ),

                  onChanged: (value) {

                    setState(() {

                      search = value;
                    });
                  },
                ),

                const SizedBox(height: 25),

                // CATEGORY TITLE
                const Text(

                  "Categories",

                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // CATEGORIES
                SizedBox(

                  height: 110,

                  child: ListView(

                    scrollDirection:
                    Axis.horizontal,

                    children: [

                      InkWell(

                        onTap: () {

                          setState(() {
                            selectedCategory =
                            "Vegetables";
                          });
                        },

                        child:
                        const CategoryCard(
                          icon:
                          Icons.grass,
                          title:
                          "Vegetables",
                        ),
                      ),

                      InkWell(

                        onTap: () {

                          setState(() {
                            selectedCategory =
                            "Fruits";
                          });
                        },

                        child:
                        const CategoryCard(
                          icon:
                          Icons.apple,
                          title: "Fruits",
                        ),
                      ),

                      InkWell(

                        onTap: () {

                          setState(() {
                            selectedCategory =
                            "Organic";
                          });
                        },

                        child:
                        const CategoryCard(
                          icon: Icons.eco,
                          title:
                          "Organic",
                        ),
                      ),

                      InkWell(

                        onTap: () {

                          setState(() {
                            selectedCategory =
                            "Flowers";
                          });
                        },

                        child:
                        const CategoryCard(
                          icon: Icons
                              .local_florist,
                          title:
                          "Flowers",
                        ),
                      ),

                      InkWell(

                        onTap: () {

                          setState(() {
                            selectedCategory =
                            "All";
                          });
                        },

                        child:
                        const CategoryCard(
                          icon:
                          Icons.grid_view,
                          title: "All",
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // FRESH PRODUCTS TITLE
                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    const Text(

                      "Fresh Products",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    GestureDetector(

                      onTap: () {

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                FreshProductsPage(
                                  products:
                                  products,
                                ),
                          ),
                        );
                      },

                      child: const Text(

                        "See All",

                        style: TextStyle(

                          color: Colors.green,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PRODUCTS
                filteredProducts.isEmpty

                    ? const Center(
                  child: Padding(
                    padding:
                    EdgeInsets.all(50),

                    child: Text(
                      "No Products Found",
                    ),
                  ),
                )

                    : GridView.builder(

                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  filteredProducts.length,

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    crossAxisSpacing:
                    12,

                    mainAxisSpacing:
                    12,

                    childAspectRatio:
                    0.72,
                  ),

                  itemBuilder:
                      (context, index) {

                    Product product =
                    filteredProducts[
                    index];

                    return ProductCard(

                      product:
                      product,

                      // ADD TO CART
                      onAdd: () {

                        setState(() {

                          int existingIndex =
                          cartItems.indexWhere(

                                (item) =>
                            item.name ==
                                product.name,
                          );

                          // ALREADY EXISTS
                          if (existingIndex != -1) {

                            cartItems[
                            existingIndex]
                                .quantity++;

                          }

                          // NEW PRODUCT
                          else {

                            cartItems.add(

                              Product(

                                name:
                                product.name,

                                price:
                                product.price,

                                image:
                                product.image,

                                description:
                                product.description,

                                rating:
                                product.rating,

                                category:
                                product.category,

                                quantity: 1,
                              ),
                            );
                          }

                          // CART COUNT
                          cartCount++;
                        });

                        ScaffoldMessenger.of(
                            context)
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

                      // WISHLIST
                      onFavorite: () {

                        setState(() {

                          product.favorite =
                          !product.favorite;

                          if (product.favorite) {

                            wishlistItems
                                .add(product);

                          } else {

                            wishlistItems
                                .remove(product);
                          }
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
              ],
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex:
        selectedIndex,

        selectedItemColor:
        Colors.green,

        onTap: (index) {

          setState(() {
            selectedIndex = index;
          });

          // WISHLIST
          if (index == 1) {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    WishlistPage(
                      wishlistItems:
                      wishlistItems,
                    ),
              ),
            );
          }

          // PROFILE
          if (index == 2) {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                const ProfilePage(),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon:
            Icon(Icons.favorite),
            label: "Wishlist",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}