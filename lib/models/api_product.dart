class ApiProduct {
  final int id;
  final String brand;
  final String model;
  final double price;
  final String imageUrl;

  ApiProduct({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.imageUrl,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}
