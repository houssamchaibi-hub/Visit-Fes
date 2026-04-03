// lib/presentation/taste_of_page/pages/taste_of_fes_page.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';

// Category Enum
enum DishCategory {
  mainCourse,
  soup,
  dessert,
  bread,
  appetizer,
}

// Category Extensions - USING LOCALIZATION
extension DishCategoryExtension on DishCategory {
  String getName(AppLocalizations l10n) {
    switch (this) {
      case DishCategory.mainCourse:
        return l10n.mainCourse;
      case DishCategory.soup:
        return l10n.soup;
      case DishCategory.dessert:
        return l10n.dessert;
      case DishCategory.bread:
        return l10n.bread;
      case DishCategory.appetizer:
        return l10n.appetizer;
    }
  }

  Color get color {
    switch (this) {
      case DishCategory.mainCourse:
        return const Color(0xFFFF6B35);
      case DishCategory.soup:
        return const Color(0xFFC1440E);
      case DishCategory.dessert:
        return const Color(0xFFC19A6B);
      case DishCategory.bread:
        return const Color(0xFF9B6B3F);
      case DishCategory.appetizer:
        return const Color(0xFFFF8F00);
    }
  }

  IconData get icon {
    switch (this) {
      case DishCategory.mainCourse:
        return Icons.restaurant;
      case DishCategory.soup:
        return Icons.soup_kitchen;
      case DishCategory.dessert:
        return Icons.cake;
      case DishCategory.bread:
        return Icons.bakery_dining;
      case DishCategory.appetizer:
        return Icons.local_dining;
    }
  }
}

// Models
class MoroccanDish {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final List<String> variations;
  final String prepTime;
  final String cookTime;
  final String difficulty;
  final List<String> ingredients;
  final String price;
  final double priceValue;
  final DishCategory category;
  final List<String> images;

  MoroccanDish({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.variations,
    required this.prepTime,
    required this.cookTime,
    required this.difficulty,
    required this.ingredients,
    required this.price,
    required this.priceValue,
    required this.category,
    required this.images,
  });

  Color get color => category.color;
  IconData get icon => category.icon;

  Map<String, dynamic> toJson() => {
    'name': name,
    'nameAr': nameAr,
  };

  // Convert to favorite item format - IMPROVED
  Map<String, dynamic> toFavoriteItem(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'type': 'restaurant',
      'image': images.isNotEmpty ? images.first : '',
      'location': 'Fes, Morocco',
      'category': category.getName(l10n),
      'rating': 4.5,
      'reviews': 120,
      'price': price,
      'description': description,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'difficulty': difficulty,
      'priceValue': priceValue,
      'categoryType': category.toString(),
    };
  }
}

// Global navigator key for context access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Cart Item Model
class CartItem {
  final String dishName;
  final String dishNameAr;
  int quantity;
  final double price;

  CartItem({
    required this.dishName,
    required this.dishNameAr,
    this.quantity = 1,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'dishName': dishName,
    'dishNameAr': dishNameAr,
    'quantity': quantity,
    'price': price,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      dishName: json['dishName'],
      dishNameAr: json['dishNameAr'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}

// Storage Service (only for cart now, favorites handled by FavoritesManager)
class StorageService {
  static const String _cartKey = 'cart';

  static Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartKey);
      if (cartJson == null) return [];

      final List<dynamic> cartList = json.decode(cartJson);
      return cartList.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error loading cart: $e');
      return [];
    }
  }

  static Future<bool> saveCart(List<CartItem> cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson =
      json.encode(cart.map((e) => e.toJson()).toList());
      return await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      debugPrint('Error saving cart: $e');
      return false;
    }
  }
}

class TasteOfFesPage extends StatefulWidget {
  const TasteOfFesPage({super.key});

  @override
  State<TasteOfFesPage> createState() => _TasteOfFesPageState();
}

