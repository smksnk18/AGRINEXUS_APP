// lib/api_service.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:agrinexus/models/crop_models.dart';
import 'package:agrinexus/models/disease_risk_model.dart';
import '../models/market_price_model.dart';

class AgriNexusApiService {

  static const String baseUrl =
      "https://agrinexus-backend-lg7w.onrender.com/api";

  // ==========================
  // STATES
  // ==========================

  Future<List<LocationEntity>> fetchStates() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/states'),
      );

      if (response.statusCode == 200) {
        List data = json.decode(
          response.body,
        );

        final states = data
            .map((item) => LocationEntity.fromJson(item))
            .toList();

        debugPrint("========== STATES ==========");
        for (final s in states) {
          debugPrint("${s.id} | ${s.name}");
        }

        return states;
      }
    } catch (e) {
      print("Error fetching states: $e");
    }

    return [];
  }

  // ==========================
  // DISTRICTS
  // ==========================

  Future<List<LocationEntity>> fetchDistricts(String stateId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/districts?state_id=$stateId'),
      );

      debugPrint("District URL: $baseUrl/districts?state_id=$stateId");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List data = json.decode(response.body);

        final districts = data
            .map((item) => LocationEntity.fromJson(item))
            .toList();

        debugPrint("========== DISTRICTS ==========");
        for (final d in districts) {
          debugPrint("${d.id} | ${d.name}");
        }

        return districts;
      }
    } catch (e) {
      debugPrint("Error fetching districts: $e");
    }

    return [];
  }

  // ==========================
  // TALUKAS
  // ==========================

  Future<List<LocationEntity>> fetchTalukas(
      String districtId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/talukas?district_id=$districtId',
        ),
      );

      if (response.statusCode == 200) {
        List data = json.decode(
          response.body,
        );

        return data
            .map(
              (item) =>
              LocationEntity.fromJson(item),
        )
            .toList();
      }
    } catch (e) {
      print(
        "Error fetching talukas: $e",
      );
    }

    return [];
  }

  // ==========================
  // PADDY VARIETIES
  // ==========================

  Future<List<PaddyVariety>>
  fetchPaddyVarieties(
      String stateId,
      String districtId,
      String talukaId,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/crops/paddy?state_id=$stateId&district_id=$districtId&taluka_id=$talukaId',
        ),
      );

      if (response.statusCode == 200) {
        List data = json.decode(
          response.body,
        );

        return data
            .map(
              (item) =>
              PaddyVariety.fromJson(item),
        )
            .toList();
      }
    } catch (e) {
      print(
        "Error fetching varieties: $e",
      );
    }

    return [];
  }



  Future<MarketPriceModel?> fetchMarketPrice(
      String crop,
      String district,
      ) async {

    try {

      final response = await http.get(
        Uri.parse(
          '$baseUrl/market-price?crop=$crop&district=$district',
        ),
      );

      if (response.statusCode == 200) {

        return MarketPriceModel.fromJson(
          json.decode(response.body),
        );
      }

    } catch (e) {
      print(e);
    }

    return null;
  }



  // ==========================
  // DISEASE RISK
  // ==========================

  Future<List<DiseaseRiskModel>>
  fetchDiseaseRisk(
      double temperature,
      int humidity,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/disease-risk?temperature=$temperature&humidity=$humidity',
        ),
      );

      if (response.statusCode == 200) {
        List data = json.decode(
          response.body,
        );

        return data
            .map(
              (item) =>
              DiseaseRiskModel.fromJson(item),
        )
            .toList();
      }
    } catch (e) {
      print(
        "Error fetching disease risk: $e",
      );
    }

    return [];
  }
}