import 'package:flutter/material.dart';

import '/../models/govern/scheme_model.dart';
import '/../services/govern/scheme_service.dart';
import '/../widgets/govern/category_chip.dart';
import '/../widgets/govern/scheme_card.dart';

import '../../govern/government_schemes/scheme_details_screen.dart';

class GovernmentSchemesScreen
    extends StatefulWidget {

  const GovernmentSchemesScreen({
    super.key,
  });

  @override
  State<GovernmentSchemesScreen>
  createState() =>
      _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState
    extends State<GovernmentSchemesScreen> {

  final SchemeService service =
  SchemeService();

  List<SchemeModel> schemes = [];

  List<SchemeModel> filteredSchemes =
  [];

  String selectedCategory = "All";

  final List<String> categories = [
    "All",
    "Income Support",
    "Insurance",
    "Loan"
  ];

  @override
  void initState() {
    super.initState();

    loadSchemes();
  }

  Future<void> loadSchemes() async {

    schemes =
    await service.getSchemes();

    filteredSchemes = schemes;

    setState(() {});
  }

  void filterCategory(String category) {

    selectedCategory = category;

    if (category == "All") {

      filteredSchemes = schemes;

    } else {

      filteredSchemes =
          schemes.where((scheme) {

            return scheme.category ==
                category;

          }).toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Government Schemes",
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(15),

        child: Column(

          children: [

            TextField(

              decoration: InputDecoration(

                hintText:
                "Search schemes",

                prefixIcon:
                const Icon(Icons.search),

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),
              ),

              onChanged: (value) {

                filteredSchemes =
                    schemes.where((scheme) {

                      return scheme
                          .schemeName
                          .toLowerCase()
                          .contains(
                        value.toLowerCase(),
                      );

                    }).toList();

                setState(() {});
              },
            ),

            const SizedBox(height: 15),

            SizedBox(

              height: 45,

              child: ListView.builder(

                scrollDirection:
                Axis.horizontal,

                itemCount:
                categories.length,

                itemBuilder:
                    (context, index) {

                  return CategoryChip(

                    title:
                    categories[index],

                    selected:
                    selectedCategory ==
                        categories[index],

                    onTap: () {

                      filterCategory(
                        categories[index],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            Expanded(

              child: ListView.builder(

                itemCount:
                filteredSchemes.length,

                itemBuilder:
                    (context, index) {

                  final scheme =
                  filteredSchemes[index];

                  return SchemeCard(

                    scheme: scheme,

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              SchemeDetailsScreen(
                                scheme: scheme,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}