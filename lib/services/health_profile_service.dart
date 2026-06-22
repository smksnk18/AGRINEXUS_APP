import '../models/health_profile_model.dart';
import '../models/ingredient_info_model.dart';

class HealthProfileService {

  static HealthProfile profile =
  HealthProfile(

    diabetes: false,
    hypertension: false,
    kidneyDisease: false,
    heartDisease: false,
    obesity: false,
    pregnancy: false,

    milkAllergy: false,
    peanutAllergy: false,
    eggAllergy: false,
    shellfishAllergy: false,
  );

}