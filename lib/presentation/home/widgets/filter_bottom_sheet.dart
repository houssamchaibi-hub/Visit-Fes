// lib/presentation/home/widgets/filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_fez_my/presentation/home/config/app_theme.dart';

// ============================================================================
// FILTER DATA MODEL
// ============================================================================

class FilterOptions {
  final List<String> selectedCategories;
  final double minRating;
  final double maxDistance;
  final List<String> selectedPriceRanges;
  final bool openNow;

  const FilterOptions({
    this.selectedCategories = const [],
    this.minRating = 0.0,
    this.maxDistance = 50.0,
    this.selectedPriceRanges = const [],
    this.openNow = false,
  });

  FilterOptions copyWith({
    List<String>? selectedCategories,
    double? minRating,
    double? maxDistance,
    List<String>? selectedPriceRanges,
    bool? openNow,
  }) {
    return FilterOptions(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minRating: minRating ?? this.minRating,
      maxDistance: maxDistance ?? this.maxDistance,
      selectedPriceRanges: selectedPriceRanges ?? this.selectedPriceRanges,
      openNow: openNow ?? this.openNow,
    );
  }

  bool get hasActiveFilters {
    return selectedCategories.isNotEmpty ||
        minRating > 0 ||
        maxDistance < 50 ||
        selectedPriceRanges.isNotEmpty ||
        openNow;
  }

  int get activeFilterCount {
    int count = 0;
    if (selectedCategories.isNotEmpty) count++;
    if (minRating > 0) count++;
    if (maxDistance < 50) count++;
    if (selectedPriceRanges.isNotEmpty) count++;
    if (openNow) count++;
    return count;
  }
}

