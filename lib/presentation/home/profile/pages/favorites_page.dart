// lib/presentation/home/profile/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';
import 'package:app_fez_my/presentation/home/historical_sites/pages/site_details_page.dart';
import 'package:app_fez_my/presentation/shopping/pages/what_to_buy_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FavoritesManager _favoritesManager = FavoritesManager();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'recent';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  List<Map<String, dynamic>> get allFavorites => _favoritesManager.favorites;
  List<Map<String, dynamic>> get places =>
      allFavorites.where((f) => f['type'] == 'place').toList();
  List<Map<String, dynamic>> get hotels =>
      allFavorites.where((f) => f['type'] == 'hotel').toList();
  List<Map<String, dynamic>> get restaurants =>
      allFavorites.where((f) => f['type'] == 'restaurant').toList();
  List<Map<String, dynamic>> get products =>
      allFavorites.where((f) => f['type'] == 'product').toList();

  List<Map<String, dynamic>> _filterAndSortFavorites(
      List<Map<String, dynamic>> items) {
    var filtered = items.where((item) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return (item['name'] ?? '').toString().toLowerCase().contains(query) ||
          (item['nameAr'] ?? '').toString().toLowerCase().contains(query) ||
          (item['location'] ?? '').toString().toLowerCase().contains(query) ||
          (item['category'] ?? '').toString().toLowerCase().contains(query);
    }).toList();

    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) =>
            (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
        break;
      case 'rating':
        filtered.sort((a, b) =>
            ((b['rating'] ?? 0) as num).compareTo((a['rating'] ?? 0) as num));
        break;
      default:
        break;
    }
    return filtered;
  }

  void _removeFavorite(String id, String name) {
    _favoritesManager.removeFavorite(id);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child: Text('Removed "$name" from favorites',
                    style: const TextStyle(fontSize: 15))),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFFF9800),
          onPressed: () => _favoritesManager.undoDelete(),
        ),
      ),
    )
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action) {
        _favoritesManager.clearUndoBuffer();
      }
    });
  }

  void _navigateToDetails(Map<String, dynamic> item) {
    if (item['type'] == 'place') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SiteDetailsPage(
            id: item['id'] ?? '',
            title: item['name'] ?? '',
            imageUrl: item['image'] ?? '',
            rating: (item['rating'] ?? 0).toDouble(),
            reviews: item['reviews'] ?? 0,
            duration: item['duration'] ?? '2-3 hours',
            price: item['price'] ?? 'Free',
            year: item['year'] ?? 'Historic',
            badge: item['badge'] ?? '🕌',
            location: item['location'],
            category: item['category'],
          ),
        ),
      );
    } else if (item['type'] == 'product') {
      // ✅ Reconstruct FesProduct from stored map — no ShoppingData needed
      final product = FesProduct.fromFavoriteMap(item);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StandaloneProductModal(product: product),
      );
    } else {
      _showGenericDetails(item);
    }
  }

  void _showGenericDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ItemDetailsBottomSheet(
        item: item,
        onRemove: () {
          Navigator.pop(context);
          _removeFavorite(item['id'], item['name']);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_favoritesManager.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(l10n.myFavorites,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          centerTitle: true,
        ),
        body: const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF9800))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.myFavorites,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        centerTitle: true,
        actions: [
          if (allFavorites.isNotEmpty) ...[
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: Colors.black87),
              tooltip: 'Sort by',
              onSelected: (value) => setState(() => _sortBy = value),
              itemBuilder: (context) => [
                _sortMenuItem('recent', Icons.access_time, 'Most Recent'),
                _sortMenuItem('name', Icons.sort_by_alpha, 'Name (A-Z)'),
                _sortMenuItem('rating', Icons.star, 'Highest Rated'),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onSelected: (value) {
                if (value == 'clear') _showClearAllDialog(context);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(children: [
                    Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Clear All'),
                  ]),
                ),
              ],
            ),
          ],
        ],
        bottom: allFavorites.isEmpty
            ? null
            : PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search favorites...',
                      hintStyle:
                      TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon:
                      Icon(Icons.search, color: Colors.grey[400], size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear,
                            color: Colors.grey[400], size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFFF9800),
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: const Color(0xFFFF9800),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  isScrollable: true,
                  tabs: [
                    Tab(text: 'All (${allFavorites.length})'),
                    Tab(text: 'Places (${places.length})'),
                    Tab(text: 'Hotels (${hotels.length})'),
                    Tab(text: 'Food (${restaurants.length})'),
                    Tab(text: 'Shop (${products.length})'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: allFavorites.isEmpty
          ? _buildEmptyState(l10n)
          : TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesList(allFavorites),
          _buildFavoritesList(places),
          _buildFavoritesList(hotels),
          _buildFavoritesList(restaurants),
          _buildFavoritesList(products),
        ],
      ),
    );
  }

  PopupMenuItem<String> _sortMenuItem(
      String value, IconData icon, String label) {
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(children: [
        Icon(icon,
            size: 20,
            color:
            isSelected ? const Color(0xFFFF9800) : Colors.grey[600]),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                color: isSelected
                    ? const Color(0xFFFF9800)
                    : Colors.black87,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal)),
        if (isSelected) ...[
          const Spacer(),
          const Icon(Icons.check, size: 20, color: Color(0xFFFF9800)),
        ],
      ]),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear All Favorites?',
            style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        content: Text(
            'Are you sure you want to remove all favorites? This action cannot be undone.',
            style: TextStyle(fontSize: 15, color: Colors.grey[700])),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
              Text('Cancel', style: TextStyle(color: Colors.grey[600]))),
          ElevatedButton(
            onPressed: () {
              _favoritesManager.clearAllFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('All favorites cleared'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black87));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  shape: BoxShape.circle),
              child: Icon(Icons.favorite_border,
                  size: 60,
                  color: const Color(0xFFFF9800).withOpacity(0.5)),
            ),
            const SizedBox(height: 32),
            Text(l10n.noFavoritesYet,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(l10n.startExploring,
                style: TextStyle(
                    fontSize: 15, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 0),
              icon: const Icon(Icons.explore, size: 20),
              label: const Text('Start Exploring',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<Map<String, dynamic>> items) {
    final filteredItems = _filterAndSortFavorites(items);

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _searchQuery.isNotEmpty
                    ? Icons.search_off
                    : Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
                _searchQuery.isNotEmpty
                    ? 'No results for "$_searchQuery"'
                    : 'No items in this category',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child: const Text('Clear search')),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Dismissible(
          key: Key(item['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete_outline,
                color: Colors.white, size: 28),
          ),
          onDismissed: (_) => _removeFavorite(item['id'], item['name']),
          child: _buildFavoriteCard(item),
        );
      },
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> item) {
    IconData typeIcon;
    Color typeColor;
    switch (item['type']) {
      case 'place':
        typeIcon = Icons.location_on;
        typeColor = const Color(0xFF2196F3);
        break;
      case 'hotel':
        typeIcon = Icons.hotel;
        typeColor = const Color(0xFF4CAF50);
        break;
      case 'restaurant':
        typeIcon = Icons.restaurant;
        typeColor = const Color(0xFFFF6B35);
        break;
      case 'product':
        typeIcon = Icons.shopping_bag;
        typeColor = const Color(0xFF9C27B0);
        break;
      default:
        typeIcon = Icons.favorite;
        typeColor = const Color(0xFFFF9800);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ]),
      child: InkWell(
        onTap: () => _navigateToDetails(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Image + type badge ──────────────────────────────
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item['image'] ?? '',
                      width: 85,
                      height: 85,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          width: 85,
                          height: 85,
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey[400])),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: typeColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(typeIcon, size: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // ── Details ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item['name'] ?? '',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if ((item['nameAr'] ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(item['nameAr'],
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontFamily: 'Amiri'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on,
                          size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                            item['location'] ??
                                item['whereToFind'] ??
                                '',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                              color: typeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(item['category'] ?? '',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: typeColor,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (item['rating'] != null) ...[
                        const Icon(Icons.star,
                            size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Flexible(
                          flex: 2,
                          child: Text(
                              '${item['rating']} (${item['reviews'] ?? 0})',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ] else if (item['quality'] != null) ...[
                        const Icon(Icons.star,
                            size: 12, color: Colors.amber),
                        const SizedBox(width: 2),
                        Flexible(
                          flex: 2,
                          child: Text(item['quality'],
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ]),
                  ],
                ),
              ),
              // ── Remove button ────────────────────────────────────
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.red[400], size: 20),
                padding: const EdgeInsets.all(6),
                constraints:
                const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () => _removeFavorite(item['id'], item['name']),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// STANDALONE PRODUCT MODAL
// Opened from FavoritesPage — talks directly to FavoritesManager,
// requires NO ShoppingData in context.
// ============================================================================

class StandaloneProductModal extends StatefulWidget {
  final FesProduct product;

  const StandaloneProductModal({super.key, required this.product});

  @override
  State<StandaloneProductModal> createState() =>
      _StandaloneProductModalState();
}

class _StandaloneProductModalState extends State<StandaloneProductModal> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  void _toggleFavorite() {
    final p = widget.product;
    if (_favoritesManager.isFavorite(p.id)) {
      _favoritesManager.removeFavorite(p.id);
    } else {
      _favoritesManager.addFavorite(p.toFavoriteMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = _favoritesManager.isFavorite(widget.product.id);
    final p = widget.product;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              // ── Image carousel ──────────────────────────────────
              Stack(
                children: [
                  SizedBox(
                    height: 320,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (i) =>
                          setState(() => _currentImageIndex = i),
                      itemCount: p.images.length,
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24)),
                        child: Image.network(
                          p.images[i],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: p.primaryColor.withOpacity(0.3),
                            child:
                            Icon(p.icon, size: 64, color: p.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Close
                  Positioned(
                    top: 20,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  // Page dots
                  if (p.images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          p.images.length,
                              (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == i ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: _currentImageIndex == i
                                  ? LinearGradient(colors: [
                                p.primaryColor,
                                p.accentColor
                              ])
                                  : null,
                              color: _currentImageIndex != i
                                  ? Colors.white.withOpacity(0.5)
                                  : null,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // ── Content ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _badge(p.category, p.accentColor,
                            p.primaryColor.withOpacity(0.2)),
                        if (p.isHandmade)
                          _badge('Handmade', Colors.green,
                              Colors.green.withOpacity(0.15),
                              icon: Icons.handyman_rounded),
                        _badge(p.quality, Colors.amber,
                            Colors.amber.withOpacity(0.15),
                            icon: Icons.star_rounded),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Names
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(p.nameAr,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.65),
                            fontFamily: 'Amiri')),
                    const SizedBox(height: 16),

                    // Description
                    Text(p.description,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.6)),
                    const SizedBox(height: 24),

                    // Characteristics
                    _sectionTitle('Characteristics', p.primaryColor),
                    const SizedBox(height: 10),
                    ...p.characteristics.map(
                          (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Icon(Icons.check_circle_rounded,
                              size: 20, color: p.accentColor),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(c,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8)))),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Where to find
                    _sectionTitle('Where to Find', p.primaryColor),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          p.primaryColor.withOpacity(0.15),
                          p.accentColor.withOpacity(0.05)
                        ]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: p.primaryColor.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        Icon(Icons.location_on_rounded,
                            color: p.accentColor, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(p.whereToFind,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500))),
                      ]),
                    ),
                    const SizedBox(height: 28),

                    // ✅ Favorite button — uses FavoritesManager directly
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleFavorite,
                        icon: Icon(isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded),
                        label: Text(isFav
                            ? 'Remove from Favorites'
                            : 'Add to Favorites'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFav
                              ? Colors.red.withOpacity(0.8)
                              : p.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
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

  Widget _badge(String label, Color textColor, Color bgColor,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.3))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
        ],
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Row(children: [
      Container(
        width: 4,
        height: 20,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color, color.withOpacity(0.5)]),
            borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 12),
      Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    ]);
  }
}

