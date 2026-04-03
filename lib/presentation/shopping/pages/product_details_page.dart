// lib/presentation/shopping/pages/product_details_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'what_to_buy_page.dart';

// ============================================================================
// PRODUCT CARD
// ============================================================================

class ProductCard extends StatefulWidget {
  final FesProduct product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with AutomaticKeepAliveClientMixin {
  bool _isHovered = false;

  @override
  bool get wantKeepAlive => true;

  void _showProductDetails() {
    final shoppingData = ShoppingData.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => ProductDetailsModal(
        product: widget.product,
        shoppingData: shoppingData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final shoppingData = ShoppingData.of(context);

    // ✅ Listen to FavoritesManager directly for real-time updates
    return ListenableBuilder(
      listenable: shoppingData.favoritesManager,
      builder: (context, _) {
        final isFavorite = shoppingData.isFavorite(widget.product.id);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: _showProductDetails,
            child: AnimatedScale(
              scale: _isHovered ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.surfaceLight.withOpacity(0.9),
                      AppColors.surface.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? widget.product.primaryColor.withOpacity(0.6)
                        : widget.product.primaryColor.withOpacity(0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                    BoxShadow(
                      color: widget.product.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Image ──────────────────────────────────────────
                    Expanded(
                      flex: 3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.images.first,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: widget.product.primaryColor.withOpacity(0.3),
                                highlightColor: widget.product.accentColor.withOpacity(0.5),
                                child: Container(color: widget.product.primaryColor.withOpacity(0.3)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.product.primaryColor.withOpacity(0.3),
                                      widget.product.accentColor.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(widget.product.icon, size: 48, color: widget.product.primaryColor),
                              ),
                            ),
                          ),
                          // Handmade badge
                          if (widget.product.isHandmade)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.handyman_rounded, size: 12, color: widget.product.accentColor),
                                    const SizedBox(width: 4),
                                    Text(l10n.handmade,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          // ✅ Favorite button — uses FavoritesManager via shoppingData
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => shoppingData.toggleFavorite(widget.product),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFavorite ? widget.product.accentColor : Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Content ────────────────────────────────────────
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.product.primaryColor.withOpacity(0.2),
                                    widget.product.accentColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.product.category,
                                style: TextStyle(
                                    fontSize: 10, color: widget.product.accentColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Name
                            Text(
                              widget.product.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Arabic name
                            Text(
                              widget.product.nameAr,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white.withOpacity(0.6), fontFamily: 'Amiri'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            // Quality badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(widget.product.quality,
                                      style: const TextStyle(fontSize: 10, color: Colors.amber, fontWeight: FontWeight.bold)),
                                ],
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
          ),
        );
      },
    );
  }
}

// ============================================================================
// PRODUCT DETAILS MODAL
// ============================================================================

class ProductDetailsModal extends StatefulWidget {
  final FesProduct product;
  final ShoppingData shoppingData;

  const ProductDetailsModal({
    super.key,
    required this.product,
    required this.shoppingData,
  });

  @override
  State<ProductDetailsModal> createState() => _ProductDetailsModalState();
}

class _ProductDetailsModalState extends State<ProductDetailsModal> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // ✅ ListenableBuilder so the favorite button updates in real time
    return ListenableBuilder(
      listenable: widget.shoppingData.favoritesManager,
      builder: (context, _) {
        final isFavorite = widget.shoppingData.isFavorite(widget.product.id);

        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  // ── Image carousel ──────────────────────────────────
                  Stack(
                    children: [
                      SizedBox(
                        height: 350,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) => setState(() => _currentImageIndex = index),
                          itemCount: widget.product.images.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              child: CachedNetworkImage(
                                imageUrl: widget.product.images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Shimmer.fromColors(
                                  baseColor: widget.product.primaryColor.withOpacity(0.3),
                                  highlightColor: widget.product.accentColor.withOpacity(0.5),
                                  child: Container(color: widget.product.primaryColor.withOpacity(0.3)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      if (widget.product.images.length > 1)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.product.images.length,
                                  (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentImageIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  gradient: _currentImageIndex == index
                                      ? LinearGradient(colors: [widget.product.primaryColor, widget.product.accentColor])
                                      : null,
                                  color: _currentImageIndex != index ? Colors.white.withOpacity(0.5) : null,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Badges ──────────────────────────────────────
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.product.primaryColor.withOpacity(0.2),
                                    widget.product.accentColor.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: widget.product.primaryColor.withOpacity(0.3)),
                              ),
                              child: Text(widget.product.category,
                                  style: TextStyle(fontSize: 12, color: widget.product.accentColor, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            if (widget.product.isHandmade)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.handyman_rounded, size: 14, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(l10n.handmade,
                                        style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(widget.product.quality,
                                      style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Name ────────────────────────────────────────
                        Text(widget.product.name,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text(widget.product.nameAr,
                            style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.7), fontFamily: 'Amiri')),
                        const SizedBox(height: 16),

                        // ── Description ─────────────────────────────────
                        Text(widget.product.description,
                            style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8), height: 1.6)),
                        const SizedBox(height: 24),

                        // ── Characteristics ─────────────────────────────
                        _SectionTitle(title: l10n.characteristics, color: widget.product.primaryColor),
                        const SizedBox(height: 12),
                        ...widget.product.characteristics.map(
                              (char) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_rounded, size: 20, color: widget.product.accentColor),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(char,
                                      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Where to find ───────────────────────────────
                        _SectionTitle(title: l10n.whereToFind, color: widget.product.primaryColor),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.product.primaryColor.withOpacity(0.15),
                                widget.product.accentColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: widget.product.primaryColor.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: widget.product.accentColor, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(widget.product.whereToFind,
                                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ✅ Favorite button — uses FavoritesManager via shoppingData
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.product.primaryColor.withOpacity(0.2),
                                widget.product.accentColor.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: widget.product.primaryColor.withOpacity(0.3), width: 2),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => widget.shoppingData.toggleFavorite(widget.product),
                              icon: Icon(isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
                              label: Text(isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFavorite ? Colors.red.withOpacity(0.8) : widget.product.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                              ),
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
      },
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
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(l10n.noProductsFound,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(l10n.tryAdjustingFilters,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, color.withOpacity(0.5)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

// ============================================================================
// PRODUCT DETAILS PAGE (Full screen alternative)
// ============================================================================

class ProductDetailsPage extends StatelessWidget {
  final FesProduct product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shoppingData = ShoppingData.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ProductDetailsModal(product: product, shoppingData: shoppingData),
    );
  }
}