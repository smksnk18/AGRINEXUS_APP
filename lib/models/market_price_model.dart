class MarketPriceModel {
  final String crop;
  final String district;
  final String market;
  final int modalPrice;
  final int minPrice;
  final int maxPrice;
  final String unit;

  MarketPriceModel({
    required this.crop,
    required this.district,
    required this.market,
    required this.modalPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.unit,
  });

  factory MarketPriceModel.fromJson(
      Map<String, dynamic> json) {
    return MarketPriceModel(
      crop: json["crop"],
      district: json["district"],
      market: json["market"],
      modalPrice: json["modal_price"],
      minPrice: json["min_price"],
      maxPrice: json["max_price"],
      unit: json["unit"],
    );
  }
}