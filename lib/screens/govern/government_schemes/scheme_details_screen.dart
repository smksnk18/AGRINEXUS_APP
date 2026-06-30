import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/../models/govern/scheme_model.dart';

class SchemeDetailsScreen extends StatelessWidget {

  final SchemeModel scheme;

  const SchemeDetailsScreen({
    super.key,
    required this.scheme,
  });

  Future<void> openWebsite() async {

    final Uri url = Uri.parse(
      scheme.website,
    );

    if (await canLaunchUrl(url)) {

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    } else {

      throw 'Could not launch URL';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.green,

        title: Text(
          scheme.schemeName,
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              scheme.schemeName,

              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              scheme.description,
            ),

            const SizedBox(height: 20),

            Text(
              "Benefit: ${scheme.benefit}",
            ),

            const SizedBox(height: 10),

            Text(
              "Eligibility: ${scheme.eligibility}",
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.green,

                  foregroundColor:
                  Colors.white,

                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                ),

                onPressed: openWebsite,

                child: const Text(

                  "Apply Now",

                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}