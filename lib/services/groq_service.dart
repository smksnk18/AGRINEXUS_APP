import 'dart:convert';
import 'package:http/http.dart' as http;

class GroqService {

  static const apiKey = "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";

  Future<String> predictDisease({
    required String variety,
    required double temperature,
    required int humidity,
    required String growthStage,
  }) async {

    final response = await http.post(
      Uri.parse(
        "https://api.groq.com/openai/v1/chat/completions",
      ),
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "system",
            "content":
                "You are an agricultural disease expert."
          },
          {
            "role": "user",
            "content": """
You are an agricultural disease prediction expert.

Crop: Paddy
Variety: $variety
Temperature: $temperature°C
Humidity: $humidity%
Growth Stage: $growthStage

Return ONLY in the format below:

Disease Name:
Risk Level:

Reason:

Symptoms:
- item
- item

Prevention:
- item
- item
- item

Predict the 3 most likely diseases.
Keep the response concise.
Do not use markdown.
Do not use ** symbols.
"""
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Groq Error: ${response.body}",
      );
    }

    final data = jsonDecode(response.body);

    return data["choices"][0]["message"]["content"]
        .toString();
  }
}