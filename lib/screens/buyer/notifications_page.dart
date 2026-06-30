// lib/screens/notifications_page.dart

import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Notifications"),
      ),

      body: ListView(

        children: const [

          ListTile(
            leading: Icon(
              Icons.local_offer,
              color: Colors.green,
            ),

            title: Text(
              "20% OFF on Organic Vegetables",
            ),

            subtitle: Text(
              "Today Only",
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),

            title: Text(
              "Tomatoes added to cart",
            ),

            subtitle: Text(
              "2 mins ago",
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.local_shipping,
              color: Colors.blue,
            ),

            title: Text(
              "Order Delivered Successfully",
            ),

            subtitle: Text(
              "Yesterday",
            ),
          ),
        ],
      ),
    );
  }
}