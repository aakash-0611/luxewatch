import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

// Global theme controller
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.system);

void main() => runApp(const LuxeWatchApp());

class LuxeWatchApp extends StatelessWidget {
  const LuxeWatchApp({super.key});

  @override
  Widget build(BuildContext context) {

    /* COLOUR SCHEME FOR APP */ 

    // LIGHT THEME 
    final ThemeData light = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37), // gold
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFFD4AF37),
        onPrimary: Colors.black,
        surface: const Color(0xFFF7F4ED),      // light background tones
        background: const Color(0xFFF7F4ED),
        onSurface: const Color(0xFF0B0F14),    // dark text on light bg
        onBackground: const Color(0xFF0B0F14),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F4ED),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF0B0F14)),
        bodyLarge: TextStyle(color: Color(0xFF0B0F14)),
        bodyMedium: TextStyle(color: Color(0xFF3A4048)),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Color(0xFFF7F4ED),
        foregroundColor: Color(0xFF0B0F14),
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFF7F4ED),
        indicatorColor: const Color(0xFFD4AF37),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: Color(0xFF3A4048))),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(color: Color(0xFF3A4048), fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        backgroundColor: const Color(0xFFEDE9DF),
        selectedColor: const Color(0x33D4AF37),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0B0F14)),
        side: const BorderSide(color: Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          backgroundColor: const WidgetStatePropertyAll(Color(0xFFD4AF37)),
          foregroundColor: const WidgetStatePropertyAll(Colors.black),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          side: const WidgetStatePropertyAll(BorderSide(color: Color(0xFFD4AF37))),
          foregroundColor: const WidgetStatePropertyAll(Color(0xFFD4AF37)),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: Color(0x22000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );


    // DARK THEME 
    final ThemeData dark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0B0F14), // deep charcoal
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0F14),
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0B0F14),
        indicatorColor: const Color(0xFFD4AF37),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: const WidgetStatePropertyAll(IconThemeData(color: Colors.white70)),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        backgroundColor: const Color(0xFF161B22),
        selectedColor: const Color(0x33D4AF37),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        side: const BorderSide(color: Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          side: const WidgetStatePropertyAll(BorderSide(color: Color(0xFFD4AF37))),
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF11151B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );

    // App initialization
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LuxeWatch',
          theme: light,     
          darkTheme: dark,  
          themeMode: mode,   
          home: const SplashScreen(),
        );
      },
    );

  }
}

/* DATA */

// Product model
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

//Data Seed for products
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
    image: 'assets/images/patek-nautilus.png', 
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
    image: 'assets/images/rolex1.png', 
    price: 54000,
    rating: 4.9,
  ),
  Product(
    id: 'p6',
    brand: 'Cartier',
    name: 'Santos De Cartier',
    image: 'assets/images/watch3.png',
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

// Image helper to fetch local images
Widget productImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? height,
  double? width,
  BorderRadius? radius,
}) {
  final int ix = path.indexOf('assets/');
  if (ix >= 0) path = path.substring(ix);

  final Widget img = path.startsWith('assets/')
      ? Image.asset(path, fit: fit, height: height, width: width)
      : Image.network(path, fit: fit, height: height, width: width);
  return radius == null ? img : ClipRRect(borderRadius: radius, child: img);
}

/* SHELL */

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

// Navigation Logicflutter 
class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  Widget _body(bool isTablet) {
    switch (_index) {
      case 0:
        return LuxeHome(isTablet: isTablet);
      case 1:
        return const SearchPage();
      case 2:
        return const WishlistPage(); 
      case 3:
        return const ProductsPage(); 
      case 4:
        return const CartPage(); 
      default:
        return LuxeHome(isTablet: isTablet);
    }
  }

//Checks Device Width to decide whether to show NavigationRail or NavigationBar

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
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
                NavigationDestination(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                NavigationDestination(icon: Icon(Icons.storefront), label: 'Products'),
                NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
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
                  onDestinationSelected: (i) => setState(() => _index = i),
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
                    NavigationRailDestination(icon: Icon(Icons.storefront), label: Text('Products')),
                    NavigationRailDestination(icon: Icon(Icons.shopping_cart_outlined), label: Text('Cart')),
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
        // Header row: "Good Morning" + avatar menu (Material 3)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('LUXEWATCH',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
                buildUserMenuAction(context),
              ],
            ),
          ),
        ),

        // Explore header + chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Explore', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                ExploreChipsSection(),
              ],
            ),
          ),
        ),

        // Promo banner
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

        // Our Promise
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

