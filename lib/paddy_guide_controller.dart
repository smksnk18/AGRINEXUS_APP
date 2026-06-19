// lib/paddy_guide_controller.dart

import 'package:flutter/material.dart';
// These absolute package paths tell the compiler exactly where to look
import 'package:agrinexus/models/crop_models.dart';
import 'package:agrinexus/api_service.dart';
import 'package:agrinexus/models/disease_risk_model.dart';

class PaddyGuideController extends ChangeNotifier {
  final AgriNexusApiService _apiService = AgriNexusApiService();

  bool isLoading = false;

  LocationEntity? selectedState;
  LocationEntity? selectedDistrict;
  LocationEntity? selectedTaluka;
  PaddyVariety? selectedVariety;

  List<LocationEntity> states = [];
  List<LocationEntity> districts = [];
  List<LocationEntity> talukas = [];
  List<PaddyVariety> availableVarieties = [];
  List<DiseaseRiskModel> diseaseRisks = [];

  Future<void> loadInitialStates() async {
    _setLoading(true);
    states = await _apiService.fetchStates();
    _setLoading(false);
  }
  Future<void> loadDiseaseRisk(
      double temperature,
      int humidity,
      ) async {

    diseaseRisks =
    await _apiService.fetchDiseaseRisk(
      temperature,
      humidity,
    );

    notifyListeners();
  }
  Future<void> selectState(LocationEntity? state) async {
    selectedState = state;
    selectedDistrict = null;
    selectedTaluka = null;
    selectedVariety = null;
    districts = [];
    talukas = [];
    availableVarieties = [];

    if (state != null) {
      _setLoading(true);
      districts = await _apiService.fetchDistricts(state.id);
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> selectDistrict(LocationEntity? district) async {
    selectedDistrict = district;
    selectedTaluka = null;
    selectedVariety = null;
    talukas = [];
    availableVarieties = [];

    if (district != null) {
      _setLoading(true);
      talukas = await _apiService.fetchTalukas(district.id);
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> selectTaluka(LocationEntity? taluka) async {
    selectedTaluka = taluka;
    selectedVariety = null;
    availableVarieties = [];

    if (selectedState != null && selectedDistrict != null && taluka != null) {
      _setLoading(true);
      availableVarieties = await _apiService.fetchPaddyVarieties(
          selectedState!.id,
          selectedDistrict!.id,
          taluka.id
      );
      _setLoading(false);
    }
    notifyListeners();
  }

  void selectVariety(PaddyVariety? variety) {
    selectedVariety = variety;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}