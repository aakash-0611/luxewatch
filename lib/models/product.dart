class Product {
  final int id;
  final String brand;
  final String model;
  final String imageUrl;
  final double price;

  Product({
    required this.id,
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      imageUrl: json['image_url'],
      price: double.parse(json['price'].toString()),
    );
    
  }
}
