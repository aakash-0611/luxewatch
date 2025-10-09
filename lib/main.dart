import 'package:flutter/material.dart';

void main() => runApp(const LuxeWatchApp());

class LuxeWatchApp extends StatelessWidget {
  const LuxeWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- LIGHT THEME ----
    final ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.light,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );

    // ---- DARK THEME ----
    final ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0F14),
      cardTheme: const CardThemeData(
        color: Color(0xFF12161C),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LuxeWatch',
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.system,
      home: const HomeShell(),
    );
  }
}

/* =============================== DATA ================================== */

class Product {
  final String id, brand, name, image;
  final double price;
  final double? oldPrice;
  final double rating;
  final bool onSale;
  const Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    this.rating = 4.6,
    this.onSale = false,
  });
}

const List<Product> kProducts = [
  Product(
    id: 'p1',
    brand: 'Audemars Piguet',
    name: 'Royal Oak Classic',
    image: 'assets/images/ap_ro.png',
    price: 25000,
    oldPrice: 28000,
    rating: 4.8,
  ),
  Product(
    id: 'p2',
    brand: 'Omega',
    name: 'SeaMaster Gold',
    image: 'assets/images/omega_seamaster.png',
    price: 18500,
    rating: 4.6,
  ),
  Product(
    id: 'p3',
    brand: 'Patek Philippe',
    name: 'Calatrava Heritage',
    image: 'assets/images/patek_aquanaut.avif',
    price: 32000,
    rating: 4.9,
  ),
  Product(
    id: 'p4',
    brand: 'Omega',
    name: 'Constellation Elite',
    image: 'assets/images/omega_seamaster.png',
    price: 22000,
    oldPrice: 26000,
    rating: 4.7,
    onSale: true,
  ),
  Product(
    id: 'p5',
    brand: 'Rolex',
    name: 'Day-Date Platinum',
    image: 'assets/images/rolex_datejust.avif',
    price: 54000,
    rating: 4.9,
  ),
  Product(
    id: 'p6',
    brand: 'Cartier',
    name: 'Santos De Cartier',
    image: 'assets/images/cartier_santos.avif',
    price: 7800,
    oldPrice: 9200,
    rating: 4.5,
    onSale: true,
  ),
  Product(
    id: 'p7',
    brand: 'TAG Heuer',
    name: 'Carrera Sport',
    image: 'assets/images/tag_carrera.png',
    price: 5600,
    rating: 4.4,
  ),
  Product(
    id: 'p8',
    brand: 'Seiko',
    name: 'Grand Seiko Snowflake',
    image: 'assets/images/gs_snowflake.png',
    price: 1400,
    rating: 4.2,
  ),
];
// ---- Image helper: uses assets if path starts with 'assets/', else network ----
Widget productImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? height,
  double? width,
  BorderRadius? radius,
}) {
  final Widget img = path.startsWith('assets/')
      ? Image.asset(path, fit: fit, height: height, width: width)
      : Image.network(path, fit: fit, height: height, width: width);
  return radius == null ? img : ClipRRect(borderRadius: radius, child: img);
}

/* ============================== SHELL =================================== */

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _soon() => ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('Coming soon (demo)')));

  Widget _body(bool isTablet) {
    switch (_index) {
      case 0:
        return LuxeHome(isTablet: isTablet);
      case 1:
        return const SearchPage(); // NEW: Search page
      default:
        return LuxeHome(isTablet: isTablet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final bool isTablet = constraints.maxWidth >= 900;

        if (!isTablet) {
          // PHONE
          return Scaffold(
            body: _body(isTablet),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) {
                setState(() => _index = i);
                if (i >= 2) _soon(); // Wishlist/Cart/Profile
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                NavigationDestination(
                    icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                NavigationDestination(
                    icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
                NavigationDestination(
                    icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          );
        }

        // TABLET
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) {
                  setState(() => _index = i);
                  if (i >= 2) _soon();
                },
                extended: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Text('W'),
                  ),
                ),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.search), label: Text('Search')),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite_border), label: Text('Wishlist')),
                  NavigationRailDestination(
                      icon: Icon(Icons.shopping_cart_outlined), label: Text('Cart')),
                  NavigationRailDestination(
                      icon: Icon(Icons.person_outline), label: Text('Profile')),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _body(isTablet)),
            ],
          ),
        );
      },
    );
  }
}

/* ============================== HOME ==================================== */

