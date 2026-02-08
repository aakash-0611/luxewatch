import 'product.dart';

class WishlistItem {
  final Product product;

  WishlistItem({required this.product});

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() => {
        'product': {
          'id': product.id,
          'brand': product.brand,
          'model': product.model,
          'image_url': product.imageUrl,
          'price': product.price,
        },
      };
}
