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

  Widget _buildBody(bool isTablet) {
    switch (_index) {
      case 0:
        return LuxeHome(isTablet: isTablet);
      case 1:
        return const ProductsPage();
      case 2:
        return const WishlistScreen();
      case 3:
        return const CartScreen();
      default:
        return LuxeHome(isTablet: isTablet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 900;
  
    return Scaffold(
      body: _buildBody(isTablet),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
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
      setState(() => _products = []);
    } finally {
      setState(() => _loading = false);
    }
  }
  List<Product> get _filteredProducts {
    if (_query.isEmpty) return _products;

    final q = _query.toLowerCase();
    return _products.where((p) {
      return p.brand.toLowerCase().contains(q) ||
            p.model.toLowerCase().contains(q);
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filtered = _filteredProducts
        .where((p) =>
            p.brand.toLowerCase().contains(_query.toLowerCase()) ||
            p.model.toLowerCase().contains(_query.toLowerCase()))
        .take(4)
        .toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const Text('LUXEWATCH'),
          actions: const [UserMenuAction()],
        ),
        
        // SEARCH
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: LuxeSearchBar(
              hint: 'Search luxury watches',
              onChanged: (value) {
                setState(() => _query = value);
              },
            ),
          ),
        ),

        // TITLE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Featured',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),

        // GRID
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ProductCard(
                product: filtered[i],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: filtered[i]),
                    ),
                  );
                },
              ),
              childCount: filtered.length,
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
  String _query = '';
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
    return _products.where((p) {
      final matchesBrand =
          _selectedBrand == 'All' ||
          p.brand.toLowerCase() == _selectedBrand.toLowerCase();

      final matchesQuery =
          _query.isEmpty ||
          p.brand.toLowerCase().contains(_query.toLowerCase()) ||
          p.model.toLowerCase().contains(_query.toLowerCase());

      return matchesBrand && matchesQuery;
    }).toList();
  }

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
      setState(() => _products = []);
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

        // SEARCH
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: LuxeSearchBar(
              hint: 'Search collection',
              onChanged: (value) {
                setState(() => _query = value);
              },
            ),
          ),
        ),


        // BRAND FILTERS
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

        // CONTENT
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