import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {

  static const String apiKey =
      "d874936bda4a7d689adfcca61e20624c";

  Future<WeatherModel> getWeather(
      double lat,
      double lon) async {

    final weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather"
        "?lat=$lat"
        "&lon=$lon"
        "&units=metric"
        "&appid=$apiKey";

    final response =
    await http.get(Uri.parse(weatherUrl));

    final data =
    jsonDecode(response.body);

    final location =
        data["name"] ?? "Unknown";

    return WeatherModel.fromJson(
      data,
      location,
    );

  }
  Future<double> getUVIndex(
      double lat,
      double lon,
      ) async {

    final url =
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$lat"
        "&longitude=$lon"
        "&current=uv_index";

    final response =
    await http.get(Uri.parse(url));

    final data =
    jsonDecode(response.body);

    return (data["current"]
    ["uv_index"] ?? 0)
        .toDouble();
  }
  Future<List<ForecastModel>> getRainForecast(
      double lat,
      double lon,
      ) async {

    final forecastUrl =
        "https://api.openweathermap.org/data/2.5/forecast"
        "?lat=$lat"
        "&lon=$lon"
        "&units=metric"
        "&appid=$apiKey";

    final response =
    await http.get(Uri.parse(forecastUrl));

    final data =
    jsonDecode(response.body);

    final List forecasts =
        data["list"] ?? [];

    List<ForecastModel> forecastList = [];

    for (int i = 0;
    i < forecasts.length &&
        forecastList.length < 6;
    i++) {

      final item = forecasts[i];

      final probability =
      ((item["pop"] ?? 0) * 100)
          .toDouble();

      forecastList.add(
        ForecastModel(
          time: item["dt_txt"] ?? "",
          rainChance: probability,
        ),
      );
    }

    return forecastList;
  }
}