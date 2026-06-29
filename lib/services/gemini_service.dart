import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {

  static String get apiKey =>
      dotenv.env["GROQ_API_KEY"] ?? "";

  static Future<String> generateExplanation({

    required String productName,

    required List<String> ingredients,

    required double calories,
    required double sugar,
    required double fat,
    required double protein,
    required double sodium,

    required List<String> healthConditions,

    required List<String> reasons,
    required List<String> effects,

    required String recommendation,

  }) async {

    try {

      String prompt = """
You are an intelligent food health assistant.

Product Name:
$productName

Ingredients:
${ingredients.join(", ")}

Nutritional Information:
Calories: $calories
Sugar: $sugar g
Fat: $fat g
Protein: $protein g
Sodium: $sodium mg

User Health Conditions:
${healthConditions.isEmpty ? "None" : healthConditions.join(", ")}

Detected Effects:
${effects.join(", ")}

Reasons:
${reasons.join("\n")}

Recommendation:
$recommendation

Explain in simple language.

Mention why the product is safe or unsafe for the user's health conditions.

Do not diagnose diseases.

Keep the explanation below 150 words.
""";

      final response = await http.post(

        Uri.parse(
          "https://api.groq.com/openai/v1/chat/completions",
        ),

        headers: {

          "Authorization":
          "Bearer $apiKey",

          "Content-Type":
          "application/json",

        },

        body: jsonEncode({

          "model":
          "llama-3.3-70b-versatile",

          "messages": [

            {

              "role":
              "user",

              "content":
              prompt,

            }

          ]

        }),

      );

      print(
        "STATUS = ${response.statusCode}",
      );

      print(
        response.body,
      );

      final data =
      jsonDecode(
        response.body,
      );

      if (
      response.statusCode != 200
      )
      {

        return data["error"]["message"];

      }

      return data["choices"][0]
      ["message"]["content"];

    }

    catch (e) {

      print(
        e.toString(),
      );

      return "AI explanation unavailable.";

    }

  }

  static Future<String> identifyIngredient(
      String ingredient,
      ) async {

    String prompt = """
Identify this food ingredient.

Ingredient:

$ingredient

Return only:

1. English name.
2. Main category.

Examples:

sirop de glucose
glucose syrup
Sugar

lait
milk
Dairy

œufs
egg
Egg

Return only two lines.
""";

    final response = await http.post(

      Uri.parse(
        "https://api.groq.com/openai/v1/chat/completions",
      ),

      headers: {

        "Authorization":
        "Bearer $apiKey",

        "Content-Type":
        "application/json",

      },

      body: jsonEncode({

        "model":
        "llama-3.3-70b-versatile",

        "messages": [

          {

            "role":
            "user",

            "content":
            prompt,

          }

        ]

      }),

    );

    final data =
    jsonDecode(
      response.body,
    );

    return data["choices"][0]
    ["message"]["content"];

  }

static Future<String> generateFullAnalysis({
required String productName,
required List<String> ingredients,
required double calories,
required double sugar,
required double fat,
required double protein,
required double sodium,
required List<String> healthConditions,
  required String chemicalInformation,
  required String regulatoryInformation,
}) async {
  String prompt = """
Analyze this food product.

Product name:
$productName

Ingredients:
${ingredients.join(", ")}
Chemical Information From PubChem:
$chemicalInformation
Regulatory Information:
$regulatoryInformation

Calories: $calories
Sugar: $sugar g
Fat: $fat g
Protein: $protein g
Sodium: $sodium mg

User health conditions:
${healthConditions.isEmpty ? "None" : healthConditions.join(", ")}
Assume the user has NO diseases or allergies other than those explicitly listed.

Do not mention risks related to diseases or allergies that are absent.

For healthy individuals, normal foods should generally be classified as Safe or Moderate.

Reserve Dangerous only for:
- toxins
- contamination
- poisonous substances
- extremely unhealthy products

Do not exaggerate hypothetical risks.

Do not invent allergies.

Do not mention milk allergy, peanut allergy, egg allergy, shellfish allergy, diabetes, heart disease, hypertension, kidney disease, obesity or pregnancy unless they are explicitly present in User health conditions.

Return ONLY valid JSON in this format:

{
"hazardLevel":"",
"unsafeIngredients":[],
"effects":[],
"recommendation":"",
"allowedAmount":"",
"why":""
}

hazardLevel must be one of:

NORMAL
SUSPICIOUS
HARMFUL
TOXIC

NORMAL:
ordinary foods.

SUSPICIOUS:
preservatives, additives and ingredients requiring caution.

HARMFUL:
known dangerous chemicals or substances.

TOXIC:
poisons, contaminants, rocks, glass, metal fragments, venom or other severely hazardous substances.

hazardLevel should not depend on calories, sugar, fat or sodium.
It should depend only on ingredient safety and scientific concerns.
unsafeIngredients must contain only exact names that appear in the ingredient list.

Never rename ingredients.

If the ingredient list contains "salt", return "salt", not "sodium chloride".

If the ingredient list contains "sugar", return "sugar", not "sucrose".

If the ingredient list contains "oil", return "oil", not "vegetable fat".

Do not translate or chemically rename ingredients.
VERY IMPORTANT:

unsafeIngredients should contain only ingredients that pose a meaningful health concern for the specific user.

Do not include ordinary foods such as onion, potato, rice, milk, cheese, eggs, oil or ghee unless:

- the quantity is excessive,
- the ingredient is highly processed,
- or it conflicts with a health condition explicitly present in User health conditions.

Healthy individuals should usually have few or no unsafe ingredients.

Only include ingredients that actually appear in the provided ingredient list.

Never invent ingredients.

Do not mention sand, glass, dirt, metal fragments, or contaminants unless they are explicitly present in the ingredient list.

Do not leave unsafeIngredients empty if any concern exists.
Do not leave effects empty.

For every unsafe ingredient,
state at least one health effect.

Examples:

Sand → Digestive injury

Venom → Poisoning

High sugar → Blood sugar spikes

High sodium → Increased blood pressure

High fat → Cardiovascular strain
For suspicious substances,
contaminants, chemicals, preservatives,
or ingredients not usually consumed,
heavily reduce the score.

Reserve scores below 3 only for contamination, poisonous substances or extremely unhealthy products.

Consider:
- sugar level
- fat level
- sodium level
- calories
- allergens
- contamination
- suspicious ingredients
- health conditions

The recommendation field must contain one complete sentence.

The allowedAmount field must contain a specific quantity and frequency.

The status field must never be empty.

Do not classify foods as Dangerous merely because they contain sugar, oil, ghee or cheese.

High sugar and high fat should usually result in Moderate or Unhealthy, not Dangerous.

Do not invent contaminants or ingredients.

Use WHO and general nutrition principles.
Return JSON only.

The "why" field should contain a clear explanation written in natural language.

Requirements:

- Between 80 and 120 words.
- Explain why the product received its score.
- Mention unsafe ingredients and their effects.
- Mention relevant health conditions if applicable.
- Explain whether the product should be avoided or consumed in moderation.
- Sound like advice from a nutrition expert.
- Do not sound robotic.
- Do not make it excessively short.

The recommendation field must never be empty and should contain one complete sentence.

Examples:

"Safe to consume in moderation."

"Limit consumption to occasional servings."

"Avoid consumption due to contamination risks."

VERY IMPORTANT:

allowedAmount MUST NEVER be empty.

allowedAmount must always contain:

1. Quantity
2. Frequency

Never return vague words such as:

"Occasionally"
"Sometimes"
"In moderation"
"As tolerated"

These are INVALID.

The quantity must be adjusted according to BOTH:

- nutritional values
- user health conditions

Examples for healthy people:

Milk:
"200-250 ml daily"

Rice:
"1-2 cups per meal"

Pizza:
"2 slices once a week"

Cake:
"1 slice (80-100 g), twice a week"

Soft drink:
"≤250 ml once or twice a week"

Egg:
"1-2 eggs daily"

Examples when diseases are present:

Diabetes:
High sugar foods:
"50-100 g once a week"

Hypertension:
High sodium foods:
"100 g once a week"

Heart disease:
High fat foods:
"100 g once a week"

Obesity:
High calorie foods:
"50-100 g twice a week"

Pregnancy:
Products containing additives:
"1 serving, once a week"

Severe risk:
"Avoid completely"

If allowedAmount is empty, generate a suitable quantity yourself.

The field must ALWAYS contain a complete answer.
The same product may have different allowedAmount values for different users.

For example:

Healthy person:
"150 g, 3-4 times a week"

Person with diabetes:
"50-100 g once a week"

Person with hypertension:
"100 g once a week"

Person with obesity:
"50-100 g twice a week"

Person with heart disease:
"100 g once a week"

Therefore user health conditions MUST influence allowedAmount.
Do not leave effects empty.

For every unsafe ingredient, provide at least one effect.

Examples:

Sand → Digestive injury

Venom → Poisoning

High sugar → Blood sugar spikes

High sodium → Increased blood pressure

High fat → Cardiovascular strain
""";
  final response = await http.post(

    Uri.parse(
      "https://api.groq.com/openai/v1/chat/completions",
    ),

    headers: {

      "Authorization":
      "Bearer $apiKey",

      "Content-Type":
      "application/json",

    },

    body: jsonEncode({

      "model":
      "llama-3.1-8b-instant",

      "messages": [

        {

          "role":
          "user",

          "content":
          prompt,

        }

      ]
    }),

  );

  print(
    "STATUS = ${response.statusCode}",
  );

  print(
    response.body,
  );
  final data = jsonDecode(response.body);

  if (response.statusCode != 200) {
    return data["error"]["message"];
  }

  String aiResponse =
  data["choices"][0]["message"]["content"];

  print(aiResponse);

  try {

    Map<String, dynamic> json =
    jsonDecode(aiResponse);

    if ((json["allowedAmount"] ?? "")
        .trim()
        .isEmpty) {

      json["allowedAmount"] =
      "Consult a healthcare professional for a suitable serving size.";

    }

    return jsonEncode(json);

  }

  catch (e) {

    print("JSON parse error");
    print(e);

    return aiResponse;

  }

  return jsonEncode(json);
}
}