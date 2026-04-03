// lib/presentation/home/sections/home_explore_section.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ============================================================================
// MODELS
// ============================================================================

@immutable
class ExplorePlace {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;
  final double distanceKm;
  final String category;
  final bool isTrending;
  final bool isNew;

  const ExplorePlace({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.distanceKm,
    required this.category,
    this.isTrending = false,
    this.isNew = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExplorePlace &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ============================================================================
// DATA REPOSITORY
// ============================================================================

class ExplorePlaceRepository {
  static List<ExplorePlace> getExplorePlaces() {
    return const [
      ExplorePlace(
        id: 'explore_1',
        name: 'Borj Nord',
        imageUrl: 'assets/images/borj_nord.jpg',
        rating: 4.7,
        reviewCount: 180,
        location: 'North Fes',
        distanceKm: 3.5,
        category: 'Historical',
        isTrending: true,
      ),
      ExplorePlace(
        id: 'explore_2',
        name: 'Jnan Sbil Gardens',
        imageUrl: 'assets/images/jnan_sbil.jpg',
        rating: 4.8,
        reviewCount: 220,
        location: 'Ville Nouvelle',
        distanceKm: 2.8,
        category: 'Nature',
        isNew: true,
      ),
      ExplorePlace(
        id: 'explore_3',
        name: 'Mellah District',
        imageUrl: 'assets/images/mellah.jpg',
        rating: 4.5,
        reviewCount: 160,
        location: 'Jewish Quarter',
        distanceKm: 1.9,
        category: 'Cultural',
      ),
      ExplorePlace(
        id: 'explore_4',
        name: 'Dar Batha Museum',
        imageUrl: 'assets/images/dar_batha.jpg',
        rating: 4.6,
        reviewCount: 145,
        location: 'Medina',
        distanceKm: 1.5,
        category: 'Museum',
      ),
    ];
  }
}

// ============================================================================
// MAIN SECTION WIDGET
// ============================================================================

class HomeExploreSection extends StatefulWidget {
  const HomeExploreSection({
    super.key,
    this.onPlaceTap,
    this.onFavoriteToggle,
    this.onSeeAllTap,
    this.initialFavorites = const {},
  });

  final ValueChanged<ExplorePlace>? onPlaceTap;
  final ValueChanged<String>? onFavoriteToggle;
  final VoidCallback? onSeeAllTap;
  final Set<String> initialFavorites;

  @override
  State<HomeExploreSection> createState() => _HomeExploreSectionState();
}

class _HomeExploreSectionState extends State<HomeExploreSection>
    with TickerProviderStateMixin {
  late List<ExplorePlace> _explorePlaces;
  late Set<String> _favorites;
  bool _isLoading = true;
  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _favorites = Set.from(widget.initialFavorites);
    _setupAnimations();
    _loadPlaces();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(-0.15, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _loadPlaces() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _explorePlaces = ExplorePlaceRepository.getExplorePlaces();
        _isLoading = false;
      });
      _animationController.forward();
    });
  }

  void _handlePlaceTap(ExplorePlace place) {
    HapticFeedback.mediumImpact();
    widget.onPlaceTap?.call(place);
    debugPrint('🏛️ Tapped: ${place.name}');
  }

  void _handleFavoriteToggle(String placeId) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_favorites.contains(placeId)) {
        _favorites.remove(placeId);
      } else {
        _favorites.add(placeId);
      }
    });
    widget.onFavoriteToggle?.call(placeId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: FadeTransition(
            opacity: _headerFadeAnimation,
            child: SlideTransition(
              position: _headerSlideAnimation,
              child: _SectionHeader(
                title: 'Explore More',
                subtitle: 'Hidden gems of Fes',
                onSeeAll: widget.onSeeAllTap,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (_isLoading)
          _buildLoadingState()
        else if (_explorePlaces.isEmpty)
          _buildEmptyState()
        else
          _ExplorePlacesList(
            places: _explorePlaces,
            favorites: _favorites,
            animationController: _animationController,
            onPlaceTap: _handlePlaceTap,
            onFavoriteToggle: _handleFavoriteToggle,
          ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, __) => _ShimmerCard(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 320,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2196F3).withOpacity(0.15),
                    const Color(0xFF2196F3).withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.explore_outlined,
                size: 64,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No places to explore',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Check back later for\nnew destinations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: const Color(0xFF666666),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER - Enhanced
// ============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2196F3).withOpacity(0.15),
                      const Color(0xFF2196F3).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (onSeeAll != null)
          _SeeAllButton(onTap: onSeeAll!),
      ],
    );
  }
}

// ============================================================================
// SEE ALL BUTTON - Enhanced
// ============================================================================

