// lib/presentation/shopping/pages/what_to_buy_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';
import 'dart:math' as math;
import 'product_details_page.dart';

// ============================================================================
// MODELS
// ============================================================================

class FesProduct {
  final String id;
  final String name;
  final String nameAr;
  final String category;
  final String description;
  final List<String> images;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;
  final List<String> characteristics;
  final String whereToFind;
  final bool isHandmade;
  final String quality;

  FesProduct({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.category,
    required this.description,
    required this.images,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
    required this.characteristics,
    required this.whereToFind,
    required this.isHandmade,
    required this.quality,
  });

  /// Convert to the Map format used by FavoritesManager.
  /// Stores enough data to fully reconstruct the FesProduct later.
  Map<String, dynamic> toFavoriteMap() => {
    'id': id,
    'name': name,
    'nameAr': nameAr,
    'type': 'product',
    'image': images.isNotEmpty ? images.first : '',
    'images': images,                         // full list for carousel
    'category': category,
    'description': description,
    'whereToFind': whereToFind,
    'quality': quality,
    'isHandmade': isHandmade,
    'primaryColor': primaryColor.value,       // stored as int
    'accentColor': accentColor.value,
    'iconCodePoint': icon.codePoint,
    'characteristics': characteristics,
  };

  /// Reconstruct a FesProduct from a FavoritesManager map entry.
  /// Used by FavoritesPage to open the product detail modal without
  /// needing ShoppingData in context.
  factory FesProduct.fromFavoriteMap(Map<String, dynamic> map) {
    // Images: prefer full list, fall back to single image field
    final List<String> imgs = map['images'] != null
        ? List<String>.from(map['images'])
        : (map['image'] != null ? [map['image'] as String] : []);

    // Colors: default to orange/amber if not stored (old data)
    final Color primary = map['primaryColor'] != null
        ? Color(map['primaryColor'] as int)
        : const Color(0xFFFF6B35);
    final Color accent = map['accentColor'] != null
        ? Color(map['accentColor'] as int)
        : const Color(0xFFFF8F5A);

    // Icon: default to shopping_bag if not stored
    final IconData icon = map['iconCodePoint'] != null
        ? IconData(map['iconCodePoint'] as int, fontFamily: 'MaterialIcons')
        : Icons.shopping_bag;

    final List<String> chars = map['characteristics'] != null
        ? List<String>.from(map['characteristics'])
        : [];

    return FesProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      nameAr: (map['nameAr'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      images: imgs,
      primaryColor: primary,
      accentColor: accent,
      icon: icon,
      characteristics: chars,
      whereToFind: (map['whereToFind'] ?? '') as String,
      isHandmade: (map['isHandmade'] ?? false) as bool,
      quality: (map['quality'] ?? '') as String,
    );
  }
}

class CategoryData {
  final String name;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final Color accentColor;

  const CategoryData({
    required this.name,
    required this.imageUrl,
    required this.icon,
    required this.color,
    required this.accentColor,
  });
}

enum SortBy {
  nameAZ,
  nameZA,
}

// ============================================================================
// CONSTANTS - COLOR PALETTE
// ============================================================================

class AppColors {
  static const background = Color(0xFF0F0F0F);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceLight = Color(0xFF242424);

  static const leather = Color(0xFFD4845C);
  static const leatherAccent = Color(0xFFFF9B71);

  static const ceramics = Color(0xFF4A9FF5);
  static const ceramicsAccent = Color(0xFF6BB6FF);

  static const textiles = Color(0xFFE63946);
  static const textilesAccent = Color(0xFFFF5A65);

  static const metalwork = Color(0xFFFFBB00);
  static const metalworkAccent = Color(0xFFFFD54F);

  static const spices = Color(0xFFFF6B35);
  static const spicesAccent = Color(0xFFFF8F5A);

  static const cosmetics = Color(0xFF06D6A0);
  static const cosmeticsAccent = Color(0xFF2EEDB7);

