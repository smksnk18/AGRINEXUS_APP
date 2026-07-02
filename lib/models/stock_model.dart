import 'dart:convert';

enum StockStatus { available, partialSold, sold }

class StockItem {
  final String id;
  final String cropName;
  final double quantity;    // in kg
  final double soldQuantity;
  final String unit;        // kg / quintal / tonne
  final double pricePerUnit;
  final String quality;     // A / B / C
  final DateTime harvestDate;
  final DateTime addedAt;
  final String? notes;
  final StockStatus status;

  StockItem({
    required this.id,
    required this.cropName,
    required this.quantity,
    this.soldQuantity = 0,
    required this.unit,
    required this.pricePerUnit,
    required this.quality,
    required this.harvestDate,
    required this.addedAt,
    this.notes,
    this.status = StockStatus.available,
  });

  double get availableQuantity => quantity - soldQuantity;
  double get totalValue => quantity * pricePerUnit;
  double get soldValue => soldQuantity * pricePerUnit;
  double get remainingValue => availableQuantity * pricePerUnit;

  StockItem copyWith({
    double? soldQuantity,
    StockStatus? status,
    String? notes,
  }) {
    return StockItem(
      id: id,
      cropName: cropName,
      quantity: quantity,
      soldQuantity: soldQuantity ?? this.soldQuantity,
      unit: unit,
      pricePerUnit: pricePerUnit,
      quality: quality,
      harvestDate: harvestDate,
      addedAt: addedAt,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'cropName': cropName,
    'quantity': quantity,
    'soldQuantity': soldQuantity,
    'unit': unit,
    'pricePerUnit': pricePerUnit,
    'quality': quality,
    'harvestDate': harvestDate.toIso8601String(),
    'addedAt': addedAt.toIso8601String(),
    'notes': notes,
    'status': status.name,
  };

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
    id: json['id'],
    cropName: json['cropName'],
    quantity: (json['quantity'] as num).toDouble(),
    soldQuantity: (json['soldQuantity'] as num? ?? 0).toDouble(),
    unit: json['unit'],
    pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
    quality: json['quality'],
    harvestDate: DateTime.parse(json['harvestDate']),
    addedAt: DateTime.parse(json['addedAt']),
    notes: json['notes'],
    status: StockStatus.values.firstWhere(
          (e) => e.name == json['status'],
      orElse: () => StockStatus.available,
    ),
  );

  static List<StockItem> listFromJson(String raw) {
    final list = jsonDecode(raw) as List;
    return list.map((e) => StockItem.fromJson(e)).toList();
  }

  static String listToJson(List<StockItem> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());
}