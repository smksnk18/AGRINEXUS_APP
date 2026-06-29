class Product {

  final String name;
  final int price;
  final String image;
  final String description;
  final double rating;
  final String category;

  bool favorite;

  int quantity;

  Product({

    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
    required this.category,

    this.favorite = false,

    this.quantity = 1,
  });
}