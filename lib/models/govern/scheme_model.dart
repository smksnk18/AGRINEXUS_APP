class SchemeModel {

  final int id;
  final String schemeName;
  final String category;
  final String benefit;
  final String eligibility;
  final String description;
  final String website;

  SchemeModel({
    required this.id,
    required this.schemeName,
    required this.category,
    required this.benefit,
    required this.eligibility,
    required this.description,
    required this.website,
  });

  factory SchemeModel.fromJson(
      Map<String, dynamic> json) {

    return SchemeModel(
      id: json['id'],
      schemeName: json['scheme_name'],
      category: json['category'],
      benefit: json['benefit'],
      eligibility: json['eligibility'],
      description: json['description'],
      website: json['website'],
    );
  }
}