class _TasteOfFesPageState extends State<TasteOfFesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final FavoritesManager _favoritesManager = FavoritesManager();
  List<CartItem> _cart = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name';
  DishCategory? _selectedCategory;

  // Dishes will be created from localization
  late List<MoroccanDish> dishes;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create dishes from localization
    final l10n = AppLocalizations.of(context)!;
    dishes = _createLocalizedDishes(l10n);
    _loadData();
  }

  // Create dishes from localization strings
  List<MoroccanDish> _createLocalizedDishes(AppLocalizations l10n) {
    return [
      MoroccanDish(
        id: 'dish_tagine',
        name: l10n.tagine,
        nameAr: l10n.tagineAr,
        description: l10n.tagineDesc,
        variations: [
          l10n.tagineVariation1,
          l10n.tagineVariation2,
          l10n.tagineVariation3,
          l10n.tagineVariation4,
        ],
        prepTime: '30 min',
        cookTime: '2-3 hours',
        difficulty: 'Medium',
        ingredients: [
          l10n.tagineIngredient1,
          l10n.tagineIngredient2,
          l10n.tagineIngredient3,
          l10n.tagineIngredient4,
          l10n.tagineIngredient5,
          l10n.tagineIngredient6,
          l10n.tagineIngredient7,
        ],
        price: '80-120 MAD',
        priceValue: 100,
        category: DishCategory.mainCourse,
        images: [
          'https://images.pexels.com/photos/30068445/pexels-photo-30068445.jpeg',
          'https://i0.wp.com/coquendum.com/wp-content/uploads/2021/12/chicken-tagine.jpg?fit=1170%2C1170&ssl=1',
          'https://images.pexels.com/photos/4502970/pexels-photo-4502970.jpeg',
          'https://img.cuisineaz.com/660x660/2016/06/22/i29321-tajine-de-kefta.jpeg',
        ],
      ),
      MoroccanDish(
        id: 'dish_couscous',
        name: l10n.couscous,
        nameAr: l10n.couscousAr,
        description: l10n.couscousDesc,
        variations: [
          l10n.couscousVariation1,
          l10n.couscousVariation2,
          l10n.couscousVariation3,
          l10n.couscousVariation4,
        ],
        prepTime: '45 min',
        cookTime: '2 hours',
        difficulty: 'Medium-Hard',
        ingredients: [
          l10n.couscousIngredient1,
          l10n.couscousIngredient2,
          l10n.couscousIngredient3,
          l10n.couscousIngredient4,
          l10n.couscousIngredient5,
          l10n.couscousIngredient6,
          l10n.couscousIngredient7,
        ],
        price: '60-100 MAD',
        priceValue: 80,
        category: DishCategory.mainCourse,
        images: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ0FbtbzdFCRsAGewG_LraYngJPY-bMsOlpHg&s',
        ],
      ),
      MoroccanDish(
        id: 'dish_pastilla',
        name: l10n.pastilla,
        nameAr: l10n.pastillaAr,
        description: l10n.pastillaDesc,
        variations: [
          l10n.pastillaVariation1,
          l10n.pastillaVariation2,
          l10n.pastillaVariation3,
          l10n.pastillaVariation4,
        ],
        prepTime: '1 hour',
        cookTime: '45 min',
        difficulty: 'Hard',
        ingredients: [
          l10n.pastillaIngredient1,
          l10n.pastillaIngredient2,
          l10n.pastillaIngredient3,
          l10n.pastillaIngredient4,
          l10n.pastillaIngredient5,
          l10n.pastillaIngredient6,
          l10n.pastillaIngredient7,
          l10n.pastillaIngredient8,
        ],
        price: '150-250 MAD',
        priceValue: 200,
        category: DishCategory.appetizer,
        images: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAIj6lSYS3y_Y1E6-v3YXnmrqEqzdh9mMJ8g&s',
        ],
      ),
      MoroccanDish(
        id: 'dish_seffa',
        name: l10n.seffa,
        nameAr: l10n.seffaAr,
        description: l10n.seffaDesc,
        variations: [
          l10n.seffaVariation1,
          l10n.seffaVariation2,
          l10n.seffaVariation3,
          l10n.seffaVariation4,
        ],
        prepTime: '20 min',
        cookTime: '30 min',
        difficulty: 'Easy',
        ingredients: [
          l10n.seffaIngredient1,
          l10n.seffaIngredient2,
          l10n.seffaIngredient3,
          l10n.seffaIngredient4,
          l10n.seffaIngredient5,
          l10n.seffaIngredient6,
          l10n.seffaIngredient7,
        ],
        price: '40-70 MAD',
        priceValue: 55,
        category: DishCategory.dessert,
        images: [
          'https://images.pexels.com/photos/14855604/pexels-photo-14855604.jpeg',
        ],
      ),
      MoroccanDish(
        id: 'dish_harira',
        name: l10n.harira,
        nameAr: l10n.hariraAr,
        description: l10n.hariraDesc,
        variations: [
          l10n.hariraVariation1,
          l10n.hariraVariation2,
          l10n.hariraVariation3,
          l10n.hariraVariation4,
        ],
        prepTime: '20 min',
        cookTime: '1.5 hours',
        difficulty: 'Easy-Medium',
        ingredients: [
          l10n.hariraIngredient1,
          l10n.hariraIngredient2,
          l10n.hariraIngredient3,
          l10n.hariraIngredient4,
          l10n.hariraIngredient5,
          l10n.hariraIngredient6,
          l10n.hariraIngredient7,
          l10n.hariraIngredient8,
          l10n.hariraIngredient9,
        ],
        price: '15-30 MAD',
        priceValue: 22.5,
        category: DishCategory.soup,
        images: [
          'https://images.pexels.com/photos/15646124/pexels-photo-15646124.jpeg',
        ],
      ),
      MoroccanDish(
        id: 'dish_rfissa',
        name: l10n.rfissa,
        nameAr: l10n.rfissaAr,
        description: l10n.rfissaDesc,
        variations: [
          l10n.rfissaVariation1,
          l10n.rfissaVariation2,
          l10n.rfissaVariation3,
          l10n.rfissaVariation4,
        ],
        prepTime: '30 min',
        cookTime: '2 hours',
        difficulty: 'Medium-Hard',
        ingredients: [
          l10n.rfissaIngredient1,
          l10n.rfissaIngredient2,
          l10n.rfissaIngredient3,
          l10n.rfissaIngredient4,
          l10n.rfissaIngredient5,
          l10n.rfissaIngredient6,
          l10n.rfissaIngredient7,
          l10n.rfissaIngredient8,
        ],
        price: '70-110 MAD',
        priceValue: 90,
        category: DishCategory.bread,
        images: [
          'https://www.samia.fr/wp-content/uploads/2015/06/ob_693da6_jkih.jpg',
        ],
      ),
    ];
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final cart = await StorageService.loadCart();

      setState(() {
        _cart = cart;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // IMPROVED: Better favorite toggle with error handling and animation
  Future<void> _toggleFavorite(MoroccanDish dish) async {
    try {
      final wasFavorite = _favoritesManager.isFavorite(dish.id);

      await _favoritesManager.toggleFavorite(dish.toFavoriteItem(context));

      if (mounted) {
        final isFavorite = _favoritesManager.isFavorite(dish.id);
        final l10n = AppLocalizations.of(context)!;

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isFavorite
                        ? '${dish.name} added to favorites'
                        : '${dish.name} removed from favorites',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: dish.color,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            action: isFavorite
                ? null
                : SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () async {
                await _favoritesManager.toggleFavorite(
                  dish.toFavoriteItem(context),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'An error occurred',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _addToCart(MoroccanDish dish) async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      final existingIndex =
      _cart.indexWhere((item) => item.dishName == dish.name);

      if (existingIndex != -1) {
        _cart[existingIndex].quantity++;
      } else {
        _cart.add(CartItem(
          dishName: dish.name,
          dishNameAr: dish.nameAr,
          price: dish.priceValue,
        ));
      }
    });

    await StorageService.saveCart(_cart);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text('${dish.name} ${l10n.addedToCart}'),
              ),
            ],
          ),
          backgroundColor: dish.color,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showDishDetails(MoroccanDish dish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DishDetailsModal(
        dish: dish,
        onAddToCart: () => _addToCart(dish),
        isFavorite: _favoritesManager.isFavorite(dish.id),
        onToggleFavorite: () => _toggleFavorite(dish),
      ),
    );
  }

  void _showCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(
          cart: _cart,
          dishes: dishes,
          onUpdateCart: (updatedCart) async {
            setState(() {
              _cart = updatedCart;
            });
            await StorageService.saveCart(_cart);
          },
        ),
      ),
    );
  }

  List<MoroccanDish> get _filteredDishes {
    var filtered = dishes.where((dish) {
      final matchesSearch = _searchQuery.isEmpty ||
          dish.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          dish.nameAr.contains(_searchQuery) ||
          dish.description.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _selectedCategory == null || dish.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    switch (_sortBy) {
      case 'price':
        filtered.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 'difficulty':
        final difficultyOrder = {
          'Easy': 1,
          'Easy-Medium': 2,
          'Medium': 3,
          'Medium-Hard': 4,
          'Hard': 5
        };
        filtered.sort((a, b) {
          final aOrder = difficultyOrder[a.difficulty] ?? 0;
          final bOrder = difficultyOrder[b.difficulty] ?? 0;
          return aOrder.compareTo(bOrder);
        });
        break;
      case 'favorites':
      // IMPROVED: Add sorting by favorites
        filtered.sort((a, b) {
          final aFav = _favoritesManager.isFavorite(a.id) ? 1 : 0;
          final bFav = _favoritesManager.isFavorite(b.id) ? 1 : 0;
          return bFav.compareTo(aFav);
        });
        break;
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return filtered;
  }

  int get _totalCartItems {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }

  // IMPROVED: Get total favorites count
  int get _totalFavorites {
    return dishes.where((dish) => _favoritesManager.isFavorite(dish.id)).length;
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 0.7;
    if (width >= 900) return 0.65;
    if (width >= 600) return 0.65;
    return 0.62;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFFF6B35),
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.oopsSomethingWrong,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.tryAgain),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Color(0xFFFF6B35),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loading,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // IMPROVED: Add favorites counter
              if (_totalFavorites > 0)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _sortBy = 'favorites';
                        });
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$_totalFavorites',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white),
                    onPressed: _showCartPage,
                  ),
                  if (_totalCartItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$_totalCartItems',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF2D2D2D),
                          Color(0xFF1A1A1A),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFF6B35).withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.restaurant_menu,
                              size: 32,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFFF8F00),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              l10n.tasteOfFes,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.authenticMoroccanDishes,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search and Filters
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: l10n.searchDishes,
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFFF6B35),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.white),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: l10n.all,
                          isSelected: _selectedCategory == null,
                          color: const Color(0xFFFF6B35),
                          onTap: () {
                            setState(() {
                              _selectedCategory = null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        ...DishCategory.values.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _CategoryChip(
                              label: category.getName(l10n),
                              isSelected: _selectedCategory == category,
                              color: category.color,
                              icon: category.icon,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sort Options - IMPROVED: Added favorites sort
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _SortChip(
                          label: l10n.name,
                          isSelected: _sortBy == 'name',
                          onTap: () {
                            setState(() {
                              _sortBy = 'name';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _SortChip(
                          label: l10n.price,
                          isSelected: _sortBy == 'price',
                          onTap: () {
                            setState(() {
                              _sortBy = 'price';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _SortChip(
                          label: l10n.difficulty,
                          isSelected: _sortBy == 'difficulty',
                          onTap: () {
                            setState(() {
                              _sortBy = 'difficulty';
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _SortChip(
                          label: 'Favorites',
                          icon: Icons.favorite,
                          isSelected: _sortBy == 'favorites',
                          onTap: () {
                            setState(() {
                              _sortBy = 'favorites';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Results count
          if (_searchQuery.isNotEmpty || _selectedCategory != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${l10n.found} ${_filteredDishes.length} ${_filteredDishes.length != 1 ? l10n.dishes : l10n.dish}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ),

          // Dishes Grid
          _filteredDishes.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noDishesFound,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context),
                childAspectRatio: _getChildAspectRatio(context),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final dish = _filteredDishes[index];
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delay = index * 0.1;
                      final animationValue = Curves.easeOutCubic
                          .transform(
                        math.max(
                            0,
                            (_animationController.value - delay) /
                                (1 - delay)),
                      );

                      return Opacity(
                        opacity: animationValue,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - animationValue)),
                          child: child,
                        ),
                      );
                    },
                    child: DishCard(
                      dish: dish,
                      isFavorite: _favoritesManager.isFavorite(dish.id),
                      onTap: () => _showDishDetails(dish),
                      onFavoriteToggle: () => _toggleFavorite(dish),
                      onAddToCart: () => _addToCart(dish),
                    ),
                  );
                },
                childCount: _filteredDishes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final IconData? icon;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.color,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 18,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sort Chip Widget - IMPROVED: Added icon support
class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6B35)
              : const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF6B35)
                : const Color(0xFFFF6B35).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? (isSelected ? Icons.check : Icons.sort),
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Dish Card with Image - IMPROVED: Added favorite animation
class DishCard extends StatefulWidget {
  final MoroccanDish dish;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;

  const DishCard({
    super.key,
    required this.dish,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onAddToCart,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _favoriteAnimationController;
  late Animation<double> _favoriteScaleAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _favoriteScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _favoriteAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(DishCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _favoriteAnimationController.forward().then((_) {
        _favoriteAnimationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _favoriteAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.03 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2D2D2D).withOpacity(0.9),
                  const Color(0xFF1A1A1A).withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? widget.dish.color.withOpacity(0.5)
                    : widget.dish.color.withOpacity(0.2),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: widget.dish.color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.dish.images.first,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: widget.dish.color.withOpacity(0.3),
                            highlightColor: widget.dish.color.withOpacity(0.5),
                            child: Container(
                              color: widget.dish.color.withOpacity(0.3),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  widget.dish.color.withOpacity(0.3),
                                  widget.dish.color.withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                widget.dish.icon,
                                size: 48,
                                color: widget.dish.color.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      // Category Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: widget.dish.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.dish.icon,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.dish.category.getName(l10n),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Favorite Button - IMPROVED: Added animation
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: widget.onFavoriteToggle,
                          child: AnimatedBuilder(
                            animation: _favoriteScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _favoriteScaleAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    widget.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: widget.isFavorite
                                        ? widget.dish.color
                                        : Colors.white,
                                    size: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Info Section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.dish.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.dish.nameAr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Amiri',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.dish.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: widget.dish.color.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                widget.dish.price,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: widget.dish.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dish Details Modal - Same as before, no changes needed
class DishDetailsModal extends StatelessWidget {
  final MoroccanDish dish;
  final VoidCallback onAddToCart;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const DishDetailsModal({
    super.key,
    required this.dish,
    required this.onAddToCart,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // Image Header
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                    child: CachedNetworkImage(
                      imageUrl: dish.images.first,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: dish.color.withOpacity(0.3),
                        highlightColor: dish.color.withOpacity(0.5),
                        child: Container(
                          color: dish.color.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  // Close Button
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  // Category Badge
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: dish.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            dish.icon,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dish.category.getName(l10n),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Title
                  Positioned(
                    bottom: 20,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          dish.nameAr,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Price and Actions
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: dish.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: dish.color.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.startingFrom,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dish.price,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: dish.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: onToggleFavorite,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? dish.color
                                    : Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                onAddToCart();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: dish.color,
                                foregroundColor: Colors.white,
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                l10n.order,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Cart Page - Same as before, no changes needed
class CartPage extends StatefulWidget {
  final List<CartItem> cart;
  final List<MoroccanDish> dishes;
  final Function(List<CartItem>) onUpdateCart;

  const CartPage({
    super.key,
    required this.cart,
    required this.dishes,
    required this.onUpdateCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartItem> _cart;

  @override
  void initState() {
    super.initState();
    _cart = List.from(widget.cart);
  }

  double get _totalPrice {
    return _cart.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _cart[index].quantity += change;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
    });
    widget.onUpdateCart(_cart);
  }

  MoroccanDish? _getDishByName(String name) {
    try {
      return widget.dishes.firstWhere((dish) => dish.name == name);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(
          l10n.myCart,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cart.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.yourCartIsEmpty,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 20,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                final dish = _getDishByName(item.dishName);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dish != null
                          ? dish.color.withOpacity(0.3)
                          : const Color(0xFFFF6B35).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dish != null
                              ? dish.color.withOpacity(0.15)
                              : const Color(0xFFFF6B35).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          dish?.icon ?? Icons.restaurant,
                          color: dish?.color ?? const Color(0xFFFF6B35),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.dishName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item.dishNameAr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontFamily: 'Amiri',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.price.toStringAsFixed(0)} MAD',
                              style: TextStyle(
                                color: dish?.color ??
                                    const Color(0xFFFF6B35),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Colors.white),
                              onPressed: () => _updateQuantity(index, -1),
                              iconSize: 20,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add,
                                  color: Colors.white),
                              onPressed: () => _updateQuantity(index, 1),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.total,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${_totalPrice.toStringAsFixed(0)} MAD',
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.checkout,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}