class DiseaseRiskModel {

  final String name;
  final String severity;

  final List<String> symptoms;
  final List<String> prevention;

  DiseaseRiskModel({
    required this.name,
    required this.severity,
    required this.symptoms,
    required this.prevention,
  });

  factory DiseaseRiskModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return DiseaseRiskModel(
      name: json["name"],
      severity: json["severity"],
      symptoms:
      List<String>.from(
        json["symptoms"],
      ),
      prevention:
      List<String>.from(
        json["prevention"],
      ),
    );
  }
}