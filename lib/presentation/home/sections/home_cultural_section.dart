// lib/presentation/home/sections/home_cultural_section.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:app_fez_my/presentation/home/config/app_theme.dart';

// ============================================================================
// MODELS
// ============================================================================

@immutable
class CulturalSite {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final CulturalSiteCategory category;
  final String description;

  const CulturalSite({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CulturalSite &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum CulturalSiteCategory {
  historical,
  cultural;

  String get displayName {
    switch (this) {
      case CulturalSiteCategory.historical:
        return 'Historical';
      case CulturalSiteCategory.cultural:
        return 'Cultural';
    }
  }

  IconData get icon {
    switch (this) {
      case CulturalSiteCategory.historical:
        return Icons.account_balance_rounded;
      case CulturalSiteCategory.cultural:
        return Icons.palette_rounded;
    }
  }

  Color get color {
    switch (this) {
      case CulturalSiteCategory.historical:
        return const Color(0xFFFF6B35);
      case CulturalSiteCategory.cultural:
        return const Color(0xFF8B5CF6);
    }
  }
}

// ============================================================================
// DATA REPOSITORY
// ============================================================================

class CulturalSiteRepository {
  static List<CulturalSite> getCulturalSites() {
    return const [
      CulturalSite(
        id: 'cultural_1',
        name: 'Bou Inania Madrasa',
        imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa?w=800',
        rating: 4.8,
        reviewCount: 320,
        category: CulturalSiteCategory.historical,
        description: 'A masterpiece of Marinid architecture',
      ),
      CulturalSite(
        id: 'cultural_2',
        name: 'Chouara Tannery',
        imageUrl: 'https://images.unsplash.com/photo-1583405584623-58f4ca0e6dfc?w=800',
        rating: 4.7,
        reviewCount: 280,
        category: CulturalSiteCategory.cultural,
        description: 'Traditional leather dyeing pits',
      ),
      CulturalSite(
        id: 'cultural_3',
        name: 'Al-Qarawiyyin Mosque',
        imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800',
        rating: 4.9,
        reviewCount: 450,
        category: CulturalSiteCategory.historical,
        description: 'World\'s oldest university',
      ),
      CulturalSite(
        id: 'cultural_4',
        name: 'Bab Boujloud',
        imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800',
        rating: 4.6,
        reviewCount: 150,
        category: CulturalSiteCategory.historical,
        description: 'The iconic Blue Gate',
      ),
    ];
  }
}

// ============================================================================
// MAIN SECTION WIDGET
// ============================================================================

class HomeCulturalSection extends StatefulWidget {
  const HomeCulturalSection({
    super.key,
    this.onSiteTap,
    this.onFavoriteChanged,
  });

  final ValueChanged<CulturalSite>? onSiteTap;
  final ValueChanged<Set<String>>? onFavoriteChanged;

  @override
  State<HomeCulturalSection> createState() => _HomeCulturalSectionState();
}

class _HomeCulturalSectionState extends State<HomeCulturalSection>
    with SingleTickerProviderStateMixin {
  late final List<CulturalSite> _culturalSites;
  final Set<String> _favorites = {};
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _culturalSites = CulturalSiteRepository.getCulturalSites();
    _setupHeaderAnimations();
    _headerAnimationController.forward();
  }

  void _setupHeaderAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _toggleFavorite(String siteId) {
    setState(() {
      if (_favorites.contains(siteId)) {
        _favorites.remove(siteId);
      } else {
        _favorites.add(siteId);
      }
    });
    HapticFeedback.lightImpact();
    widget.onFavoriteChanged?.call(_favorites);
  }

  void _handleSiteTap(CulturalSite site) {
    HapticFeedback.mediumImpact();
    widget.onSiteTap?.call(site);
    debugPrint('Tapped on: ${site.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _headerFadeAnimation,
          child: SlideTransition(
            position: _headerSlideAnimation,
            child: const _SectionHeader(),
          ),
        ),
        const SizedBox(height: 18),
        _CulturalSitesList(
          sites: _culturalSites,
          favorites: _favorites,
          onFavoriteToggle: _toggleFavorite,
          onSiteTap: _handleSiteTap,
        ),
      ],
    );
  }
}

