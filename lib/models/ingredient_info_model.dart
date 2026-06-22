class IngredientInfo {
  final List<String> aliases;

  final List<String> riskyConditions;

  final String effect;

  final String explanation;

  final int scorePenalty;

  IngredientInfo({
    required this.aliases,

    required this.riskyConditions,

    required this.effect,

    required this.explanation,

    required this.scorePenalty,

  });

}