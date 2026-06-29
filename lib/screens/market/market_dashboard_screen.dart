import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../models/market/market_item_model.dart';
import '../../services/market/api_service.dart';


class MarketDashboardScreen extends StatefulWidget {
  const MarketDashboardScreen({super.key});

  @override
  State<MarketDashboardScreen> createState() => _MarketDashboardScreenState();
}

class _MarketDashboardScreenState extends State<MarketDashboardScreen> {
  String selectedCategory = 'All';
  String selectedCountry = 'Select Country';
  String selectedState = 'All States';
  String selectedDistrict = 'All Districts';
  bool showMarketData=false;

  List<String> states = [];
  List<String> districts = [];
  late Future<List<MarketItem>> futureData;

  List<MarketItem> allItems = [];
  List<MarketItem> filteredItems = [];

  Set<String> favourites = {};

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    futureData = ApiService().fetchMarketPrices();

    futureData.then((data) {
      setState(() {
        allItems = data;
        filteredItems = data;

        states = allItems.map((e) => e.state).toSet().toList();

        states.sort();
      });
    });
  }

  void searchItem(String value) {
    setState(() {
      filteredItems = allItems
          .where(
            (item) => item.commodity.toLowerCase().contains(
          value.toLowerCase(),
        ),
      )
          .toList();
    });
  }

  String getEmoji(String name) {
    name = name.toLowerCase();

    if (name.contains('tomato')) {
      return '🍅';
    }
    if (name.contains('onion')) {
      return '🧅';
    }
    if (name.contains('potato')) {
      return '🥔';
    }
    if (name.contains('banana')) {
      return '🍌';
    }
    if (name.contains('mango')) {
      return '🥭';
    }
    if (name.contains('apple')) {
      return '🍎';
    }
    if (name.contains('chilli')) {
      return '🌶';
    }
    if (name.contains('cabbage')) {
      return '🥬';
    }

    return '🌿';
  }

  String getCategory(String commodity) {
    commodity = commodity.toLowerCase();

    if (commodity.contains('tomato') ||
        commodity.contains('onion') ||
        commodity.contains('potato') ||
        commodity.contains('chilli') ||
        commodity.contains('cabbage') ||
        commodity.contains('carrot') ||
        commodity.contains('brinjal')) {
      return 'Vegetables';
    }

    if (commodity.contains('banana') ||
        commodity.contains('mango') ||
        commodity.contains('apple') ||
        commodity.contains('orange') ||
        commodity.contains('papaya')) {
      return 'Fruits';
    }

    return 'Grains';
  }

  Widget categoryChip(
      String title,
      IconData icon,
      ) {
    final selected = selectedCategory == title;

    return ChoiceChip(
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(title),
        ],
      ),
      onSelected: (_) {
        setState(() {
          selectedCategory = title;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFF5),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                accountName: const Text(
                  "Manikandan",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text("Farmer"),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.green,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Country",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedCountry,
                  decoration: const InputDecoration(
                    labelText: "Select Country",
                    prefixIcon: Icon(Icons.flag),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Select Country',
                      child: Text('Select Country'),
                    ),
                    DropdownMenuItem(
                      value: 'India',
                      child: Text('India'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value!;
                      showMarketData = false;
                    });
                  },
                ),
              ),
              const Divider(),

              // STATE DROPDOWN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedState,
                  decoration: const InputDecoration(
                    labelText: "Select State",
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'All States',
                      child: Text('All States'),
                    ),
                    ...states.map(
                          (state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;

                      districts = allItems
                          .where(
                            (e) =>

                        e.state == selectedState,
                      )
                          .map((e) => e.district)
                          .toSet()
                          .toList();

                      districts.sort();
                      selectedDistrict = 'All Districts';
                    });

                    // close drawer
                  },
                ),
              ),
              const SizedBox(height: 20),

              // DISTRICT DROPDOWN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  value: selectedDistrict,
                  decoration: const InputDecoration(
                    labelText: "Select District",
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'All Districts',
                      child: Text('All Districts'),
                    ),
                    ...districts.map(
                          (district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedDistrict = value!;
                      showMarketData = false;
                    });


                  },
                ),
              ),
              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    if (selectedCountry != 'Select Country' &&
                        selectedState != 'All States' &&
                        selectedDistrict != 'All Districts') {
                      setState(() {
                        showMarketData = true;
                      });

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select Country, State and District',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    categoryChip(
                      'All',
                      Icons.apps,
                    ),
                    categoryChip(
                      'Vegetables',
                      Icons.eco,
                    ),
                    categoryChip(
                      'Fruits',
                      Icons.apple,
                    ),
                    categoryChip(
                      'Grains',
                      Icons.grass,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Market Prices',
          style: TextStyle(

            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Price alerts coming soon!",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFE8F5E9),
                Color(0xFFC8E6C9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder<List<MarketItem>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              }

              if (!showMarketData) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 80,
                        color: Colors.green,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Please select Country, State and District\nand press Proceed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              List<MarketItem> displayItems = filteredItems.where((item) {
                final categoryMatch = selectedCategory == 'All' ||
                    getCategory(item.commodity) == selectedCategory;

                final stateMatch = selectedState == 'All States' ||
                    item.state == selectedState;

                final districtMatch = selectedDistrict == 'All Districts' ||
                    item.district == selectedDistrict;


                return categoryMatch && stateMatch && districtMatch;
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  loadData();
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// CATEGORY CHIPS
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: searchItem,
                                    decoration: const InputDecoration(
                                      hintText: "Search commodity...",
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.green,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                "Today's Prices",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),

                              const SizedBox(height: 20),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayItems.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: 0.68,
                                ),
                                itemBuilder: (context, index) {
                                  final item = displayItems[index];

                                  return Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                getEmoji(item.commodity),
                                                style: const TextStyle(
                                                  fontSize: 28,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  favourites.contains(item.commodity)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: favourites.contains(
                                                      item.commodity)
                                                      ? Colors.red
                                                      : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (favourites.contains(
                                                        item.commodity)) {
                                                      favourites.remove(
                                                          item.commodity);
                                                    } else {
                                                      favourites.add(
                                                          item.commodity);
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          Text(
                                            item.commodity,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '₹${item.modalPrice}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  item.market,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${item.district}, ${item.state}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            item.arrivalDate,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}