import '../../../models/govern/scheme_model.dart';

class SchemeService {

  Future<List<SchemeModel>> getSchemes() async {

    return [

      SchemeModel(
        id: 1,
        schemeName: "PM Kisan",
        category: "Income Support",
        benefit:
        "₹6000 yearly support",
        eligibility:
        "Small farmers",
        description:
        "Financial assistance for farmers",
        website:
        "https://pmkisan.gov.in",
      ),

      SchemeModel(
        id: 2,
        schemeName:
        "Crop Insurance",
        category: "Insurance",
        benefit:
        "Crop protection",
        eligibility:
        "All farmers",
        description:
        "Insurance for crop loss",
        website:
        "https://pmfby.gov.in",
      ),

      SchemeModel(
        id: 3,
        schemeName:
        "Kisan Credit Card",
        category: "Loan",
        benefit:
        "Low interest loan",
        eligibility:
        "Eligible farmers",
        description:
        "Agriculture loan support",
        website:
        "https://myscheme.gov.in",
      ),

    ];
  }
}