import 'package:flutter/material.dart';

void main() => runApp(const LuxeWatchApp());

class LuxeWatchApp extends StatelessWidget {
  const LuxeWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    // LIGHT THEME
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

    //  DARK THEME
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
      themeMode: ThemeMode.system, // follows device setting
      home: const HomeShell(),
    );
  }
}

/* =============================== DATA ================================== */

class Product {
  final String id, brand, name, image;
  final double price;
  final double? oldPrice; // null means no old price
  final double rating; // 0..5
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
    image: 'https://picsum.photos/seed/aw1/800/800',
    price: 25000,
    oldPrice: 28000,
    rating: 4.8,
  ),
  Product(
    id: 'p2',
    brand: 'Omega',
    name: 'Speedmaster Gold',
    image: 'https://picsum.photos/seed/aw2/800/800',
    price: 18500,
    rating: 4.6,
  ),
  Product(
    id: 'p3',
    brand: 'Patek Philippe',
    name: 'Calatrava Heritage',
    image: 'https://picsum.photos/seed/aw3/800/800',
    price: 32000,
    rating: 4.9,
  ),
  Product(
    id: 'p4',
    brand: 'Omega',
    name: 'Constellation Elite',
    image: 'https://picsum.photos/seed/aw4/800/800',
    price: 22000,
    oldPrice: 26000,
    rating: 4.7,
    onSale: true,
  ),
  Product(
    id: 'p5',
    brand: 'Rolex',
    name: 'Day-Date Platinum',
    image: 'https://picsum.photos/seed/aw5/800/800',
    price: 54000,
    rating: 4.9,
  ),
  Product(
    id: 'p6',
    brand: 'Cartier',
    name: 'Santos De Cartier',
    image: 'https://picsum.photos/seed/aw6/800/800',
    price: 7800,
    oldPrice: 9200,
    rating: 4.5,
    onSale: true,
  ),
  Product(
    id: 'p7',
    brand: 'TAG Heuer',
    name: 'Carrera Sport',
    image: 'https://picsum.photos/seed/aw7/800/800',
    price: 5600,
    rating: 4.4,
  ),
  Product(
    id: 'p8',
    brand: 'Tissot',
    name: 'Gentleman Powermatic',
    image: 'https://picsum.photos/seed/aw8/800/800',
    price: 850,
    rating: 4.2,
  ),
];

/* ============================== SHELL =================================== */

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _soon() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon (demo)')),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final bool isTablet = constraints.maxWidth >= 900;

        final Widget body = LuxeHome(isTablet: isTablet);

        if (!isTablet) {
          // PHONE: bottom nav
          return Scaffold(
            body: body,
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) {
                setState(() => _index = i);
                if (i != 0) _soon(); // keep Home only for now
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
                NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
              ],
            ),
          );
        }

        // TABLET: side rail
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) {
                  setState(() => _index = i);
                  if (i != 0) _soon();
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
                  NavigationRailDestination(icon: Icon(Icons.search), label: Text('Search')),
                  NavigationRailDestination(icon: Icon(Icons.favorite_border), label: Text('Wishlist')),
                  NavigationRailDestination(icon: Icon(Icons.shopping_cart_outlined), label: Text('Cart')),
                  NavigationRailDestination(icon: Icon(Icons.person_outline), label: Text('Profile')),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
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
    final cs = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
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

        // Tablet hero (landscape)
        if (isTablet)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _HeroCard(),
            ),
          ),

        // Categories (chips)
        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: const [
                _CategoryChip(label: 'All', selected: true),
                _CategoryChip(label: 'Sports'),
                _CategoryChip(label: 'Dress'),
                _CategoryChip(label: 'Vintage'),
                _CategoryChip(label: 'Limited'),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        // Product grid
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ProductCard(product: kProducts[i]),
              childCount: kProducts.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.74,
            ),
          ),
        ),
      ],
    );
  }
}

/* ============================ UI WIDGETS ================================= */

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        onSelected: (_) {},
        label: Text(label),
        selectedColor: cs.primary.withOpacity(0.18),
        showCheckmark: false,
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good Morning', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  const Text('Discover exquisite timepieces'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('New Collection • Heritage Series'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: () {}, child: const Text('Explore Collection')),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/seed/heritage/420/280',
                height: 140,
                width: 180,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} (demo)')),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image + badges
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(product.image, fit: BoxFit.cover),
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
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Sale',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),

            // details
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
                        color: cs.primary,
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