// ============================================================================
// GENERIC ITEM DETAILS BOTTOM SHEET (hotels, restaurants)
// ============================================================================

class _ItemDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;

  const _ItemDetailsBottomSheet(
      {required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                    child: Image.network(item['image'] ?? '',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: Icon(Icons.image,
                                size: 64, color: Colors.grey[400]))),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle),
                      child: IconButton(
                          icon:
                          const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'] ?? '',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    if ((item['nameAr'] ?? '').isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(item['nameAr'],
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontFamily: 'Amiri')),
                    ],
                    const SizedBox(height: 16),
                    if (item['rating'] != null) ...[
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text('${item['rating']}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Text('(${item['reviews'] ?? 0} reviews)',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                      ]),
                      const SizedBox(height: 16),
                    ] else if (item['quality'] != null) ...[
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(item['quality'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber)),
                      ]),
                      const SizedBox(height: 16),
                    ],
                    Row(children: [
                      Icon(Icons.location_on,
                          size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                              item['location'] ??
                                  item['whereToFind'] ??
                                  '',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[700]))),
                    ]),
                    const SizedBox(height: 16),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFF9800).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(item['category'] ?? '',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFF9800),
                                fontWeight: FontWeight.w600)),
                      ),
                      if (item['price'] != null) ...[
                        const SizedBox(width: 12),
                        Text(item['price'],
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF9800))),
                      ],
                    ]),
                    if (item['description'] != null) ...[
                      const SizedBox(height: 24),
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(item['description'],
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5)),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onRemove,
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        icon: const Icon(Icons.favorite_border),
                        label: const Text('Remove from Favorites',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
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