import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wishlist_item.dart';
import '../models/product.dart';

class WishlistService {
  static const _key = 'wishlist_items';

  static Future<List<WishlistItem>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    return raw
        .map((e) => WishlistItem.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> toggle(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getWishlist();

    final index =
        items.indexWhere((i) => i.product.id == product.id);

    if (index >= 0) {
      items.removeAt(index);
    } else {
      items.add(WishlistItem(product: product));
    }

    await prefs.setStringList(
      _key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  static Future<bool> contains(Product product) async {
    final items = await getWishlist();
    return items.any((i) => i.product.id == product.id);
  }
}
