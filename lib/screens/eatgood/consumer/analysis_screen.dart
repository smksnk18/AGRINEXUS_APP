import 'package:flutter/material.dart';
import '../../../models/analysis_result_model.dart';
import '../../../services/analysis_service.dart';
import '../../../models/eatgood_product_model.dart';
import '../../../services/chemical_api_service.dart';
import '../../../services/pubmed_service.dart';


class AnalysisScreen extends StatefulWidget {

  final EatGoodProduct product;

  const AnalysisScreen({
    super.key,
    required this.product,
  });
  @override
  State<AnalysisScreen> createState() =>
      _AnalysisScreenState();

}
class _AnalysisScreenState
    extends State<AnalysisScreen> {


  bool isLoading = true;

  late AnalysisResult result;

  @override
  void initState() {

    super.initState();

    loadAnalysis();

  }
  Future<void> loadAnalysis() async {

    result =
    await AnalysisService.analyze(
        widget.product);
    String evidence =
    await PubMedService.getEvidence(
        "TBHQ");

    print(evidence);


    setState(() {

      isLoading = false;

    });

  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Analysis screen opened");
    debugPrint(widget.product.productName);

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Analyzing ${widget.product.productName}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Checking ingredients...\nConsulting scientific databases...\nGenerating recommendations...",
                textAlign:
                TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Color scoreColor;

    switch (result.status) {
      case "Safe":
        scoreColor = Colors.green;
        break;

      case "Moderate":
        scoreColor = Colors.orange;
        break;

      case "Unhealthy":
        scoreColor = Colors.deepOrange;
        break;

      default:
        scoreColor = Colors.red;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Analysis",
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.teal,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(
              widget.product.productName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),


            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [

                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: result.score / 10,
                      strokeWidth: 12,
                      color: scoreColor,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        "${result.score.toStringAsFixed(1)}/10",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        result.status,
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.local_fire_department),
                      title: const Text("Calories"),
                      trailing: Text("${widget.product.calories} kcal"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.cake),
                      title: const Text("Sugar"),
                      trailing: Text("${widget.product.sugar} g"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.water_drop),
                      title: const Text("Fat"),
                      trailing: Text("${widget.product.fat} g"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: const Text("Protein"),
                      trailing: Text("${widget.product.protein} g"),
                    ),

                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: const Text("Sodium"),
                      trailing: Text("${widget.product.sodium} mg"),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Unsafe Ingredients",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Wrap(
                      spacing: 8,
                      children:
                      result.unsafeIngredients
                          .map(
                            (ingredient) => Chip(
                          label:
                          Text(ingredient),
                          backgroundColor:
                          Colors.red.shade100,
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.orange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Possible Effects",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    for (var effect in result.effects)
                      ListTile(
                        leading: const Icon(
                          Icons.warning_amber,
                          color: Colors.orange,
                        ),
                        title: Text(effect),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.green.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),

                title: const Text(
                  "Recommendation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  result.recommendation,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.blue.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: ListTile(
                leading: const Icon(
                  Icons.monitor_weight,
                  color: Colors.blue,
                ),

                title: const Text(
                  "Allowed Quantity",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  result.allowedAmount,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.orange.shade50,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Row(
                      children: [

                        Icon(
                          Icons.psychology,
                          color: Colors.orange,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "AI Nutrition Expert",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      result.explanation,
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
      ),
      );
  }
}