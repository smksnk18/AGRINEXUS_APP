import '../models/analysis_result_model.dart';
import '../models/eatgood_product_model.dart';
import '../services/health_profile_service.dart';
import '../services/ingredient_info_service.dart';
import '../models/ingredient_info_model.dart';
import 'dart:convert';
import 'gemini_service.dart';
import 'chemical_api_service.dart';
import 'regulatory_service.dart';

class AnalysisService {
  static Future<AnalysisResult> analyze(
      EatGoodProduct product) async {
    double ingredientScore = 10;
    double nutritionScore = 10;
    double compatibilityScore = 10;
    Set<String> unsafeIngredients = {};
    Set<String> effects = {};
    Set<String> reasons = {};
    for (String ingredient in product.ingredients) {

      String ingredientName =
      ingredient.toLowerCase();

      for (
      IngredientInfo info
      in IngredientInfoService
          .ingredientDatabase
          .values
      )
      {
        bool matches = false;

        for (
        String alias
        in info.aliases
        )
        {

          if (
          ingredientName.contains(
              alias
          )
          )
          {

            matches = true;

            break;

          }

        }

        if (!matches)
        {

          continue;

        }

        Map<String, bool> profileConditions = {

          "Diabetes":
          HealthProfileService.profile.diabetes,

          "Heart Disease":
          HealthProfileService.profile.heartDisease,

          "Hypertension":
          HealthProfileService.profile.hypertension,

          "Kidney Disease":
          HealthProfileService.profile.kidneyDisease,

          "Obesity":
          HealthProfileService.profile.obesity,

          "Pregnancy":
          HealthProfileService.profile.pregnancy,

          "Milk Allergy":
          HealthProfileService.profile.milkAllergy,

          "Peanut Allergy":
          HealthProfileService.profile.peanutAllergy,

          "Egg Allergy":
          HealthProfileService.profile.eggAllergy,

          "Shellfish Allergy":
          HealthProfileService.profile.shellfishAllergy,

        };

        bool shouldWarn = false;

        for (
        String condition
        in info.riskyConditions
        )
        {

          if (
          profileConditions[
          condition
          ] == true
          )
          {

            shouldWarn = true;

            break;

          }

        }

        if (shouldWarn)
        {

          ingredientScore -=
              info.scorePenalty * 0.5;

          unsafeIngredients.add(
              ingredient);

          effects.add(
              info.effect);

          reasons.add(
              info.explanation);

        }

      }

    }

    String recommendation =
        "Safe to consume.";
    String status = "Safe";

    if (
    HealthProfileService.profile.diabetes &&
        product.sugar > 20
    ) {
      nutritionScore -= 3;
      compatibilityScore -= 1;
      effects.add(
        "High blood sugar spike",
      );
      reasons.add(
        "High sugar content may cause blood sugar spikes in diabetic patients.",
      );
    }



    if (
    HealthProfileService.profile.hypertension &&
        product.sodium > 500
    ) {
      nutritionScore -= 2;
      compatibilityScore -= 2;
      effects.add(
        "Increased blood pressure",
      );
      reasons.add(
        "High sodium intake may elevate blood pressure.",
      );
    }

    if (
    HealthProfileService.profile.kidneyDisease &&
        product.sodium > 300
    ) {
      nutritionScore -= 2;
      compatibilityScore -= 2;
      effects.add(
        "Kidney stress",
      );
      reasons.add(
        "Excess sodium may place additional stress on the kidneys.",
      );
    }

    if (
    HealthProfileService.profile.heartDisease &&
        product.fat > 20
    ) {
      nutritionScore -= 2;
      compatibilityScore -= 1;

      effects.add(
        "Cardiovascular strain",
      );

      reasons.add(
        "High fat content may increase cardiovascular stress.",
      );
    }

    if (
    HealthProfileService.profile.obesity &&
        product.calories > 400
    ) {
      nutritionScore -= 3;
      effects.add(
        "Excess calorie intake",
      );
      reasons.add(
        "High calorie content may contribute to weight gain.",
      );
    }

    if (
    HealthProfileService.profile.pregnancy &&
        product.sodium > 700
    ) {
      compatibilityScore -= 2;
      effects.add(
        "Fluid retention risk",
      );
      reasons.add(
        "Excess sodium may increase fluid retention during pregnancy.",
      );
    }

    print("ingredientScore = $ingredientScore");
    print("nutritionScore = $nutritionScore");
    print("compatibilityScore = $compatibilityScore");

    print("Diabetes = ${HealthProfileService.profile.diabetes}");
    print("Hypertension = ${HealthProfileService.profile.hypertension}");
    print("Heart Disease = ${HealthProfileService.profile.heartDisease}");
    print("Obesity = ${HealthProfileService.profile.obesity}");
    print("Pregnancy = ${HealthProfileService.profile.pregnancy}");

    double score =

        0.3 * ingredientScore +

            0.4 * nutritionScore +

            0.3 * compatibilityScore;

    score =
        score.clamp(
          0,
          10,
        );

    if (score <= 3) {
      status = "Dangerous";
      recommendation =
      "Avoid consumption.";
    }
    else if (score <= 7) {
      status = "Moderate";
      recommendation =
      "Consume in limited quantity.";
    }
    else {
      status = "Safe";
    }

    String explanation;
    if (score >= 8) {
      explanation =
      "This product appears safe based on your health profile. No major risk factors were detected.";
    }

    else {
      explanation =
          reasons.join(" ");
    }
    String chemicalInformation = "";
    String regulatoryInformation = "";

    for (

    String ingredient
    in product.ingredients

    ) {

      String info =

      await ChemicalApiService
          .getChemicalInfo(
          ingredient);

      chemicalInformation +=

      "\n$ingredient:\n$info\n";

      regulatoryInformation +=

      await RegulatoryService
          .getRegulatoryInfo(
          ingredient);

    }
    final aiResponse =
    await GeminiService.generateFullAnalysis(

      productName:
      product.productName,

      ingredients:
      product.ingredients,

      calories:
      product.calories,

      sugar:
      product.sugar,

      fat:
      product.fat,

      protein:
      product.protein,

      sodium:
      product.sodium,

      chemicalInformation:
      chemicalInformation,

      regulatoryInformation:
      regulatoryInformation,

      healthConditions: [

        if (HealthProfileService.profile.diabetes)
          "Diabetes",

        if (HealthProfileService.profile.heartDisease)
          "Heart Disease",

        if (HealthProfileService.profile.hypertension)
          "Hypertension",

        if (HealthProfileService.profile.kidneyDisease)
          "Kidney Disease",

        if (HealthProfileService.profile.obesity)
          "Obesity",

        if (HealthProfileService.profile.pregnancy)
          "Pregnancy",

        if (HealthProfileService.profile.milkAllergy)
          "Milk Allergy",

        if (HealthProfileService.profile.peanutAllergy)
          "Peanut Allergy",

        if (HealthProfileService.profile.eggAllergy)
          "Egg Allergy",

        if (HealthProfileService.profile.shellfishAllergy)
          "Shellfish Allergy",

      ],

    );

    dynamic json;

    try {

      json =
          jsonDecode(
              aiResponse);

    }

    catch (e) {

      print(
          "JSON ERROR");

      print(
          aiResponse);

      return AnalysisResult(

        score: 0,

        status: "Error",
        hazardLevel: "NORMAL",

        unsafeIngredients: [],

        effects: [],

        reasons: [],

        allowedAmount: "",

        recommendation:
        "AI analysis failed.",

        explanation:
        aiResponse,

      );

    }




    recommendation =
        (json["recommendation"] ?? "")
            .toString()
            .trim();
    String hazardLevel =
    (json["hazardLevel"] ?? "NORMAL")
        .toString()
        .trim();
    status = "";



    if (recommendation.isEmpty) {

      if (score <= 2) {

        recommendation =
        "Avoid consumption.";

      }

      else if (score <= 4) {

        recommendation =
        "Consume only rarely.";

      }

      else if (score <= 6) {

        recommendation =
        "Consume in moderation.";

      }

      else {

        recommendation =
        "Safe to consume.";

      }

    }
    switch (hazardLevel) {

      case "SUSPICIOUS":

        if (score > 6) {

          score = 6;

        }

        break;

      case "HARMFUL":

        if (score > 4) {

          score = 4;

        }

        break;

      case "TOXIC":

        score = 1;

        recommendation =
        "Avoid consumption completely.";

        status =
        "Dangerous";

        break;

    }
    if (score <= 2) {

      status = "Dangerous";

    }

    else if (score <= 4) {

      status = "Unhealthy";

    }

    else if (score <= 6) {

      status = "Moderate";

    }

    else {

      status = "Safe";

    }
    List<String> finalEffects =
    List<String>.from(
        json["effects"]);

    if (finalEffects.isEmpty) {

      if (score <= 2) {

        finalEffects.add(
            "Severe health risk");

      }

      else if (score <= 4) {

        finalEffects.add(
            "Potential adverse effects");

      }

      else if (score <= 6) {

        finalEffects.add(
            "Consume in moderation");

      }

    }

    return AnalysisResult(

      score: score,

      status:
      (status)
          .toString(),
      hazardLevel: hazardLevel,

      unsafeIngredients:
      List<String>.from(
          json["unsafeIngredients"] ?? []),

      effects: finalEffects,

      reasons:
      reasons.toList(),

      recommendation:
      (recommendation)
          .toString(),

      allowedAmount:
      (json["allowedAmount"] == null ||
          json["allowedAmount"].toString().trim().isEmpty)
          ? "Not specified"
          : json["allowedAmount"],

      explanation:
      (json["why"] ??
          json["Why"] ??
          "")
          .toString(),

    );

  }

}