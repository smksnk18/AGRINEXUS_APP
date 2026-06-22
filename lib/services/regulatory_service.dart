class RegulatoryService {

  static Future<String> getRegulatoryInfo(
      String ingredient) async {

    ingredient =
        ingredient.toLowerCase();

    if (
    ingredient.contains("tbhq") ||
        ingredient.contains("e319")
    ) {

      return """
FDA:
Approved antioxidant.

WHO:
ADI = 0.7 mg/kg body weight/day.

EFSA:
Permitted within regulatory limits.

Long-term excessive intake should be avoided.
""";

    }

    if (
    ingredient.contains("bha")
    ) {

      return """
WHO:
Possible carcinogenic concern.

IARC:
Group 2B possible carcinogen.

Use in moderation.
""";

    }

    if (
    ingredient.contains("bht")
    ) {

      return """
WHO:
Permitted antioxidant.

Long-term excessive intake should be minimized.
""";

    }

    if (
    ingredient.contains("aspartame")
    ) {

      return """
WHO:
ADI = 40 mg/kg body weight/day.

IARC:
Group 2B possible carcinogen.

Moderate consumption recommended.
""";

    }

    return "";

  }

}