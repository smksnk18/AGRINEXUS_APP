// lib/paddy_guide_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agrinexus/models/crop_models.dart';

import '../../paddy_guide_controller.dart';
import '../../widgets/crop_guide/variety_profile_card.dart';
import '../../widgets/crop_guide/crop_management_card.dart';
import '../../widgets/crop_guide/weather_advice_card.dart';
import '../../widgets/crop_guide/disease_risk_card.dart';
import '../../services/groq_service.dart';
import '../../services/weather_service.dart';
import '../../services/location_service.dart';
import '../../models/weather_model.dart';


class PaddyGuideScreen extends StatefulWidget {
  const PaddyGuideScreen({
    super.key,
  });

  @override
  State<PaddyGuideScreen> createState() =>
      _PaddyGuideScreenState();
}

class _PaddyGuideScreenState extends State<PaddyGuideScreen> {

  DateTime? plantingDate;
  WeatherModel? weather;
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

      setState(() {
        weather = data;
      });

    } catch (e) {
      debugPrint(
        "Weather Error: $e",
      );
    }
  }

  String? diseasePrediction;

  bool diseaseLoading = false;
  String getGrowthStage(
      DateTime plantingDate,
      ) {

    final days =
        DateTime.now()
            .difference(
          plantingDate,
        )
            .inDays;

    if (days <= 20) {
      return "Nursery";
    }

    if (days <= 45) {
      return "Tillering";
    }

    if (days <= 75) {
      return "Flowering";
    }

    return "Maturity";
  }

  Future<void> loadDiseasePrediction() async {

    final controller =
    Provider.of<PaddyGuideController>(
      context,
      listen: false,
    );

    if (plantingDate == null ||
        controller.selectedVariety == null) {
      return;
    }

    setState(() {
      diseaseLoading = true;
    });

    try {

      final stage =
      getGrowthStage(
        plantingDate!,
      );

      final result =
      await GroqService().predictDisease(
        variety:
        controller.selectedVariety!.name,
        temperature:
        weather?.temperature ?? 30,
        humidity:
        weather?.humidity ?? 80,
        growthStage: stage,
      );

      setState(() {
        diseasePrediction = result;
        diseaseLoading = false;
      });

    } catch (e) {

      setState(() {
        diseasePrediction = e.toString();
        diseaseLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      final controller =
      Provider.of<PaddyGuideController>(
        context,
        listen: false,
      );

      controller.loadInitialStates();
      loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PaddyGuideController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('AGRINEXUS - Paddy Guide'),
        backgroundColor: Colors.green[800],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dynamic Regional Filter Matrix",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                // State Dropdown
                DropdownButtonFormField<LocationEntity>(
                  decoration: InputDecoration(labelText: 'Select State', border: OutlineInputBorder()),
                  value: controller.states.any((s) => s.id == controller.selectedState?.id)
                      ? controller.selectedState
                      : null,
                  items: controller.states.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                  onChanged: controller.selectState,
                ),
                SizedBox(height: 12),

                // District Dropdown
                DropdownButtonFormField<LocationEntity>(
                  decoration: InputDecoration(labelText: 'Select District', border: OutlineInputBorder()),
                  value: controller.districts.any((d) => d.id == controller.selectedDistrict?.id)
                      ? controller.selectedDistrict
                      : null,
                  items: controller.districts.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
                  onChanged: controller.selectedState == null ? null : controller.selectDistrict,
                ),
                SizedBox(height: 12),

                // Taluka Dropdown
                DropdownButtonFormField<LocationEntity>(
                  decoration: InputDecoration(labelText: 'Select Taluka', border: OutlineInputBorder()),
                  value: controller.talukas.any((t) => t.id == controller.selectedTaluka?.id)
                      ? controller.selectedTaluka
                      : null,
                  items: controller.talukas.map((t) => DropdownMenuItem(value: t, child: Text(t.name))).toList(),
                  onChanged: controller.selectedDistrict == null ? null : controller.selectTaluka,
                ),
                SizedBox(height: 12),

                // Variety Dropdown
                DropdownButtonFormField<PaddyVariety>(
                  decoration: InputDecoration(labelText: 'Select Variety', border: OutlineInputBorder()),
                  value: controller.availableVarieties.any(
                          (v) => v.id == controller.selectedVariety?.id)
                      ? controller.selectedVariety
                      : null,
                  items: controller.availableVarieties.map((v) => DropdownMenuItem(value: v, child: Text(v.name))).toList(),
                  onChanged: controller.selectedTaluka == null ? null : controller.selectVariety,
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                    ),
                    title: Text(
                      plantingDate == null
                          ? "Select Planting Date"
                          : "Planting Date: ${plantingDate!.day}/${plantingDate!.month}/${plantingDate!.year}",
                    ),
                    trailing: const Icon(Icons.edit),
                    onTap: () async {

                      final picked =
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                      );

                      if (picked != null) {
                        setState(() {
                          plantingDate = picked;
                        });
                      }
                    },
                  ),
                ),

                if (controller.selectedVariety != null) ...[
                  const SizedBox(height: 24),

                  VarietyProfileCard(
                    variety: controller.selectedVariety!,
                  ),

                  const SizedBox(height: 16),

                  if (plantingDate != null)
                    CropManagementCard(
                      variety: controller.selectedVariety!,
                      plantingDate: plantingDate!,
                    ),
                  const SizedBox(height: 16),

                  WeatherAdviceCard(
                    temperature: weather?.temperature ?? 30,
                    humidity: weather?.humidity ?? 80,
                    rainExpected:
                    (weather?.humidity ?? 80) > 80,
                  ),
                  const SizedBox(height: 16),

                  DiseaseRiskCard(
                    diseases:
                    controller.diseaseRisks,
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed:
                    loadDiseasePrediction,
                    icon: const Icon(
                      Icons.psychology,
                    ),
                    label: const Text(
                      "AI Disease Analysis",
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (diseaseLoading)
                    const Center(
                      child:
                      CircularProgressIndicator(),
                    ),

                  if (diseasePrediction != null)
                    Card(
                      child: Padding(
                        padding:
                        const EdgeInsets.all(16),
                        child: Text(
                          diseasePrediction!,
                        ),
                      ),
                    ),


                ],

              ],
            ),
          ),
          if (controller.isLoading)
            Container(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator(color: Colors.green)),
            )
        ],
      ),
    );
  }
}