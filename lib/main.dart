import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/product_service.dart';
import 'services/api_service.dart';
import 'widgets/product_card.dart';
import 'widgets/user_menu_action.dart';
import 'models/product.dart';

// ================= THEME MODE =================

final ValueNotifier<ThemeMode> appThemeMode =
    ValueNotifier(ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken();
  runApp(const LuxeWatchApp());
}

/* ================= APP ROOT ================= */

class LuxeWatchApp extends StatelessWidget {
  const LuxeWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF0B0F14),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFD4AF37),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0B0F14),
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF121826),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (_, mode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'LuxeWatch',
          theme: darkTheme,
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}

/* ================= HOME SHELL ================= */

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      body: _index == 0
          ? LuxeHome(isTablet: isTablet)
          : const ProductsPage(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.storefront), label: 'Products'),
        ],
      ),
    );
  }
}

/* ================= HOME ================= */

class LuxeHome extends StatefulWidget {
  final bool isTablet;
  const LuxeHome({super.key, required this.isTablet});

  @override
  State<LuxeHome> createState() => _LuxeHomeState();
}

class _LuxeHomeState extends State<LuxeHome> {
  bool _loading = true;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final apiProducts = await ProductService.getProducts();
      _products = apiProducts
          .map((p) => Product(
                id: p.id,
                brand: p.brand,
                model: p.model,
                imageUrl: p.imageUrl,
                price: p.price,
              ))
          .toList();
    } catch (_) {
      _products = [];
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products available',
            style: TextStyle(color: Colors.white54)),
      );
    }

    final featured = _products.take(4).toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('LUXEWATCH'),
          actions: const [UserMenuAction()],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Explore',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ProductCard(
                product: featured[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: featured[i]),
                    ),
                  );
                },
              ),
              childCount: featured.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.isTablet ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
          ),
        ),
      ],
    );
  }
}

/* ================= PRODUCTS PAGE ================= */

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _loading = true;
  String _selectedBrand = 'All';

  final List<String> _brands = [
    'All',
    'Rolex',
    'Omega',
    'IWC',
    'Patek',
  ];

  List<Product> _products = [];

  List<Product> get _filteredProducts {
    if (_selectedBrand == 'All') return _products;
    return _products
        .where((p) =>
            p.brand.toLowerCase() == _selectedBrand.toLowerCase())
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final apiProducts = await ProductService.getProducts();
      _products = apiProducts
          .map((p) => Product(
                id: p.id,
                brand: p.brand,
                model: p.model,
                imageUrl: p.imageUrl,
                price: p.price,
              ))
          .toList();
    } catch (_) {
      _products = [];
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('Products'),
          actions: const [UserMenuAction()],
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: _brands.map((brand) {
                final selected = brand == _selectedBrand;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(brand),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedBrand = brand),
                    selectedColor:
                        Theme.of(context).colorScheme.primary,
                    backgroundColor: const Color(0xFF121826),
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        if (_loading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => ProductCard(
                  product: _filteredProducts[i],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(
                            product: _filteredProducts[i]),
                      ),
                    );
                  },
                ),
                childCount: _filteredProducts.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
            ),
          ),
      ],
    );
  }
}
