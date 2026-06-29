// lib/screens/profile_page.dart

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Profile"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Kevin Mark",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Buyer Account",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 30),

            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Chennai, Tamil Nadu"),
            ),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text("+91 9876543210"),
            ),

            ListTile(
              leading: Icon(Icons.email),
              title: Text("buyer@gmail.com"),
            ),
          ],
        ),
      ),
    );
  }
}