import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gold = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: CustomScrollView(
        slivers: [
          // ================= HERO IMAGE =================
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: const Color(0xFF0B0F14),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image,
                          size: 48, color: Colors.white54),
                    ),
                  ),

                  // Gradient overlay (luxury feel)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xFF0B0F14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BRAND
                  Text(
                    product.brand.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: gold,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // MODEL
                  Text(
                    product.model,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // PRICE
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DESCRIPTION CARD
                  _InfoCard(
                    title: 'Description',
                    child: Text(
                      'A refined luxury timepiece crafted with premium materials. '
                      'Designed for precision, elegance, and timeless appeal.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // SPECS
                  _InfoCard(
                    title: 'Specifications',
                    child: Column(
                      children: const [
                        _SpecRow('Movement', 'Automatic'),
                        _SpecRow('Case', 'Stainless Steel'),
                        _SpecRow('Water Resistance', '100m'),
                        _SpecRow('Warranty', '5 Years'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            // TODO: Add to cart
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          // TODO: Add to wishlist
                        },
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.white70,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF121826),
                          padding: const EdgeInsets.all(14),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REUSABLE UI ================= */

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121826),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60)),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
