import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final IconData icon;

  const DetailPage({
    super.key,
    required this.title,
    required this.colors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: title,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                colors: colors,
              ),
            ),
            child: Icon(
              icon,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}