/* REUSABLES */

// User avatar with popup menu
enum _MenuItem { account, privacy, settings, help, theme, signout }

PopupMenuButton<_MenuItem> _menu({required BuildContext context}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return PopupMenuButton<_MenuItem>(
    tooltip: '', // <- removes the “Show menu” tooltip bubble
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onSelected: (m) {
      switch (m) {
        case _MenuItem.account:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account (demo)')));
          break;
        case _MenuItem.privacy:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Privacy (demo)')));
          break;
        case _MenuItem.settings:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings (demo)')));
          break;
        case _MenuItem.help:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Help & Support (demo)')));
          break;
        case _MenuItem.theme:
          // Toggle between light and dark (you can also cycle system→light→dark if you want)
          appThemeMode.value =
              (appThemeMode.value == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
          break;
        case _MenuItem.signout:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign out (demo)')));
          break;
      }
    },
    itemBuilder: (ctx) => [
      const PopupMenuItem(value: _MenuItem.account,  child: Text('Account')),
      const PopupMenuItem(value: _MenuItem.privacy,  child: Text('Privacy')),
      const PopupMenuItem(value: _MenuItem.settings, child: Text('Settings')),
      const PopupMenuItem(value: _MenuItem.help,     child: Text('Help & Support')),
      PopupMenuItem(
        value: _MenuItem.theme,
        child: Row(
          children: [
            Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 18),
            const SizedBox(width: 8),
            Text(isDark ? 'Switch to Light' : 'Switch to Dark'),
          ],
        ),
      ),
      const PopupMenuItem(value: _MenuItem.signout,  child: Text('Sign out')),
    ],
    child: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: CircleAvatar(
        radius: 16,
        child: Text(
          'W',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    ),
  );
}

Widget buildUserMenuAction(BuildContext context) => _menu(context: context);

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

//Bottom widget: Our Promise card
class OurPromiseCard extends StatelessWidget {
  const OurPromiseCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Our Promise', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: 8),
            Text('Craftsmanship • Authenticity • Care'),
          ],
        ),
      ),
    );
  }
}

/* EXTRA HOME WIDGETS */

//Filter chips (Static, no real filtering)
class ExploreChipsSection extends StatelessWidget {
  const ExploreChipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    Color textColor   = isLight ? const Color(0xFF0B0F14) : Colors.white;
    Color bgColor     = isLight ? const Color(0xFFEDE9DF) : const Color(0xFF161B22);
    Color selectedBg  = cs.primary.withOpacity(isLight ? 0.20 : 0.22);

    Widget chip(String label, IconData icon, {bool selected = false}) {
      return Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8),
        child: FilterChip(
          selected: selected,
          onSelected: (_) {},
          showCheckmark: false,
          side: BorderSide.none,
          shape: const StadiumBorder(),
          backgroundColor: bgColor,
          selectedColor: selectedBg,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: textColor),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
            ],
          ),
        ),
      );
    }

    return Wrap(
      children: [
        chip('All', Icons.all_inclusive, selected: true),
        chip('Sports', Icons.sports_score),
        chip('Dress', Icons.checkroom),
        chip('Vintage', Icons.history_edu),
        chip('Limited', Icons.workspace_premium),
      ],
    );
  }
}


//Banner card (below Filter chips)
class PromoBanner extends StatelessWidget {
  final bool isWide;
  const PromoBanner({super.key, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // shared pill tag
    Widget goldTag(String text) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.20),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    );

    // image thumb
    final img = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: productImage(
        'assets/images/banner.webp', // or keep your network pic
        height: isWide ? 140 : 120,
        width: isWide ? 160 : double.infinity,
        fit: BoxFit.cover,
      ),
    );

    if (!isWide) {
      // phone: stacked
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              goldTag('New Collection'),
              const SizedBox(height: 10),
              const Text('Heritage Series', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Timeless craftsmanship meets modern innovation',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              FilledButton.tonal(onPressed: () {}, child: const Text('Explore Collection')),
              const SizedBox(height: 14),
              img,
            ],
          ),
        ),
      );
    }

    // tablet: side-by-side
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  goldTag('New Collection'),
                  const SizedBox(height: 10),
                  const Text('Heritage Series', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Timeless craftsmanship meets modern innovation',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  FilledButton.tonal(onPressed: () {}, child: const Text('Explore Collection')),
                ],
              ),
            ),
            const SizedBox(width: 16),
            img,
          ],
        ),
      ),
    );
  }
}


