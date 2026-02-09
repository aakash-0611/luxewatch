import '../services/api_service.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  /// PLACE ORDER
  static Future<void> checkout({
    required String fullName,
    required String phone,
    required String address,
    required String city,
    required String postalCode,
    required List<CartItem> items,
  }) async {
    final payload = {
      'full_name': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'items': items
          .map((i) => {
                'product_id': i.product.id,
                'qty': i.qty,
              })
          .toList(),
    };

    final res = await ApiService.dio.post('/checkout', data: payload);

    if (res.statusCode != 201) {
      throw Exception('Checkout failed');
    }
  }

  /// FETCH ORDERS
  static Future<List<Order>> getOrders() async {
    final res = await ApiService.dio.get('/orders');

    final data = res.data;

    if (data is! List) {
      throw Exception('Invalid orders response');
    }

    return data.map<Order>((e) => Order.fromJson(e)).toList();
  }
}
