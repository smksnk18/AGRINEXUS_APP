import 'package:flutter/material.dart';

class AgriCard extends StatelessWidget {

  final Widget child;

  const AgriCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: child,
    );
  }
}