/* SEARCH */

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, title: const Text('Search'), actions: [buildUserMenuAction(context)]),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search watches',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final p = kProducts[i];
              return Column(
                children: [
                  ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: productImage(p.image, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                    title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('${p.brand} • \$${p.price.toStringAsFixed(0)}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
            childCount: kProducts.length,
          ),
        ),
      ],
    );
  }
}

/* WISHLIST */

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = kProducts.take(3).toList(); // static sample

    return CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, title: const Text('Wishlist'), actions: [buildUserMenuAction(context)]),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final p = items[i];
              return Column(
                children: [
                  _WishlistItem(product: p),
                  const Divider(height: 1),
                ],
              );
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }
}

class _WishlistItem extends StatelessWidget {
  final Product product;
  const _WishlistItem({required this.product});

  @override
  Widget build(BuildContext context) {
    // Red actions (static)
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: productImage(product.image, width: 84, height: 84, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(product.brand, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Text('\$${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.red),
                        side: MaterialStatePropertyAll(BorderSide(color: Colors.red)),
                      ),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* PRODUCTS */

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, title: const Text('Products'), actions: [buildUserMenuAction(context)]),
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ProductCard(product: kProducts[i]),
              childCount: kProducts.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isWide ? 4 : 2,
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

/* CART */

// Cart item model
class CartItem {
  final Product product;
  final int qty;
  const CartItem({required this.product, required this.qty});
}

//Cart page class reusing Seed products data
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example items (static for demo)
    final items = <CartItem>[
      CartItem(product: kProducts[0], qty: 1),
      CartItem(product: kProducts[3], qty: 2),
      CartItem(product: kProducts[7], qty: 1),
    ];
    final subtotal = items.fold<double>(0, (s, it) => s + it.product.price * it.qty);

    return CustomScrollView(
      slivers: [
        SliverAppBar(pinned: true, title: const Text('Cart'), actions: [buildUserMenuAction(context)]),

        // A) Items area
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _CartHeaderRow(),
                const Divider(height: 1),

                // item rows
                ...items.map((it) => _CartRow(item: it)),
                const Divider(height: 1),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // B) Subtotal 
        SliverToBoxAdapter(
          child: Card(
            margin: EdgeInsets.zero, // edge-to-edge
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // left align content
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('\$${subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Taxes and shipping are calculated at checkout.',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const SizedBox(height: 12),

                  // Checkout button on the LEFT (not stretched)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}

//Cart Table summary (static, no real qty changes)
class _CartHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: const [
          Expanded(flex: 5, child: Text('Product', style: TextStyle(fontWeight: FontWeight.w700))),
          Expanded(flex: 2, child: Text('Price', textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text('Qty', textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('Total', textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

//Price summary (subtotal)
class _CartRow extends StatelessWidget {
  final CartItem item;
  const _CartRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final total = p.price * item.qty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          // product cell
          Expanded(
            flex: 5,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: productImage(p.image, width: 64, height: 64, fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(p.brand, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // price
          Expanded(flex: 2, child: Text('\$${p.price.toStringAsFixed(0)}', textAlign: TextAlign.right)),
          // qty (static)
          const Expanded(flex: 2, child: Text('1–2', textAlign: TextAlign.center)),
          // total
          Expanded(flex: 2, child: Text('\$${total.toStringAsFixed(0)}', textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

/* PRODUCT CARD */

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
                      child: IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
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
                        child: const Text('Sale', style: TextStyle(fontWeight: FontWeight.w700)),
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
                        i < product.rating.round() ? Icons.star : Icons.star_border,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('(${product.rating.toStringAsFixed(1)})', style: const TextStyle(fontSize: 12)),
                  ]),
                  const SizedBox(height: 6),
                  Text(product.brand, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  Text(product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('\$${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 8),
                        Text('\$${product.oldPrice!.toStringAsFixed(0)}',
                            style:
                                const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white60)),
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
      appBar: AppBar(title: Text(product.name), actions: [buildUserMenuAction(context)]),
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
          Text(product.brand, style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600)),
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
                    style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.white60)),
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
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Demo: Add to cart not implemented')));
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
