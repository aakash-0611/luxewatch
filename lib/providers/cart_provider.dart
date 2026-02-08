import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get total =>
      _items.fold(0, (sum, i) => sum + i.subtotal);

  Future<void> load() async {
    _items = await CartService.getCart();
    notifyListeners();
  }

  Future<void> add(Product p) async {
    await CartService.add(p);
    await load();
  }

  Future<void> remove(Product p) async {
    await CartService.remove(p);
    await load();
  }
}
