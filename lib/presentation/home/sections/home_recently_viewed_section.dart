// lib/presentation/home/sections/home_recently_viewed_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

class RecentlyViewedConstants {
  // Dimensions
  static const double cardWidth = 148.0;
  static const double cardHeight = 108.0;
  static const double cardBorderRadius = 12.0;
  static const double horizontalPadding = 20.0;
  static const double cardSpacing = 12.0;

  // Animation durations
  static const Duration loadingDelay = Duration(milliseconds: 400);
  static const Duration entranceAnimationDuration = Duration(milliseconds: 800);
  static const Duration shimmerDuration = Duration(milliseconds: 1500);
  static const Duration scaleDuration = Duration(milliseconds: 150);

  // Animation values
  static const double scaleDownValue = 0.95;
  static const double slideOffset = 0.2;
  static const double staggerDelay = 0.12;

  // Colors
  static const Color textPrimaryColor = Color(0xFF2D3142);
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Font sizes
  static const double titleFontSize = 22.0;
  static const double cardTitleFontSize = 12.0;

  RecentlyViewedConstants._();
}

// ============================================================================
// MAIN SECTION WIDGET
// ============================================================================

class HomeRecentlyViewedSection extends StatefulWidget {
  const HomeRecentlyViewedSection({
    super.key,
    this.onPlaceTap,
  });

  final ValueChanged<String>? onPlaceTap;

  @override
  State<HomeRecentlyViewedSection> createState() =>
      _HomeRecentlyViewedSectionState();
}

class _HomeRecentlyViewedSectionState extends State<HomeRecentlyViewedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: RecentlyViewedConstants.entranceAnimationDuration,
    );
    _simulateLoading();
  }

  void _simulateLoading() {
    Future.delayed(RecentlyViewedConstants.loadingDelay, () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: RecentlyViewedConstants.horizontalPadding,
          ),
          child: Text(
            'Recently Viewed',
            style: const TextStyle(
              fontSize: RecentlyViewedConstants.titleFontSize,
              fontWeight: FontWeight.w700,
              color: RecentlyViewedConstants.textPrimaryColor,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: RecentlyViewedConstants.cardHeight,
          child: _isLoading ? _buildLoadingState() : _buildPlacesList(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: RecentlyViewedConstants.horizontalPadding,
      ),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(
        width: RecentlyViewedConstants.cardSpacing,
      ),
      itemBuilder: (context, index) => const _SkeletonCard(),
    );
  }

  Widget _buildPlacesList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: RecentlyViewedConstants.horizontalPadding,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: _recentlyViewed.length,
      separatorBuilder: (_, __) => const SizedBox(
        width: RecentlyViewedConstants.cardSpacing,
      ),
      itemBuilder: (context, index) {
        final place = _recentlyViewed[index];

        // Staggered animation
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              index * RecentlyViewedConstants.staggerDelay,
              1.0,
              curve: Curves.easeOutCubic,
            ),
          ),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(RecentlyViewedConstants.slideOffset, 0),
              end: Offset.zero,
            ).animate(animation),
            child: _RecentlyViewedCard(
              image: place['image']!,
              title: place['title']!,
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onPlaceTap?.call(place['title']!);
              },
            ),
          ),
        );
      },
    );
  }

  static final List<Map<String, String>> _recentlyViewed = [
    {
      'image': 'https://images.unsplash.com/photo-1585069210633-13a0c7b86fcc?w=300&q=80',
      'title': 'Jardin Jnan Sbil',
    },
    {
      'image': 'https://images.unsplash.com/photo-1548690596-f6039f77e0b8?w=300&q=80',
      'title': 'Chouara Tannery',
    },
    {
      'image': 'https://images.unsplash.com/photo-1539768942893-daf53e448371?w=300&q=80',
      'title': 'Blue Gate',
    },
    {
      'image': 'https://images.unsplash.com/photo-1583037189850-1921ae7c6c22?w=300&q=80',
      'title': 'Borj Nord',
    },
  ];
}

// ============================================================================
// RECENTLY VIEWED CARD
// ============================================================================

class _RecentlyViewedCard extends StatefulWidget {
  const _RecentlyViewedCard({
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final VoidCallback onTap;

  @override
  State<_RecentlyViewedCard> createState() => _RecentlyViewedCardState();
}

class _RecentlyViewedCardState extends State<_RecentlyViewedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: RecentlyViewedConstants.scaleDuration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: RecentlyViewedConstants.scaleDownValue,
    ).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Recently viewed: ${widget.title}',
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _elevationAnimation,
            builder: (context, child) {
              return Container(
                width: RecentlyViewedConstants.cardWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    RecentlyViewedConstants.cardBorderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8 + _elevationAnimation.value,
                      offset: Offset(0, 2 + _elevationAnimation.value),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                RecentlyViewedConstants.cardBorderRadius,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),
                  _buildGradientOverlay(),
                  _buildTitle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.network(
      widget.image,
      fit: BoxFit.cover,
      cacheWidth: 300,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return Container(
          color: RecentlyViewedConstants.backgroundGrey,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.purple.withOpacity(0.5),
                ),
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: RecentlyViewedConstants.backgroundGrey,
          child: Icon(
            Icons.image_not_supported_rounded,
            color: Colors.grey[400],
            size: 32,
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.65),
          ],
          stops: const [0.4, 0.7, 1.0],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: RecentlyViewedConstants.cardTitleFontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
            height: 1.3,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ============================================================================
// SKELETON CARD - Loading State
// ============================================================================

class _SkeletonCard extends StatefulWidget {
  const _SkeletonCard();

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: RecentlyViewedConstants.shimmerDuration,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          width: RecentlyViewedConstants.cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              RecentlyViewedConstants.cardBorderRadius,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                RecentlyViewedConstants.backgroundGrey,
                RecentlyViewedConstants.backgroundWhite,
                RecentlyViewedConstants.backgroundGrey,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      },
    );
  }
}