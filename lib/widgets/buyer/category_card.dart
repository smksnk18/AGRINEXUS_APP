import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {

  final IconData icon;
  final String title;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 100,

      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 35,
            color: Colors.green,
          ),

          const SizedBox(height: 10),

          Text(
            title,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}