class _SeeAllButton extends StatefulWidget {
  const _SeeAllButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_SeeAllButton> createState() => _SeeAllButtonState();
}

class _SeeAllButtonState extends State<_SeeAllButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
        HapticFeedback.lightImpact();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFF6B35).withOpacity(_isPressed ? 0.12 : 0.1),
                const Color(0xFFFF6B35).withOpacity(_isPressed ? 0.08 : 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF6B35),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: Color(0xFFFF6B35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SHIMMER LOADING CARD - Enhanced
// ============================================================================

class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 190,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF0F0F0),
                      const Color(0xFFFFFFFF),
                      const Color(0xFFF0F0F0),
                    ],
                    stops: [
                      (_animation.value - 0.3).clamp(0.0, 1.0),
                      _animation.value.clamp(0.0, 1.0),
                      (_animation.value + 0.3).clamp(0.0, 1.0),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 110,
                      height: 15,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 90,
                      height: 15,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(5),
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

// ============================================================================
// PLACES LIST - Enhanced
// ============================================================================

class _ExplorePlacesList extends StatelessWidget {
  const _ExplorePlacesList({
    required this.places,
    required this.favorites,
    required this.animationController,
    required this.onPlaceTap,
    required this.onFavoriteToggle,
  });

  final List<ExplorePlace> places;
  final Set<String> favorites;
  final AnimationController animationController;
  final ValueChanged<ExplorePlace> onPlaceTap;
  final ValueChanged<String> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        physics: const BouncingScrollPhysics(),
        itemCount: places.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final place = places[index];
          final isFavorite = favorites.contains(place.id);

          final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval(
                (index * 0.12).clamp(0.0, 0.6),
                1.0,
                curve: Curves.easeOutCubic,
              ),
            ),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.25, 0),
                end: Offset.zero,
              ).animate(animation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1.0).animate(animation),
                child: _PlaceCard(
                  place: place,
                  isFavorite: isFavorite,
                  onTap: () => onPlaceTap(place),
                  onFavoriteTap: () => onFavoriteToggle(place.id),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// PLACE CARD - Enhanced
// ============================================================================

class _PlaceCard extends StatefulWidget {
  const _PlaceCard({
    required this.place,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final ExplorePlace place;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  State<_PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<_PlaceCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'museum':
        return const Color(0xFF9C27B0);
      case 'historical':
        return const Color(0xFFFF6B35);
      case 'religious':
        return const Color(0xFF2196F3);
      case 'shopping':
        return const Color(0xFFFF9800);
      case 'cultural':
        return const Color(0xFF4CAF50);
      case 'nature':
        return const Color(0xFF8BC34A);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.place.category);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _scaleController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _scaleController.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _scaleController.reverse();
        },
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isPressed ? 0.08 : 0.12),
                blurRadius: _isPressed ? 14 : 20,
                offset: Offset(0, _isPressed ? 4 : 6),
              ),
              BoxShadow(
                color: categoryColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(categoryColor),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Color categoryColor) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: SizedBox(
            height: 190,
            width: double.infinity,
            child: Stack(
              children: [
                Image.asset(
                  widget.place.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor.withOpacity(0.15),
                          categoryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 56,
                      color: const Color(0xFFCCCCCC),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.25),
                      ],
                      stops: const [0.0, 0.3, 0.65, 1.0],
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
          right: 14,
          child: Row(
            children: [
              if (widget.place.isTrending)
                _buildBadge('🔥 Trending', const Color(0xFFFF9800)),
              if (widget.place.isNew)
                _buildBadge('✨ New', const Color(0xFF2196F3)),
              const Spacer(),
              _buildFavoriteButton(),
            ],
          ),
        ),
        Positioned(
          bottom: 14,
          left: 14,
          child: _buildCategoryBadge(categoryColor),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.only(right: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.94),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            widget.place.category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: () {
        widget.onFavoriteTap();
        HapticFeedback.mediumImpact();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: widget.isFavorite
                  ? const Color(0xFFFF3B30).withOpacity(0.94)
                  : Colors.white.withOpacity(0.94),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.isFavorite
                      ? const Color(0xFFFF3B30).withOpacity(0.4)
                      : Colors.black.withOpacity(0.12),
                  blurRadius: widget.isFavorite ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: widget.isFavorite ? Colors.white : const Color(0xFF666666),
              size: 19,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.place.name,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.4,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 15,
                color: Color(0xFF666666),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  widget.place.location,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF2196F3).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${widget.place.distanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildRatingRow(),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC107).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFC107).withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFFC107),
            size: 17,
          ),
          const SizedBox(width: 5),
          Text(
            widget.place.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            '(${widget.place.reviewCount})',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}