// ============================================================================
// FILTER BOTTOM SHEET
// ============================================================================

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
  });

  final FilterOptions initialFilters;
  final ValueChanged<FilterOptions> onApply;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();

  static Future<FilterOptions?> show({
    required BuildContext context,
    required FilterOptions initialFilters,
  }) {
    return showModalBottomSheet<FilterOptions>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialFilters: initialFilters,
        onApply: (filters) => Navigator.pop(context, filters),
      ),
    );
  }
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late FilterOptions _filters;
  late AnimationController _animationController;

  // Filter Categories
  static const List<Map<String, String>> _categories = [
    {'id': 'nature', 'label': 'Nature', 'emoji': '🌿'},
    {'id': 'historical', 'label': 'Historical', 'emoji': '🏛️'},
    {'id': 'cultural', 'label': 'Cultural', 'emoji': '🎭'},
    {'id': 'food', 'label': 'Food', 'emoji': '🍽️'},
    {'id': 'shopping', 'label': 'Shopping', 'emoji': '🛍️'},
    {'id': 'adventure', 'label': 'Adventure', 'emoji': '🏔️'},
  ];

  static const List<Map<String, String>> _priceRanges = [
    {'id': 'free', 'label': 'Free', 'emoji': '🆓'},
    {'id': 'budget', 'label': 'Budget', 'emoji': '💰'},
    {'id': 'moderate', 'label': 'Moderate', 'emoji': '💵'},
    {'id': 'premium', 'label': 'Premium', 'emoji': '💎'},
  ];

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    HapticFeedback.mediumImpact();
    setState(() {
      _filters = const FilterOptions();
    });
  }

  void _applyFilters() {
    HapticFeedback.mediumImpact();
    widget.onApply(_filters);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        )),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppTheme.backgroundWhite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoriesSection(),
                      const SizedBox(height: 32),
                      _buildRatingSection(),
                      const SizedBox(height: 32),
                      _buildDistanceSection(),
                      const SizedBox(height: 32),
                      _buildPriceSection(),
                      const SizedBox(height: 32),
                      _buildOpenNowSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppTheme.textTertiary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title & Reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              if (_filters.hasActiveFilters)
                TextButton(
                  onPressed: _resetFilters,
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: AppTheme.primaryOrange,
                      ),
                      const SizedBox(width: 4),
                      const Text('Reset'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Categories',
          subtitle: 'Select your interests',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _filters.selectedCategories.contains(category['id']);
            return _FilterChip(
              label: category['label']!,
              emoji: category['emoji']!,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isSelected) {
                    _filters = _filters.copyWith(
                      selectedCategories: List.from(_filters.selectedCategories)
                        ..remove(category['id']),
                    );
                  } else {
                    _filters = _filters.copyWith(
                      selectedCategories: List.from(_filters.selectedCategories)
                        ..add(category['id']!),
                    );
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Minimum Rating',
          subtitle: '${_filters.minRating.toStringAsFixed(1)} stars and above',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.star, color: AppTheme.ratingStar, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppTheme.primaryOrange,
                  inactiveTrackColor: AppTheme.backgroundGrey,
                  thumbColor: AppTheme.primaryOrange,
                  overlayColor: AppTheme.primaryOrange.withOpacity(0.2),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  value: _filters.minRating,
                  min: 0,
                  max: 5,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      _filters = _filters.copyWith(minRating: value);
                    });
                  },
                  onChangeEnd: (_) => HapticFeedback.mediumImpact(),
                ),
              ),
            ),
            Text(
              _filters.minRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Rating Preview
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: (index + 1) <= _filters.minRating
                    ? AppTheme.primaryOrange.withOpacity(0.1)
                    : AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (index + 1) <= _filters.minRating
                      ? AppTheme.primaryOrange
                      : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: (index + 1) <= _filters.minRating
                        ? AppTheme.ratingStar
                        : AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: (index + 1) <= _filters.minRating
                          ? AppTheme.primaryOrange
                          : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Maximum Distance',
          subtitle: 'Within ${_filters.maxDistance.toInt()} km',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppTheme.primaryOrange,
                  inactiveTrackColor: AppTheme.backgroundGrey,
                  thumbColor: AppTheme.primaryOrange,
                  overlayColor: AppTheme.primaryOrange.withOpacity(0.2),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  value: _filters.maxDistance,
                  min: 1,
                  max: 50,
                  divisions: 49,
                  onChanged: (value) {
                    setState(() {
                      _filters = _filters.copyWith(maxDistance: value);
                    });
                  },
                  onChangeEnd: (_) => HapticFeedback.mediumImpact(),
                ),
              ),
            ),
            Text(
              '${_filters.maxDistance.toInt()} km',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Price Range',
          subtitle: 'Select price categories',
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _priceRanges.map((price) {
            final isSelected = _filters.selectedPriceRanges.contains(price['id']);
            return _FilterChip(
              label: price['label']!,
              emoji: price['emoji']!,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isSelected) {
                    _filters = _filters.copyWith(
                      selectedPriceRanges: List.from(_filters.selectedPriceRanges)
                        ..remove(price['id']),
                    );
                  } else {
                    _filters = _filters.copyWith(
                      selectedPriceRanges: List.from(_filters.selectedPriceRanges)
                        ..add(price['id']!),
                    );
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOpenNowSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _filters.openNow
            ? AppTheme.success.withOpacity(0.1)
            : AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _filters.openNow ? AppTheme.success : AppTheme.border,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _filters.openNow
                  ? AppTheme.success
                  : AppTheme.textTertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.schedule_rounded,
              color: _filters.openNow ? Colors.white : AppTheme.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Open Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Show only places currently open',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _filters.openNow,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() {
                _filters = _filters.copyWith(openNow: value);
              });
            },
            activeColor: AppTheme.success,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppTheme.border, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    if (_filters.hasActiveFilters) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_filters.activeFilterCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SECTION TITLE
// ============================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// FILTER CHIP
// ============================================================================

class _FilterChip extends StatefulWidget {
  const _FilterChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primaryOrange
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? AppTheme.primaryOrange
                  : AppTheme.border,
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                color: AppTheme.primaryOrange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? Colors.white
                      : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}