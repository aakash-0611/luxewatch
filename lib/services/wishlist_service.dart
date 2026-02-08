import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistService {
  static const _key = 'wishlist_items';

  static Future<List<Product>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    return raw
        .map((e) => Product.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<bool> isWishlisted(int productId) async {
    final items = await getWishlist();
    return items.any((p) => p.id == productId);
  }

  static Future<void> toggle(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getWishlist();

    final exists = items.any((p) => p.id == product.id);

    if (exists) {
      items.removeWhere((p) => p.id == product.id);
    } else {
      items.add(product);
    }

    await prefs.setStringList(
      _key,
      items.map((p) => jsonEncode(_toJson(p))).toList(),
    );
  }

  static Map<String, dynamic> _toJson(Product p) => {
        'id': p.id,
        'brand': p.brand,
        'model': p.model,
        'image_url': p.imageUrl,
        'price': p.price,
      };
}
