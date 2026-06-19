// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agrinexus/models/crop_models.dart';

class AgriNexusApiService {
  // Use 10.0.2.2 if testing via native Android Emulator to point to local Flask host
  static const String baseUrl = "http://10.0.2.2:5000/api";

  Future<List<LocationEntity>> fetchStates() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/states'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => LocationEntity.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetching states: $e");
    }
    return [];
  }

  Future<List<LocationEntity>> fetchDistricts(String stateId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/districts?state_id=$stateId'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => LocationEntity.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetching districts: $e");
    }
    return [];
  }

  Future<List<LocationEntity>> fetchTalukas(String districtId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/talukas?district_id=$districtId'));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => LocationEntity.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetching talukas: $e");
    }
    return [];
  }

  Future<List<PaddyVariety>> fetchPaddyVarieties(String stateId, String districtId, String talukaId) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/crops/paddy?state_id=$stateId&district_id=$districtId&taluka_id=$talukaId'
      ));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => PaddyVariety.fromJson(item)).toList();
      }
    } catch (e) {
      print("Error fetching varieties: $e");
    }
    return [];
  }
}