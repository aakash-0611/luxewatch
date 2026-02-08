import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _loading = true;
  List<CartItem> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await CartService.getCart();
    setState(() {
      _items = data;
      _loading = false;
    });
  }

  double get total =>
      _items.fold(0, (sum, i) => sum + i.subtotal);

  @override
  Widget build(BuildContext context) {
    final gold = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final item = _items[i];

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121826),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  child: Image.network(
                                    item.product.imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.model,
                                        style: const TextStyle(
                                            fontWeight:
                                                FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove),
                                            onPressed: () async {
                                              await CartService
                                                  .updateQty(
                                                item.product,
                                                item.qty - 1,
                                              );
                                              _load();
                                            },
                                          ),
                                          Text('${item.qty}'),
                                          IconButton(
                                            icon:
                                                const Icon(Icons.add),
                                            onPressed: () async {
                                              await CartService
                                                  .updateQty(
                                                item.product,
                                                item.qty + 1,
                                              );
                                              _load();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await CartService.remove(
                                        item.product);
                                    _load();
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // ===== CHECKOUT BAR =====
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0B0F14),
                        border: Border(
                          top: BorderSide(color: Colors.white12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total: \$${total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: gold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CheckoutScreen(total: total),
                                ),
                              );
                            },
                            child: const Text('Checkout'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}
