class AnalysisResult {
  final double score;
  final String status;
  final List<String> unsafeIngredients;
  final List<String> effects;
  final String recommendation;
  final String allowedAmount;
  final List<String> reasons;
  final String explanation;
  final String hazardLevel;

  AnalysisResult({
    required this.score,
    required this.status,
    required this.unsafeIngredients,
    required this.effects,
    required this.recommendation,
    required this.allowedAmount,
    required this.reasons,
    required this.explanation,
    required this.hazardLevel,

  });

}