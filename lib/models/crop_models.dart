class LocationEntity {
  final String id;
  final String name;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LocationEntity &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  LocationEntity({
    required this.id,
    required this.name,
  });

  factory LocationEntity.fromJson(
      Map<String, dynamic> json,
      ) {
    return LocationEntity(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class PaddyVariety {
  final String id;
  final String name;
  final int durationDays;
  final String season;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaddyVariety &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  final double averageYieldPerAcre;
  final String waterRequirement;
  final List<String> resistances;

  final double costOfCultivation;
  final double expectedMarketPrice;

  final List<String> cropCalendar;
  final List<String> fertilizerSchedule;
  final List<String> irrigationPlan;
  final List<String> diseaseAlerts;

  PaddyVariety({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.season,
    required this.averageYieldPerAcre,
    required this.waterRequirement,
    required this.resistances,
    required this.costOfCultivation,
    required this.expectedMarketPrice,
    required this.cropCalendar,
    required this.fertilizerSchedule,
    required this.irrigationPlan,
    required this.diseaseAlerts,
  });

  factory PaddyVariety.fromJson(
      Map<String, dynamic> json,
      ) {
    return PaddyVariety(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          '',
      name: json['name'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      season: json['season'] ?? '',
      averageYieldPerAcre:
      (json['avg_yield'] as num?)
          ?.toDouble() ??
          0.0,
      waterRequirement:
      json['water_requirement'] ?? '',
      resistances:
      List<String>.from(
        json['resistances'] ?? [],
      ),
      costOfCultivation:
      (json['cost_cultivation'] as num?)
          ?.toDouble() ??
          0.0,
      expectedMarketPrice:
      (json['market_price'] as num?)
          ?.toDouble() ??
          0.0,
      cropCalendar:
      List<String>.from(
        json['crop_calendar'] ?? [],
      ),
      fertilizerSchedule:
      List<String>.from(
        json['fertilizer_schedule'] ?? [],
      ),
      irrigationPlan:
      List<String>.from(
        json['irrigation_plan'] ?? [],
      ),
      diseaseAlerts:
      List<String>.from(
        json['disease_alerts'] ?? [],
      ),
    );
  }

  double get avgYield =>
      averageYieldPerAcre;

  double get marketPrice =>
      expectedMarketPrice;

  double get costCultivation =>
      costOfCultivation;

  double get estimatedRevenue =>
      averageYieldPerAcre *
          expectedMarketPrice;

  double get estimatedProfit =>
      estimatedRevenue -
          costOfCultivation;


}