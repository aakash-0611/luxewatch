import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/wishlist_item.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  /// Load wishlist from storage
  Future<void> load() async {
    _items = await WishlistService.getWishlist();
    notifyListeners();
  }

  /// Check if product is wishlisted
  bool isWishlisted(Product product) {
    return _items.any((i) => i.product.id == product.id);
  }

  /// Toggle wishlist item
  Future<void> toggle(Product product) async {
    await WishlistService.toggle(product);
    await load();
  }
}
