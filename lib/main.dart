import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/product_service.dart';
import 'services/api_service.dart';
import 'widgets/product_card.dart';
import 'widgets/user_menu_action.dart';
import 'models/product.dart';
import 'screens/wishlist_screen.dart';
import 'screens/cart_screen.dart';
import 'widgets/search_bar.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/battery_provider.dart';
import 'widgets/luxe_hero.dart';

// ================= THEME MODE =================

final ValueNotifier<ThemeMode> appThemeMode =
    ValueNotifier(ThemeMode.dark);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken();

  final savedTheme = await ThemeService.loadTheme();
  appThemeMode.value = savedTheme;

  runApp(const LuxeWatchApp());
}

// ================= APP ROOT =================

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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => AuthProvider()..loadProfile(),
            ),
            ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
            ChangeNotifierProvider(create: (_) => BatteryProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LuxeWatch',
            theme: darkTheme,
            themeMode: mode,
            home: const SplashScreen(),
          ),

        );
      },
    );
  }
}

// ================= HOME SHELL =================

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  Widget _page(bool isTablet) {
    switch (_index) {
      case 0:
        return LuxeHome(isTablet: isTablet,
            onShop: () =>
              setState(() => _index = 1),
              
        );
      case 1:
        return const ProductsPage();
      case 2:
        return const WishlistScreen();
      case 3:
        return const CartScreen();
      default:
        return LuxeHome(isTablet: isTablet,
            onShop: () =>
              setState(() => _index = 1),
              
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 900;

    // ===== MOBILE =====
    if (!isTablet) {
      return Scaffold(
        body: _page(false),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
          ],
        ),
        
      );
    }

    // ===== TABLET / LANDSCAPE =====
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            extended: true,
            backgroundColor: const Color(0xFF0B0F14),
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary,
            ),
            selectedLabelTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('Wishlist'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: Text('Cart'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _page(true)),
        ],
      ),
    );
  }
}

// ================= HOME =================

class LuxeHome extends StatefulWidget {
  final bool isTablet;
  final VoidCallback onShop;
  const LuxeHome({super.key, required this.isTablet, required this.onShop});

  @override
  State<LuxeHome> createState() => _LuxeHomeState();
}

class _LuxeHomeState extends State<LuxeHome> {
  bool _loading = true;
  String _query = '';
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
  try {
    final apiProducts = await ProductService.getProducts();

    setState(() {
      _products = apiProducts
          .map((p) => Product(
                id: p.id,
                brand: p.brand,
                model: p.model,
                imageUrl: p.imageUrl,
                price: p.price,
              ))
          .toList();
    });
  } catch (_) {
    setState(() {
      _products = [];
    });
  } finally {
    setState(() => _loading = false);
  }
}


  List<Product> get _filtered {
    if (_query.isEmpty) return _products;
    final q = _query.toLowerCase();
    return _products
        .where((p) =>
            p.brand.toLowerCase().contains(q) ||
            p.model.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final featured = _filtered.take(4).toList();

    return CustomScrollView(
      slivers: [

        SliverAppBar(
          pinned: true,
          title: const Text('LUXEWATCH'),
          actions: const [UserMenuAction()],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: LuxeSearchBar(
              hint: 'Search collection',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LuxeHero(
              onShop: () {
              },
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Featured',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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

// ================= PRODUCTS PAGE =================

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _loading = true;
  String _query = '';
  String _selectedBrand = 'All';

  final _brands = ['All', 'Rolex', 'Omega', 'IWC'];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final apiProducts = await ProductService.getProducts();

      setState(() {
        _products = apiProducts
            .map((p) => Product(
                  id: p.id,
                  brand: p.brand,
                  model: p.model,
                  imageUrl: p.imageUrl,
                  price: p.price,
                ))
            .toList();
      });
    } catch (_) {
      setState(() {
        _products = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }


  List<Product> get _filtered {
    return _products.where((p) {
      final brandOk =
          _selectedBrand == 'All' ||
          p.brand.toLowerCase() == _selectedBrand.toLowerCase();

      final queryOk =
          _query.isEmpty ||
          p.brand.toLowerCase().contains(_query.toLowerCase()) ||
          p.model.toLowerCase().contains(_query.toLowerCase());

      return brandOk && queryOk;
    }).toList();
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: LuxeSearchBar(
              hint: 'Search collection',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 44,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: _brands.map((b) {
                final selected = b == _selectedBrand;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(b),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedBrand = b),
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
                  product: _filtered[i],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: _filtered[i]),
                      ),
                    );
                  },
                ),
                childCount: _filtered.length,
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
