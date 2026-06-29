// lib/widgets/rating_widget.dart

import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;

  const RatingWidget({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.orange,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}