class LuxeHome extends StatelessWidget {
  final bool isTablet;
  const LuxeHome({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final featured = kProducts.take(4).toList(); // show only 4

    return CustomScrollView(
      slivers: [
        // Small, clean top app bar per Android guidelines
        SliverAppBar(
          pinned: true,
          title: const Text('LuxeWatch'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(radius: 16, child: Text('JD')),
            ),
          ],
        ),

        // Explore header + chips (Material action chips)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Explore', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                ExploreChipsSection(),
              ],
            ),
          ),
        ),

        // Promo banner with image + overlay text CTA
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PromoBanner(isWide: isTablet),
          ),
        ),

        SliverToBoxAdapter(child: SectionTitle(title: 'Featured')),

        // Featured grid (4 items)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ProductCard(product: featured[i]),
              childCount: featured.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.74,
            ),
          ),
        ),

        // Nice finishing section (kept from before)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: OurPromiseCard(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class OurPromiseCard extends StatelessWidget {
  const OurPromiseCard({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our Promise', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Craftsmanship • Authenticity • Care'),
            const SizedBox(height: 12),
            Row(
              children: [
                _IconLine(icon: Icons.verified, label: '2-Year Warranty'),
                const SizedBox(width: 12),
                _IconLine(icon: Icons.local_shipping_outlined, label: 'Free Shipping'),
                const SizedBox(width: 12),
                _IconLine(icon: Icons.build_outlined, label: 'Lifetime Service'),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(cs.primary.withOpacity(0.16)),
                foregroundColor: WidgetStatePropertyAll(cs.onSurface)
              ),
              child: const Text('Learn more'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconLine({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
    }
}

class ExploreChipsSection extends StatelessWidget {
  const ExploreChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Helper to build a standard action chip per Material 3
    Widget chip(IconData icon, String label, VoidCallback onTap) {
      return Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: ActionChip.elevated(
          avatar: Icon(icon, size: 18),
          label: Text(label),
          onPressed: onTap,
          elevation: 0,
          backgroundColor: cs.surfaceContainerLowest,
        ),
      );
    }

    // Use Wrap for automatic wrapping on small screens
    return Wrap(
      children: [
        chip(Icons.star_rate_rounded, 'Best Sellers', () {}),
        chip(Icons.watch_rounded, 'New Arrivals', () {}),
        chip(Icons.diamond_outlined, 'Limited', () {}),
        chip(Icons.swipe_rounded, 'Dress', () {}),
        chip(Icons.fitness_center_rounded, 'Sports', () {}),
      ],
    );
  }
}
class PromoBanner extends StatelessWidget {
  final bool isWide;
  const PromoBanner({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Replace with your own asset later if you want
          Image.network(
            'https://picsum.photos/seed/luxe_banner/1200/700',
            height: isWide ? 220 : 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Gradient for legible text
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Text overlay
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get custom recs for your next timepiece',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Curated picks based on what you like.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                FilledButton.tonal(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      cs.primary.withOpacity(0.25),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Explore Collection'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return image;
  }
}

/* ============================== SEARCH ================================== */

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple “search results” list (no actual filtering required yet)
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search watches',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (q) {
              // optional: wire up filtering later
            },
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: kProducts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final p = kProducts[i];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: productImage(p.image, width: 56, height: 56, fit: BoxFit.cover),
                ),
                title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${p.brand} • \$${p.price.toStringAsFixed(0)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/* ============================ HERO BANNER ================================ */

class HeroBanner extends StatelessWidget {
  final bool isWide; // tablet/desktop = true, phone = false
  const HeroBanner({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final title =
        Text('Good Morning', style: Theme.of(context).textTheme.titleLarge);
    const subtitle = Text('Discover exquisite timepieces');
    final tag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('New Collection • Heritage Series'),
    );
    final cta = FilledButton(onPressed: () {}, child: const Text('Explore Collection'));
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'https://picsum.photos/seed/heritage/640/420',
        height: isWide ? 140 : 120,
        width: isWide ? 180 : double.infinity,
        fit: BoxFit.cover,
      ),
    );

    if (!isWide) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 6),
              subtitle,
              const SizedBox(height: 10),
              tag,
              const SizedBox(height: 12),
              cta,
              const SizedBox(height: 12),
              image,
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 6),
                  subtitle,
                  const SizedBox(height: 10),
                  tag,
                  const SizedBox(height: 12),
                  cta,
                ],
              ),
            ),
            const SizedBox(width: 16),
            image,
          ],
        ),
      ),
    );
  }
}

/* ============================ PRODUCT CARD =============================== */

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 250),
              pageBuilder: (_, a, __) =>
                  FadeTransition(opacity: a, child: ProductDetailPage(product: product)),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'pimg-${product.id}',
                      child: productImage(product.image, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  if (product.onSale)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Sale',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < product.rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('(${product.rating.toStringAsFixed(1)})',
                        style: const TextStyle(fontSize: 12)),
                  ]),
                  const SizedBox(height: 6),
                  Text(product.brand,
                      style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 8),
                        Text('\$${product.oldPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.white60,
                            )),
                      ],
                    ],
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

/* ========================= PRODUCT DETAIL PAGE =========================== */

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'pimg-${product.id}',
            child: productImage(
              product.image,
              height: 280,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.brand,
              style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(product.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < product.rating.round() ? Icons.star : Icons.star_border,
                  size: 18,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text('(${product.rating.toStringAsFixed(1)})'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              if (product.oldPrice != null) ...[
                const SizedBox(width: 10),
                Text('\$${product.oldPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.white60,
                    )),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "A refined timepiece crafted with premium materials. "
            "This is a demo description to satisfy the coursework requirement.",
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Demo: Add to cart not implemented')),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
