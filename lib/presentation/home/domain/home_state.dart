// lib/presentation/home/domain/home_state.dart

/// Filter state for home page
class FilterState {
  final bool freeOnly;
  final bool openNow;
  final bool topRated;
  final bool nearby;

  const FilterState({
    required this.freeOnly,
    required this.openNow,
    required this.topRated,
    required this.nearby,
  });

  /// Initial state with no filters active
  factory FilterState.initial() {
    return const FilterState(
      freeOnly: false,
      openNow: false,
      topRated: false,
      nearby: false,
    );
  }

  /// Copy with method for immutable updates
  FilterState copyWith({
    bool? freeOnly,
    bool? openNow,
    bool? topRated,
    bool? nearby,
  }) {
    return FilterState(
      freeOnly: freeOnly ?? this.freeOnly,
      openNow: openNow ?? this.openNow,
      topRated: topRated ?? this.topRated,
      nearby: nearby ?? this.nearby,
    );
  }

  /// Check if any filters are active
  bool get hasActiveFilters => freeOnly || openNow || topRated || nearby;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterState &&
        other.freeOnly == freeOnly &&
        other.openNow == openNow &&
        other.topRated == topRated &&
        other.nearby == nearby;
  }

  @override
  int get hashCode {
    return Object.hash(freeOnly, openNow, topRated, nearby);
  }

  @override
  String toString() {
    return 'FilterState(freeOnly: $freeOnly, openNow: $openNow, topRated: $topRated, nearby: $nearby)';
  }
}

/// Filtered places organized by category
class FilteredPlaces {
  final List<Map<String, dynamic>> featured;
  final List<Map<String, dynamic>> popular;
  final List<Map<String, dynamic>> explore;
  final List<Map<String, dynamic>> highlights;
  final List<Map<String, dynamic>> cultural;
  final List<Map<String, dynamic>> relaxation;
  final List<Map<String, dynamic>> allPlaces;

  const FilteredPlaces({
    required this.featured,
    required this.popular,
    required this.explore,
    required this.highlights,
    required this.cultural,
    required this.relaxation,
    required this.allPlaces,
  });

  /// Empty state with no places
  factory FilteredPlaces.empty() {
    return const FilteredPlaces(
      featured: [],
      popular: [],
      explore: [],
      highlights: [],
      cultural: [],
      relaxation: [],
      allPlaces: [],
    );
  }

  /// Check if there are any results
  bool get hasResults => allPlaces.isNotEmpty;

  /// Total count of all places
  int get totalCount => allPlaces.length;

  /// Get count by category
  int get featuredCount => featured.length;
  int get popularCount => popular.length;
  int get exploreCount => explore.length;
  int get highlightsCount => highlights.length;
  int get culturalCount => cultural.length;
  int get relaxationCount => relaxation.length;

  @override
  String toString() {
    return 'FilteredPlaces(total: $totalCount, featured: $featuredCount, popular: $popularCount, explore: $exploreCount, highlights: $highlightsCount, cultural: $culturalCount, relaxation: $relaxationCount)';
  }
}