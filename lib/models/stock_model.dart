class StockModel {
  final String? id;

  final String farmerId;
  final String farmerName;

  final String crop;
  final String variety;

  final String state;
  final String district;
  final String taluka;

  final double quantity;
  final String unit;

  final double pricePerKg;

  final bool available;

  StockModel({
    this.id,
    required this.farmerId,
    required this.farmerName,
    required this.crop,
    required this.variety,
    required this.state,
    required this.district,
    required this.taluka,
    required this.quantity,
    required this.unit,
    required this.pricePerKg,
    this.available = true,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json["_id"],

      farmerId: json["farmerId"] ?? "",
      farmerName: json["farmerName"] ?? "",

      crop: json["crop"] ?? "",
      variety: json["variety"] ?? "",

      state: json["state"] ?? "",
      district: json["district"] ?? "",
      taluka: json["taluka"] ?? "",

      quantity: (json["quantity"] ?? 0).toDouble(),
      unit: json["unit"] ?? "kg",

      pricePerKg: (json["pricePerKg"] ?? 0).toDouble(),

      available: json["available"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "farmerId": farmerId,
      "farmerName": farmerName,

      "crop": crop,
      "variety": variety,

      "state": state,
      "district": district,
      "taluka": taluka,

      "quantity": quantity,
      "unit": unit,

      "pricePerKg": pricePerKg,

      "available": available,
    };
  }
}