import 'api_service.dart';

class ApiProduct {
  final int id;
  final String brand;
  final String model;
  final String imageUrl;
  final double price;

  ApiProduct({
    required this.id,
    required this.brand,
    required this.model,
    required this.imageUrl,
    required this.price,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      imageUrl: json['image_url'],
      price: double.parse(json['price'].toString()),
    );
  }
}

class ProductService {
  static Future<List<ApiProduct>> getProducts() async {
    final res = await ApiService.dio.get('/products');
    return (res.data as List)
        .map((e) => ApiProduct.fromJson(e))
        .toList();
  }
}
