import '../models/ingredient_info_model.dart';
class IngredientInfoService {

  static Map<String, IngredientInfo> ingredientDatabase = {

    "sucralose":

    IngredientInfo(

      riskyConditions: [
        "Diabetes",
      ],

      effect:
      "Possible glucose metabolism concerns",

      explanation:
      "Artificial sweeteners should be consumed in moderation.",

      scorePenalty: 1,

      aliases: [

        "sucralose",

      ],

    ),
    "saccharin":

    IngredientInfo(

      riskyConditions: [
        "Diabetes",
      ],

      effect:
      "Artificial sweetener concerns",

      explanation:
      "Artificial sweeteners should be consumed in moderation.",

      scorePenalty: 1,

      aliases: [

        "saccharin",

      ],

    ),
    "sodium benzoate":

    IngredientInfo(

      riskyConditions: [

        "Hypertension",

      ],

      effect:

      "Excess sodium intake",

      explanation:

      "Sodium-containing preservatives may contribute to elevated blood pressure.",

      scorePenalty: 2,

      aliases: [

        "sodium benzoate",

      ],

    ),
    "potassium sorbate":

    IngredientInfo(

      riskyConditions: [

        "Kidney Disease",

      ],

      effect:

      "Electrolyte imbalance risk",

      explanation:

      "Excess potassium may place additional stress on impaired kidneys.",

      scorePenalty: 2,

      aliases: [

        "potassium sorbate",

      ],

    ),
    "palm oil":

    IngredientInfo(

      riskyConditions: [

        "Heart Disease",

        "Obesity",

      ],

      effect:

      "Elevated saturated fat intake",

      explanation:

      "High saturated fat consumption may increase cardiovascular risk.",

      scorePenalty: 2,

      aliases: [

        "palm oil",

      ],

    ),
    "hydrogenated oil":

    IngredientInfo(

      riskyConditions: [

        "Heart Disease",

      ],

      effect:

      "Trans fat exposure",

      explanation:

      "Trans fats may increase cardiovascular risk.",

      scorePenalty: 3,

      aliases: [

        "hydrogenated oil",

        "partially hydrogenated oil",

      ],

    ),
    "maltodextrin":

    IngredientInfo(

      riskyConditions: [

        "Diabetes",

      ],

      effect:

      "Rapid blood sugar increase",

      explanation:

      "Maltodextrin may cause sharp rises in blood glucose.",

      scorePenalty: 2,

      aliases: [

        "maltodextrin",

      ],

    ),
    "disodium inosinate":

    IngredientInfo(

      riskyConditions: [

        "Hypertension",

      ],

      effect:

      "Additional sodium load",

      explanation:

      "Flavor enhancers may increase sodium intake.",

      scorePenalty: 1,

      aliases: [

        "disodium inosinate",

      ],

    ),
    "disodium guanylate":

    IngredientInfo(

      riskyConditions: [

        "Hypertension",

      ],

      effect:

      "Additional sodium load",

      explanation:

      "Flavor enhancers may increase sodium intake.",

      scorePenalty: 1,

      aliases: [

        "disodium guanylate",

      ],

    ),
    "disodium guanylate":

    IngredientInfo(

      riskyConditions: [

        "Hypertension",

      ],

      effect:

      "Additional sodium load",

      explanation:

      "Flavor enhancers may increase sodium intake.",

      scorePenalty: 1,

      aliases: [

        "disodium guanylate",

      ],

    ),
    "nitrate":

    IngredientInfo(

      riskyConditions: [

        "Heart Disease",

      ],

      effect:

      "Cardiovascular concerns",

      explanation:

      "Processed foods containing nitrates should be consumed in moderation.",

      scorePenalty: 2,

      aliases: [

        "nitrate",

        "sodium nitrate",

      ],

    ),
    "carrageenan":

    IngredientInfo(

      riskyConditions: [

        "Kidney Disease",

      ],

      effect:

      "Digestive irritation",

      explanation:

      "Carrageenan may cause gastrointestinal discomfort in sensitive individuals.",

      scorePenalty: 1,

      aliases: [

        "carrageenan",

      ],

    ),
    "soy lecithin":

    IngredientInfo(

      riskyConditions: [

        "Peanut Allergy",

      ],

      effect:

      "Potential allergen exposure",

      explanation:

      "Individuals with severe allergies should exercise caution with soy-derived additives.",

      scorePenalty: 1,

      aliases: [

        "soy lecithin",

        "lecithin",

      ],

    ),
    "xanthan gum":

    IngredientInfo(

      riskyConditions: [

        "Kidney Disease",

      ],

      effect:

      "Digestive discomfort",

      explanation:

      "Excessive intake may cause gastrointestinal discomfort.",

      scorePenalty: 1,

      aliases: [

        "xanthan gum",

      ],

    ),
    "tartrazine":

    IngredientInfo(

      riskyConditions: [

        "Pregnancy",

      ],

      effect:

      "Artificial color concerns",

      explanation:

      "Artificial food colors should be consumed in moderation.",

      scorePenalty: 1,

      aliases: [

        "tartrazine",

        "yellow 5",

      ],

    ),
    "sunset yellow":

    IngredientInfo(

      riskyConditions: [

        "Pregnancy",

      ],

      effect:

      "Artificial color concerns",

      explanation:

      "Artificial food colors should be consumed in moderation.",

      scorePenalty: 1,

      aliases: [

        "sunset yellow",

        "yellow 6",

      ],

    ),
    "caffeine":

    IngredientInfo(

      riskyConditions: [

        "Pregnancy",

        "Heart Disease",

      ],

      effect:

      "Elevated heart rate",

      explanation:

      "High caffeine intake may increase heart rate and should be moderated during pregnancy.",

      scorePenalty: 2,

      aliases: [

        "caffeine",

      ],

    ),
    "artificial flavor":

    IngredientInfo(

      riskyConditions: [

        "Pregnancy",

      ],

      effect:

      "Artificial additive exposure",

      explanation:

      "Artificial flavoring agents should be consumed in moderation.",

      scorePenalty: 1,

      aliases: [

        "artificial flavor",

        "artificial flavours",

        "artificial flavoring",

      ],

    ),

    "sugar":

    IngredientInfo(

      riskyConditions: [
        "Diabetes",
      ],

      effect:
      "High blood sugar spike",

      explanation:
      "High sugar intake may rapidly increase blood glucose levels.",

      scorePenalty: 3,

      aliases: [

        "sugar",

        "sucrose",

        "fructose",

        "glucose",

        "glucose syrup",

        "high fructose corn syrup",

        "hfcs",

      ],

    ),

    "milk":

    IngredientInfo(

      riskyConditions: [

        "Milk Allergy",

      ],

      effect:

      "Allergic reaction",

      explanation:

      "Milk proteins may trigger allergic reactions.",

      scorePenalty: 8,
        aliases: [

          "milk",

          "milk solids",

          "milk powder",

          "skim milk powder",

          "whey",

          "whey powder",

          "casein",

        ]

    ),

    "peanut":

    IngredientInfo(

      riskyConditions: [

        "Peanut Allergy",

      ],

      effect:

      "Severe allergic reaction",

      explanation:

      "Peanuts can trigger life-threatening allergic responses.",

      scorePenalty: 10,
        aliases: [

          "peanut",

          "groundnut",

          "peanut oil",

        ]

    ),

    "egg":

    IngredientInfo(

      riskyConditions: [

        "Egg Allergy",

      ],

      effect:

      "Allergic reaction",

      explanation:

      "Egg proteins may cause allergic symptoms.",

      scorePenalty: 8,
        aliases: [

          "egg",

          "egg white",

          "egg yolk",

          "albumin",

        ]
    ),

    "shellfish":

    IngredientInfo(

      riskyConditions: [

        "Shellfish Allergy",

      ],

      effect:

      "Severe allergic reaction",

      explanation:

      "Shellfish can provoke serious allergic reactions.",

      scorePenalty: 10,
        aliases: [

          "shellfish",

          "shrimp",

          "prawn",

          "crab",

          "lobster",

          "crayfish",

          "krill",

          "scampi",

          "crawfish",

          "langoustine",

          "barnacle",

          "shellfish extract",

          "shrimp powder",

          "crab extract",

        ]

    ),

    "msg":

    IngredientInfo(

      riskyConditions: [

        "Hypertension",

      ],

      effect:

      "Increased sodium load",

      explanation:

      "MSG contributes additional sodium intake.",

      scorePenalty: 2,
        aliases: [

          "msg",

          "monosodium glutamate",

        ]

    ),

    "aspartame":

    IngredientInfo(

      riskyConditions: [

        "Diabetes",

      ],

      effect:

      "Possible glucose metabolism concerns",

      explanation:

      "Artificial sweeteners should be consumed in moderation.",

      scorePenalty: 1,
        aliases: [

          "aspartame",

        ]

    ),

  };

}