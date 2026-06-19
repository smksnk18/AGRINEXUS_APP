import 'package:flutter/material.dart';

import '../../models/weather_model.dart';
import '../../services/location_service.dart';
import '../../services/weather_service.dart';

import '../../widgets/weather/weather_hero_card.dart';
import '../../widgets/weather/soil_moisture_card.dart';
import '../../widgets/weather/farming_advice_card.dart';
import '../../widgets/weather/precipitation_card.dart';
import '../../widgets/weather/weather_factors_card.dart';
import '../../widgets/weather/weather_metrics_grid.dart';
import '../../widgets/weather/crop_vulnerability_card.dart';
import '../../models/forecast_model.dart';
import '../../widgets/weather/irrigation_card.dart';
import '../../widgets/weather/weather_alert_card.dart';
import 'package:provider/provider.dart';
import '../../paddy_guide_controller.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherModel? weather;
  List<ForecastModel> rainForecast = [];
  String selectedCrop = "Paddy";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {

      final position =
      await LocationService()
          .getCurrentLocation();

      final data =
      await WeatherService()
          .getWeather(
        position.latitude,
        position.longitude,
      );
      final paddyController =
      Provider.of<PaddyGuideController>(
        context,
        listen: false,
      );

      await paddyController.loadDiseaseRisk(
        data.temperature,
        data.humidity,
      );

      final rainData =
      await WeatherService()
          .getRainForecast(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weather = data;
        rainForecast = rainData;
        loading = false;
      });

    } catch (e) {

      setState(() {
        errorMessage = e.toString();
        loading = false;
      });
    }
  }
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [

              const Icon(
                Icons.location_off,
                size: 60,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: loadWeather,
                child: const Text(
                  "Try Again",
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (weather == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Unable to load weather",
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 420,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.stretch,
              children: [

                /// Hero Section
                WeatherHeroCard(
                  weather: weather!,
                ),

                const SizedBox(height: 16),

                WeatherAlertCard(
                  humidity: weather!.humidity,
                  windSpeed: weather!.windSpeed,
                  rainForecast: rainForecast,
                ),

                /// Soil Moisture
                SoilMoistureCard(
                  moisture: weather!.soilMoisture,
                ),
                IrrigationCard(
                  soilMoisture:
                  weather!.soilMoisture,
                  rainForecast:
                  rainForecast,
                ),

                const SizedBox(height: 16),

                /// Farming Advice
                FarmingAdviceCard(
                  temperature:
                  weather!.temperature,
                  humidity:
                  weather!.humidity,
                  windSpeed:
                  weather!.windSpeed,
                  rainForecast:
                  rainForecast,
                ),

                const SizedBox(height: 16),

                /// Rain Forecast
                PrecipitationCard(
                  forecast: rainForecast,
                ),

                const SizedBox(height: 16),

                /// Weather Factors
                WeatherFactorsCard(
                  humidity: weather!.humidity,
                  cloudCover: weather!.cloudCover,
                ),

                const SizedBox(height: 16),

                /// Metrics Grid
                WeatherMetricsGrid(
                  windSpeed: weather!.windSpeed,
                  humidity: weather!.humidity,
                  uvIndex: weather!.uvIndex,
                  visibility: weather!.visibility,
                ),

                const SizedBox(height: 16),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: selectedCrop,

                  decoration: InputDecoration(
                    labelText: "Select Crop",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "Paddy",
                      child: Text("🌾 Paddy"),
                    ),

                    DropdownMenuItem(
                      value: "Cotton",
                      child: Text("🧶 Cotton"),
                    ),

                    DropdownMenuItem(
                      value: "Banana",
                      child: Text("🍌 Banana"),
                    ),

                    DropdownMenuItem(
                      value: "Coconut",
                      child: Text("🥥 Coconut"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      selectedCrop = value!;
                    });
                  },
                ),

                /// Crop Vulnerability
                CropVulnerabilityCard(
                  crop: selectedCrop,
                  temperature: weather!.temperature,
                  humidity: weather!.humidity,
                  windSpeed: weather!.windSpeed,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}