  static const all = Color(0xFF9D4EDD);
  static const allAccent = Color(0xFFB86EFF);
}

Map<String, CategoryData> getCategoryDataMap(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return {
    'All': CategoryData(
      name: l10n.categoryAll,
      imageUrl: 'https://images.pexels.com/photos/5650026/pexels-photo-5650026.jpeg',
      icon: Icons.grid_view_rounded,
      color: AppColors.all,
      accentColor: AppColors.allAccent,
    ),
    'Leather': CategoryData(
      name: l10n.categoryLeather,
      imageUrl: 'https://images.pexels.com/photos/35787274/pexels-photo-35787274.jpeg',
      icon: Icons.shopping_bag_outlined,
      color: AppColors.leather,
      accentColor: AppColors.leatherAccent,
    ),
    'Ceramics': CategoryData(
      name: l10n.categoryCeramics,
      imageUrl: 'https://images.pexels.com/photos/35787273/pexels-photo-35787273.jpeg',
      icon: Icons.catching_pokemon_outlined,
      color: AppColors.ceramics,
      accentColor: AppColors.ceramicsAccent,
    ),
    'Textiles': CategoryData(
      name: l10n.categoryTextiles,
      imageUrl: 'https://images.pexels.com/photos/6044266/pexels-photo-6044266.jpeg',
      icon: Icons.checkroom_outlined,
      color: AppColors.textiles,
      accentColor: AppColors.textilesAccent,
    ),
    'Metalwork': CategoryData(
      name: l10n.categoryMetalwork,
      imageUrl: 'https://images.pexels.com/photos/6207873/pexels-photo-6207873.jpeg',
      icon: Icons.lightbulb_outline,
      color: AppColors.metalwork,
      accentColor: AppColors.metalworkAccent,
    ),
    'Spices': CategoryData(
      name: l10n.categorySpices,
      imageUrl: 'https://images.pexels.com/photos/4198951/pexels-photo-4198951.jpeg',
      icon: Icons.spa_outlined,
      color: AppColors.spices,
      accentColor: AppColors.spicesAccent,
    ),
    'Cosmetics': CategoryData(
      name: l10n.categoryCosmetics,
      imageUrl: 'https://images.pexels.com/photos/4465831/pexels-photo-4465831.jpeg',
      icon: Icons.water_drop_outlined,
      color: AppColors.cosmetics,
      accentColor: AppColors.cosmeticsAccent,
    ),
  };
}

// ============================================================================
// STATE MANAGEMENT - INHERITED WIDGET
// ============================================================================

class ShoppingData extends InheritedWidget {
  final List<FesProduct> allProducts;
  final FavoritesManager favoritesManager; // ✅ Use FavoritesManager directly
  final String searchQuery;
  final String selectedCategory;
  final SortBy sortBy;
  final bool showHandmadeOnly;
  final Function(String) setSearchQuery;
  final Function(String) setCategory;
  final Function(SortBy) setSortBy;
  final Function(bool) setHandmadeOnly;
  final Function(FesProduct) toggleFavorite; // ✅ Takes FesProduct now
  final Function() resetFilters;

  const ShoppingData({
    super.key,
    required super.child,
    required this.allProducts,
    required this.favoritesManager,
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortBy,
    required this.showHandmadeOnly,
    required this.setSearchQuery,
    required this.setCategory,
    required this.setSortBy,
    required this.setHandmadeOnly,
    required this.toggleFavorite,
    required this.resetFilters,
  });

  static ShoppingData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShoppingData>();
  }

