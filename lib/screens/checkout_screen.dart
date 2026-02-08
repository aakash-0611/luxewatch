import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatelessWidget {
  final double total;
  const CheckoutScreen({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Total Amount'),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Replace with API checkout later
                  await CartService.clear();

                  Navigator.popUntil(context, (r) => r.isFirst);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Order placed successfully')),
                  );
                },
                child: const Text('Confirm Order'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
