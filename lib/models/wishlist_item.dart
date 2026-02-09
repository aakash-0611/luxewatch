import 'product.dart';

class WishlistItem {
  final Product product;

  WishlistItem({
    required this.product,
  });

  /// Deserialize from local storage
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      product: Product.fromJson(json['product']),
    );
  }

  /// Serialize for local storage
  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'brand': product.brand,
        'model': product.model,
        'image_url': product.imageUrl,
        'price': product.price,
      },
    };
  }
}
