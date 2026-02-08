import 'product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({
    required this.product,
    this.qty = 1,
  });

  double get subtotal => product.price * qty;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      qty: json['qty'],
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
        'qty': qty,
      };
}
