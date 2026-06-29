import 'package:flutter/material.dart';

import '../../models/govern/scheme_model.dart';

class SchemeCard extends StatelessWidget {

  final SchemeModel scheme;
  final VoidCallback onTap;

  const SchemeCard({
    super.key,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Card(

        elevation: 4,

        margin: const EdgeInsets.only(
          bottom: 15,
        ),

        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Padding(

          padding: const EdgeInsets.all(18),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                scheme.schemeName,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                scheme.category,
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                scheme.description,
              ),

              const SizedBox(height: 10),

              Text(
                "Benefit: ${scheme.benefit}",
              ),

              Text(
                "Eligibility: ${scheme.eligibility}",
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: onTap,
                child: const Text(
                  "View Details",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}