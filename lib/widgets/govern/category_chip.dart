import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {

  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: const EdgeInsets.only(
          right: 10,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: selected
              ? Colors.green
              : Colors.white,

          borderRadius:
          BorderRadius.circular(30),

          border: Border.all(
            color: Colors.green,
          ),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.green,
          ),
        ),
      ),
    );
  }
}