// ============================================================================
// SECTION HEADER - Enhanced
// ============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryOrange.withOpacity(0.15),
                            AppTheme.primaryOrange.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.account_balance_rounded,
                        color: AppTheme.primaryOrange,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cultural Heritage',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 54),
                  child: Text(
                    'Discover Fes\' rich history and traditions',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HORIZONTAL LIST
// ============================================================================

class _CulturalSitesList extends StatelessWidget {
  const _CulturalSitesList({
    required this.sites,
    required this.favorites,
    required this.onFavoriteToggle,
    required this.onSiteTap,
  });

  final List<CulturalSite> sites;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;
  final ValueChanged<CulturalSite> onSiteTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: sites.length,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final site = sites[index];
          final isFavorite = favorites.contains(site.id);
          return _CulturalSiteCard(
            site: site,
            isFavorite: isFavorite,
            index: index,
            onFavoriteToggle: () => onFavoriteToggle(site.id),
            onTap: () => onSiteTap(site),
          );
        },
      ),
    );
  }
}

// ============================================================================
// CARD - Enhanced with animations
// ============================================================================

class _CulturalSiteCard extends StatefulWidget {
  const _CulturalSiteCard({
    required this.site,
    required this.isFavorite,
    required this.index,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  final CulturalSite site;
  final bool isFavorite;
  final int index;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  @override
  State<_CulturalSiteCard> createState() => _CulturalSiteCardState();
}

class _CulturalSiteCardState extends State<_CulturalSiteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    Future.delayed(Duration(milliseconds: 100 + (widget.index * 80)), () {
      if (mounted) _controller.forward();
    });
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Semantics(
            label: '${widget.site.name}, ${widget.site.category.displayName}, '
                'Rating ${widget.site.rating} with ${widget.site.reviewCount} reviews, '
                '${widget.isFavorite ? "favorited" : "not favorited"}',
            button: true,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.onTap();
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: AnimatedScale(
                scale: _isPressed ? 0.96 : 1.0,
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeInOut,
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isPressed ? 0.06 : 0.1),
                        blurRadius: _isPressed ? 12 : 20,
                        offset: Offset(0, _isPressed ? 3 : 6),
                        spreadRadius: _isPressed ? -2 : 0,
                      ),
                      BoxShadow(
                        color: widget.site.category.color.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardImage(
                        site: widget.site,
                        isFavorite: widget.isFavorite,
                        onFavoriteToggle: widget.onFavoriteToggle,
                      ),
                      _CardContent(site: widget.site),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CARD IMAGE - Enhanced
// ============================================================================

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.site,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  final CulturalSite site;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    site.imageUrl,
                    fit: BoxFit.cover,
                    cacheWidth: 720,
                    cacheHeight: 510,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              site.category.color.withOpacity(0.15),
                              site.category.color.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: AppTheme.textSecondary,
                          size: 52,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _ImageLoadingShimmer();
                    },
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 14,
            child: _CategoryBadge(category: site.category),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: _FavoriteButton(
              isFavorite: isFavorite,
              onToggle: onFavoriteToggle,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// IMAGE LOADING SHIMMER
// ============================================================================

class _ImageLoadingShimmer extends StatefulWidget {
  @override
  State<_ImageLoadingShimmer> createState() => _ImageLoadingShimmerState();
}

class _ImageLoadingShimmerState extends State<_ImageLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[200]!,
                Colors.grey[100]!,
                Colors.grey[200]!,
              ],
              stops: [
                _shimmerController.value - 0.3,
                _shimmerController.value,
                _shimmerController.value + 0.3,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// CATEGORY BADGE - Enhanced
// ============================================================================

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final CulturalSiteCategory category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  category.icon,
                  size: 14,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                category.displayName,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FAVORITE BUTTON - Enhanced with animation
// ============================================================================

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onToggle,
  });

  final bool isFavorite;
  final VoidCallback onToggle;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.isFavorite ? 'Remove from favorites' : 'Add to favorites',
      button: true,
      child: GestureDetector(
        onTap: () {
          widget.onToggle();
          HapticFeedback.mediumImpact();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.isFavorite
                      ? AppTheme.primaryOrange.withOpacity(0.95)
                      : Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isFavorite
                          ? AppTheme.primaryOrange.withOpacity(0.4)
                          : Colors.black.withOpacity(0.12),
                      blurRadius: widget.isFavorite ? 12 : 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_outline_rounded,
                  color: widget.isFavorite ? Colors.white : AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CARD CONTENT - Enhanced
// ============================================================================

class _CardContent extends StatelessWidget {
  const _CardContent({required this.site});

  final CulturalSite site;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              site.name,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 7),
            Text(
              site.description,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            _RatingRow(
              rating: site.rating,
              reviewCount: site.reviewCount,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// RATING ROW - Enhanced
// ============================================================================

class _RatingRow extends StatelessWidget {
  const _RatingRow({
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 17,
            color: AppTheme.primaryOrange,
          ),
          const SizedBox(width: 5),
          Text(
            rating.toString(),
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '($reviewCount)',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}