class WeatherModel {
  final String location;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String icon;

  final int humidity;
  final double windSpeed;
  final int cloudCover;
  final double visibility;

  final int soilMoisture;
  final int uvIndex;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.cloudCover,
    required this.visibility,
    required this.soilMoisture,
    required this.uvIndex,
  });

  factory WeatherModel.fromJson(
      Map<String, dynamic> weather,
      String location,
      ) {
    final humidity = weather["main"]["humidity"] ?? 0;

    return WeatherModel(
      location: location,
      temperature: weather["main"]["temp"].toDouble(),
      feelsLike: weather["main"]["feels_like"].toDouble(),
      condition: weather["weather"][0]["description"],
      icon: weather["weather"][0]["icon"],
      humidity: humidity,
      windSpeed: weather["wind"]["speed"].toDouble(),
      cloudCover: weather["clouds"]["all"] ?? 0,
      visibility:
      (weather["visibility"] ?? 0) / 1000,

      soilMoisture:
      ((humidity * 0.6) + 20).round(),

      uvIndex: 2,
    );
  }
}