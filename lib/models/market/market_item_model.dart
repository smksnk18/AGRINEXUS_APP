class MarketItem {
  final String commodity;
  final String state;
  final String district;
  final String market;
  final String modalPrice;
  final String minPrice;
  final String maxPrice;
  final String arrivalDate;

  MarketItem({
    required this.commodity,
    required this.state,
    required this.district,
    required this.market,
    required this.modalPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.arrivalDate,
  });

  factory MarketItem.fromJson(
      Map<String, dynamic> json) {
    return MarketItem(
      commodity:
      json['commodity']?.toString() ?? '',
      state:
      json['state']?.toString() ?? '',
      district:
      json['district']?.toString() ?? '',
      market:
      json['market']?.toString() ?? '',
      modalPrice:
      json['modal_price']?.toString() ?? '',
      minPrice:
      json['min_price']?.toString() ?? '',
      maxPrice:
      json['max_price']?.toString() ?? '',
      arrivalDate:
      json['arrival_date']?.toString() ?? '',
    );
  }
}