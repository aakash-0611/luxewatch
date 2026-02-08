import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  static const _key = 'cart_items';

  static Future<List<CartItem>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    return raw
        .map((e) => CartItem.fromJson(jsonDecode(e)))
        .toList();
  }

  static Future<void> add(Product product) async {
    final items = await getCart();

    final index =
        items.indexWhere((i) => i.product.id == product.id);

    if (index >= 0) {
      items[index].qty++;
    } else {
      items.add(CartItem(product: product));
    }

    await _save(items);
  }

  static Future<void> remove(Product product) async {
    final items = await getCart();
    items.removeWhere((i) => i.product.id == product.id);
    await _save(items);
  }

  static Future<void> updateQty(Product product, int qty) async {
    final items = await getCart();
    final index =
        items.indexWhere((i) => i.product.id == product.id);

    if (index >= 0) {
      items[index].qty = qty.clamp(1, 99);
      await _save(items);
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> _save(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
