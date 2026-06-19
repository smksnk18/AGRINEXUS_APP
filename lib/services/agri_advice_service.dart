class AgriAdviceService {

  static String getIrrigationAdvice({
    required int humidity,
    required double temperature,
    required bool rainExpected,
  }) {

    if (rainExpected) {
      return "Delay irrigation for the next 24 hours.";
    }

    if (temperature > 35) {
      return "Increase irrigation frequency.";
    }

    if (humidity < 50) {
      return "Field moisture may reduce rapidly.";
    }

    return "Current irrigation level is sufficient.";
  }

  static String getDiseaseRisk({
    required int humidity,
    required double temperature,
  }) {

    if (
    humidity > 80 &&
        temperature >= 25 &&
        temperature <= 32
    ) {
      return "Medium Blast Risk";
    }

    if (
    humidity > 90 &&
        temperature >= 25 &&
        temperature <= 30
    ) {
      return "High Disease Risk";
    }

    return "Low Disease Risk";
  }
}