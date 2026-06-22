import 'package:hive/hive.dart';

part 'eatgood_product_model.g.dart';

@HiveType(typeId: 0)
class EatGoodProduct {

  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final List<String> ingredients;

  @HiveField(3)
  final double calories;

  @HiveField(4)
  final double sugar;

  @HiveField(5)
  final double fat;

  @HiveField(6)
  final double protein;

  @HiveField(7)
  final double sodium;

  @HiveField(8)
  final String qrData;

  EatGoodProduct({
    required this.productId,
    required this.productName,
    required this.ingredients,
    required this.calories,
    required this.sugar,
    required this.fat,
    required this.protein,
    required this.sodium,
    required this.qrData,
  });

}