  static ShoppingData of(BuildContext context) {
    final ShoppingData? result = maybeOf(context);
    assert(result != null, 'No ShoppingData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ShoppingData oldWidget) {
    return searchQuery != oldWidget.searchQuery ||
        selectedCategory != oldWidget.selectedCategory ||
        sortBy != oldWidget.sortBy ||
        showHandmadeOnly != oldWidget.showHandmadeOnly;
    // FavoritesManager notifications are handled separately via ChangeNotifier
  }

  /// ✅ Delegates to FavoritesManager
  bool isFavorite(String productId) => favoritesManager.isFavorite(productId);

  List<FesProduct> get filteredProducts {
    var filtered = allProducts.where((product) {
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.nameAr.contains(query) &&
            !product.category.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (selectedCategory != 'All' && product.category != selectedCategory) {
        return false;
      }

      if (showHandmadeOnly && !product.isHandmade) {
        return false;
      }

      return true;
    }).toList();

    switch (sortBy) {
      case SortBy.nameAZ:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.nameZA:
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    return filtered;
  }
}

// ============================================================================
// LOCALIZED PRODUCTS FACTORY
// ============================================================================

List<FesProduct> getLocalizedProducts(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return [
    FesProduct(
      id: 'textile_001',
      name: l10n.moroccanCarpetsName,
      nameAr: l10n.moroccanCarpetsNameAr,
      category: l10n.categoryTextiles,
      description: l10n.moroccanCarpetsDesc,
      images: [
        'https://images.pexels.com/photos/28582589/pexels-photo-28582589.jpeg',
        'https://images.pexels.com/photos/8318195/pexels-photo-8318195.jpeg',
      ],
      primaryColor: AppColors.textiles,
      accentColor: AppColors.textilesAccent,
      icon: Icons.texture,
      characteristics: [
        l10n.moroccanCarpetsChar1,
        l10n.moroccanCarpetsChar2,
        l10n.moroccanCarpetsChar3,
        l10n.moroccanCarpetsChar4,
      ],
      whereToFind: l10n.moroccanCarpetsWhere,
      isHandmade: true,
      quality: l10n.qualityLuxury,
    ),
    FesProduct(
      id: 'textile_002',
      name: l10n.embroideredKaftansName,
      nameAr: l10n.embroideredKaftansNameAr,
      category: l10n.categoryTextiles,
      description: l10n.embroideredKaftansDesc,
      images: [
        'https://images.pexels.com/photos/33408992/pexels-photo-33408992.jpeg',
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxBX23K2fF6FOmSCNKKTVrJtNK02zxMY5ejA&s',
      ],
      primaryColor: AppColors.textiles,
      accentColor: AppColors.textilesAccent,
      icon: Icons.checkroom,
      characteristics: [
        l10n.embroideredKaftansChar1,
        l10n.embroideredKaftansChar2,
        l10n.embroideredKaftansChar3,
        l10n.embroideredKaftansChar4,
      ],
      whereToFind: l10n.embroideredKaftansWhere,
      isHandmade: true,
      quality: l10n.qualityLuxury,
    ),
    FesProduct(
      id: 'leather_002',
      name: l10n.leatherBagsName,
      nameAr: l10n.leatherBagsNameAr,
      category: l10n.categoryLeather,
      description: l10n.leatherBagsDesc,
      images: [
        'https://images.pexels.com/photos/21326994/pexels-photo-21326994.jpeg',
      ],
      primaryColor: AppColors.leather,
      accentColor: AppColors.leatherAccent,
      icon: Icons.shopping_bag,
      characteristics: [
        l10n.leatherBagsChar1,
        l10n.leatherBagsChar2,
        l10n.leatherBagsChar3,
        l10n.leatherBagsChar4,
      ],
      whereToFind: l10n.leatherBagsWhere,
      isHandmade: true,
      quality: l10n.qualityPremium,
    ),
    FesProduct(
      id: 'leather_001',
      name: l10n.leatherBabouchesName,
      nameAr: l10n.leatherBabouchesNameAr,
      category: l10n.categoryLeather,
      description: l10n.leatherBabouchesDesc,
      images: [
        'https://images.pexels.com/photos/35787272/pexels-photo-35787272.jpeg',
        'https://images.pexels.com/photos/21243915/pexels-photo-21243915.jpeg',
      ],
      primaryColor: AppColors.leather,
      accentColor: AppColors.leatherAccent,
      icon: Icons.local_mall,
      characteristics: [
        l10n.leatherBabouchesChar1,
        l10n.leatherBabouchesChar2,
        l10n.leatherBabouchesChar3,
        l10n.leatherBabouchesChar4,
      ],
      whereToFind: l10n.leatherBabouchesWhere,
      isHandmade: true,
      quality: l10n.qualityPremium,
    ),
    FesProduct(
      id: 'metal_002',
      name: l10n.copperTeapotsName,
      nameAr: l10n.copperTeapotsNameAr,
      category: l10n.categoryMetalwork,
      description: l10n.copperTeapotsDesc,
      images: [
        'https://www.palaisfaraj.com/wp-content/uploads/2024/07/the-a-la-menthe-Palais-Faraj-3.jpg',
      ],
      primaryColor: AppColors.metalwork,
      accentColor: AppColors.metalworkAccent,
      icon: Icons.coffee,
      characteristics: [
        l10n.copperTeapotsChar1,
        l10n.copperTeapotsChar2,
        l10n.copperTeapotsChar3,
        l10n.copperTeapotsChar4,
      ],
      whereToFind: l10n.copperTeapotsWhere,
      isHandmade: true,
      quality: l10n.qualityAuthentic,
    ),
    FesProduct(
      id: 'metal_001',
      name: l10n.brassLanternsName,
      nameAr: l10n.brassLanternsNameAr,
      category: l10n.categoryMetalwork,
      description: l10n.brassLanternsDesc,
      images: [
        'https://images.pexels.com/photos/18687094/pexels-photo-18687094.jpeg',
      ],
      primaryColor: AppColors.metalwork,
      accentColor: AppColors.metalworkAccent,
      icon: Icons.light_mode,
      characteristics: [
        l10n.brassLanternsChar1,
        l10n.brassLanternsChar2,
        l10n.brassLanternsChar3,
        l10n.brassLanternsChar4,
      ],
      whereToFind: l10n.brassLanternsWhere,
      isHandmade: true,
      quality: l10n.qualityPremium,
    ),
    FesProduct(
      id: 'ceramic_001',
      name: l10n.fesBluePotteryName,
      nameAr: l10n.fesBluePotteryNameAr,
      category: l10n.categoryCeramics,
      description: l10n.fesBluePotteryDesc,
      images: [
        'https://images.pexels.com/photos/27806626/pexels-photo-27806626.jpeg',
        'https://images.pexels.com/photos/35787273/pexels-photo-35787273.jpeg',
      ],
      primaryColor: AppColors.ceramics,
      accentColor: AppColors.ceramicsAccent,
      icon: Icons.deck,
      characteristics: [
        l10n.fesBluePotteryChar1,
        l10n.fesBluePotteryChar2,
        l10n.fesBluePotteryChar3,
        l10n.fesBluePotteryChar4,
      ],
      whereToFind: l10n.fesBluePotteryWhere,
      isHandmade: true,
      quality: l10n.qualityAuthentic,
    ),
    FesProduct(
      id: 'ceramic_002',
      name: l10n.ceramicTajineName,
      nameAr: l10n.ceramicTajineNameAr,
      category: l10n.categoryCeramics,
      description: l10n.ceramicTajineDesc,
      images: [
        'https://images.pexels.com/photos/30312576/pexels-photo-30312576.jpeg',
      ],
      primaryColor: AppColors.ceramics,
      accentColor: AppColors.ceramicsAccent,
      icon: Icons.restaurant,
      characteristics: [
        l10n.ceramicTajineChar1,
        l10n.ceramicTajineChar2,
        l10n.ceramicTajineChar3,
        l10n.ceramicTajineChar4,
      ],
      whereToFind: l10n.ceramicTajineWhere,
      isHandmade: true,
      quality: l10n.qualityPremium,
    ),
    FesProduct(
      id: 'spice_002',
      name: l10n.saffronName,
      nameAr: l10n.saffronNameAr,
      category: l10n.categorySpices,
      description: l10n.saffronDesc,
      images: [
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjGXiBAhqI-2CrzfC8INKKD6rJP8Bfig0kjw&s',
      ],
      primaryColor: AppColors.spices,
      accentColor: AppColors.spicesAccent,
      icon: Icons.local_florist,
      characteristics: [
        l10n.saffronChar1,
        l10n.saffronChar2,
        l10n.saffronChar3,
        l10n.saffronChar4,
      ],
      whereToFind: l10n.saffronWhere,
      isHandmade: false,
      quality: l10n.qualityLuxury,
    ),
    FesProduct(
      id: 'spice_001',
      name: l10n.rasElHanoutName,
      nameAr: l10n.rasElHanoutNameAr,
      category: l10n.categorySpices,
      description: l10n.rasElHanoutDesc,
      images: [
        'https://images.pexels.com/photos/8250271/pexels-photo-8250271.jpeg',
      ],
      primaryColor: AppColors.spices,
      accentColor: AppColors.spicesAccent,
      icon: Icons.spa,
      characteristics: [
        l10n.rasElHanoutChar1,
        l10n.rasElHanoutChar2,
        l10n.rasElHanoutChar3,
        l10n.rasElHanoutChar4,
      ],
      whereToFind: l10n.rasElHanoutWhere,
      isHandmade: false,
      quality: l10n.qualityPremium,
    ),
  ];
}

// ============================================================================
// MAIN PAGE
// ============================================================================

class WhatToBuyPage extends StatefulWidget {
  const WhatToBuyPage({super.key});

  @override
  State<WhatToBuyPage> createState() => _WhatToBuyPageState();
}

class _WhatToBuyPageState extends State<WhatToBuyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final TextEditingController _searchController = TextEditingController();

  // ✅ Use the singleton FavoritesManager
  final FavoritesManager _favoritesManager = FavoritesManager();

  List<FesProduct> _allProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  SortBy _sortBy = SortBy.nameAZ;
  bool _showHandmadeOnly = false;

  bool _hasInitialized = false;
  Locale? _lastLocale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();

    // ✅ Listen to FavoritesManager so UI rebuilds when favorites change
    _favoritesManager.addListener(_onFavoritesChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProducts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    if (_hasInitialized && _lastLocale != currentLocale) {
      _lastLocale = currentLocale;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeProducts();
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

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _initializeProducts() {
    if (!mounted) return;
    setState(() {
      _allProducts = getLocalizedProducts(context);
    });
    _hasInitialized = true;
    _lastLocale = Localizations.localeOf(context);
  }

  void _setSearchQuery(String query) => setState(() => _searchQuery = query);
  void _setCategory(String category) => setState(() => _selectedCategory = category);
  void _setSortBy(SortBy sort) => setState(() => _sortBy = sort);
  void _setHandmadeOnly(bool value) => setState(() => _showHandmadeOnly = value);

  /// ✅ Toggle via FavoritesManager using toFavoriteMap()
  void _toggleFavorite(FesProduct product) {
    if (_favoritesManager.isFavorite(product.id)) {
      _favoritesManager.removeFavorite(product.id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.heart_broken, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Removed "${product.name}" from favorites',
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: AppColors.spices,
            onPressed: () => _favoritesManager.undoDelete(),
          ),
        ),
      ).closed.then((reason) {
        if (reason != SnackBarClosedReason.action) {
          _favoritesManager.clearUndoBuffer();
        }
      });
    } else {
      _favoritesManager.addFavorite(product.toFavoriteMap());
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Added "${product.name}" to favorites',
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.spices,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _showHandmadeOnly = false;
      _sortBy = SortBy.nameAZ;
    });
    _searchController.clear();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => FilterSheet(
        showHandmadeOnly: _showHandmadeOnly,
        sortBy: _sortBy,
        setHandmadeOnly: _setHandmadeOnly,
        setSortBy: _setSortBy,
        resetFilters: _resetFilters,
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ShoppingData(
      allProducts: _allProducts,
      favoritesManager: _favoritesManager,
      searchQuery: _searchQuery,
      selectedCategory: _selectedCategory,
      sortBy: _sortBy,
      showHandmadeOnly: _showHandmadeOnly,
      setSearchQuery: _setSearchQuery,
      setCategory: _setCategory,
      setSortBy: _setSortBy,
      setHandmadeOnly: _setHandmadeOnly,
      toggleFavorite: _toggleFavorite,
      resetFilters: _resetFilters,
      child: Builder(
        builder: (context) {
          final shoppingData = ShoppingData.of(context);
          final filteredProducts = shoppingData.filteredProducts;

          return Scaffold(
            backgroundColor: AppColors.background,
            body: CustomScrollView(
              slivers: [
                // ── App Bar ───────────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Stack(
                        children: [
                          const Icon(Icons.tune_rounded, color: Colors.white),
                          if (_searchQuery.isNotEmpty ||
                              _selectedCategory != 'All' ||
                              _showHandmadeOnly)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.spices,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: _showFilterSheet,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.background, AppColors.surface],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [AppColors.spices, AppColors.spicesAccent, AppColors.metalwork],
                                ).createShader(bounds),
                                child: Text(
                                  l10n.whatToBuyTitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: l10n.searchProducts,
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.spices),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? IconButton(
                                      icon: const Icon(Icons.clear_rounded, color: Colors.white),
                                      onPressed: () {
                                        _searchController.clear();
                                        _setSearchQuery('');
                                      },
                                    )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  onChanged: _setSearchQuery,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Category filters ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: Builder(builder: (context) {
                      final categoryDataMap = getCategoryDataMap(context);
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categoryDataMap.length,
                        itemBuilder: (context, index) {
                          final categoryData = categoryDataMap.values.elementAt(index);
                          final categoryKey = categoryDataMap.keys.elementAt(index);
                          final isSelected = _selectedCategory == categoryKey;

                          return Padding(
                            padding: const EdgeInsets.only(right: 12, top: 16, bottom: 16),
                            child: GestureDetector(
                              onTap: () => _setCategory(categoryKey),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? categoryData.color
                                        : Colors.white.withOpacity(0.1),
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: categoryData.color.withOpacity(0.4), blurRadius: 12)]
                                      : [],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: categoryData.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: categoryData.color.withOpacity(0.2),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: categoryData.color.withOpacity(0.2),
                                          child: Icon(categoryData.icon, color: categoryData.color, size: 32),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.black.withOpacity(isSelected ? 0.3 : 0.5),
                                              Colors.black.withOpacity(isSelected ? 0.6 : 0.8),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              categoryData.icon,
                                              color: isSelected ? categoryData.accentColor : Colors.white.withOpacity(0.9),
                                              size: 28,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              categoryData.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),

                // ── Results header ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          l10n.productsCount(filteredProducts.length),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<SortBy>(
                          initialValue: _sortBy,
                          icon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.swap_vert_rounded, color: AppColors.spices, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                _getSortLabel(context, _sortBy),
                                style: const TextStyle(color: AppColors.spices, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          color: AppColors.surfaceLight,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onSelected: _setSortBy,
                          itemBuilder: (context) => [
                            _buildSortMenuItem(context, SortBy.nameAZ),
                            _buildSortMenuItem(context, SortBy.nameZA),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 8)),

                // ── Products grid ─────────────────────────────────────────
                filteredProducts.isEmpty
                    ? const SliverFillRemaining(child: EmptyStateWidget())
                    : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (gridContext, index) {
                        final product = filteredProducts[index];
                        return AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final delay = (index % 4) * 0.1;
                            final animationValue = Curves.easeOutCubic.transform(
                              math.max(0, (_animationController.value - delay) / (1 - delay)),
                            );
                            return Opacity(
                              opacity: animationValue,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - animationValue)),
                                child: child,
                              ),
                            );
                          },
                          child: ProductCard(product: product),
                        );
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
                ),

                // ── Footer ────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surfaceLight.withOpacity(0.8),
                          AppColors.surface.withOpacity(0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.spices.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.shopping_bag_rounded, color: AppColors.spices, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          l10n.shopAuthenticCrafts,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.supportLocalArtisans,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSortLabel(BuildContext context, SortBy sortBy) {
    final l10n = AppLocalizations.of(context)!;
    switch (sortBy) {
      case SortBy.nameAZ: return l10n.sortNameAZ;
      case SortBy.nameZA: return l10n.sortNameZA;
    }
  }

  PopupMenuItem<SortBy> _buildSortMenuItem(BuildContext context, SortBy value) {
    return PopupMenuItem<SortBy>(
      value: value,
      child: Text(_getSortLabel(context, value), style: const TextStyle(color: Colors.white)),
    );
  }
}

// ============================================================================
// EMPTY STATE WIDGET
// ============================================================================

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FILTER SHEET
// ============================================================================

class FilterSheet extends StatelessWidget {
  final bool showHandmadeOnly;
  final SortBy sortBy;
  final Function(bool) setHandmadeOnly;
  final Function(SortBy) setSortBy;
  final Function() resetFilters;

  const FilterSheet({
    super.key,
    required this.showHandmadeOnly,
    required this.sortBy,
    required this.setHandmadeOnly,
    required this.setSortBy,
    required this.resetFilters,
  });

  String _getSortLabel(BuildContext context, SortBy sortBy) {
    final l10n = AppLocalizations.of(context)!;
    switch (sortBy) {
      case SortBy.nameAZ: return l10n.sortNameAZ;
      case SortBy.nameZA: return l10n.sortNameZA;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Filters', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  resetFilters();
                  Navigator.pop(context);
                },
                child: const Text('Reset', style: TextStyle(color: AppColors.spices)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Handmade only', style: TextStyle(color: Colors.white)),
            value: showHandmadeOnly,
            onChanged: setHandmadeOnly,
            activeColor: AppColors.spices,
          ),
          const SizedBox(height: 16),
          ...SortBy.values.map((sort) => RadioListTile<SortBy>(
            title: Text(_getSortLabel(context, sort), style: const TextStyle(color: Colors.white)),
            value: sort,
            groupValue: sortBy,
            activeColor: AppColors.spices,
            onChanged: (value) { if (value != null) setSortBy(value); },
          )),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.spices,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}