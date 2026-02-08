import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/wishlist_service.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _wishlisted = false;

  @override
  void initState() {
    super.initState();
    _loadWishlistState();
  }

  Future<void> _loadWishlistState() async {
    final exists =
        await WishlistService.contains(widget.product);
    if (mounted) {
      setState(() => _wishlisted = exists);
    }
  }

  Future<void> _toggleWishlist() async {
    await WishlistService.toggle(widget.product);
    setState(() => _wishlisted = !_wishlisted);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== IMAGE + HEART =====
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      widget.product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: _toggleWishlist,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0B0F14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _wishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: _wishlisted
                              ? Colors.redAccent
                              : Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== INFO =====
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.brand,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
