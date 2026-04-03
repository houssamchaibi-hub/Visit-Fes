// ============================================================================
// SECTION ITEM CLASS - PRODUCTION READY
// ============================================================================
//
// A fully featured, immutable data class that wraps PlaceData with optional
// display configuration overrides.
//
// Features:
// - Null safety and defensive coding
// - Computed properties and convenience methods
// - Theme-aware display helpers
// - JSON serialization support
// - Equality and hashCode implementation
// - Immutable design
// - Comprehensive formatting utilities
//
// Usage:
// ```dart
// final item = SectionItem(
//   place: placeData,
//   config: PlaceDisplayConfig(titleOverride: 'Custom Title'),
// );
//
// print(item.formattedDistance); // "2.5 km"
// print(item.formattedReviewCount); // "1.2K"
// print(item.hasGalleryImages); // true
// ```
// ============================================================================

import 'package:flutter/material.dart';

// NOTE: You'll need to import your actual PlaceData and PlaceDisplayConfig classes
// import 'place_data.dart';
// import 'section_config.dart';

/// A production-ready, immutable wrapper class that combines PlaceData
/// with optional display configuration overrides.
///
/// This class provides safe access to place data, computed properties,
/// formatting utilities, and theme-aware display helpers.
@immutable
class SectionItem {
  /// The underlying place data
  final PlaceData place;

  /// Optional display configuration for overriding specific fields
  final PlaceDisplayConfig? config;

  /// Creates a new SectionItem with the given place data and optional config
  const SectionItem(
      this.place, [
        this.config,
      ]);

  // ==========================================================================
  // CORE DISPLAY PROPERTIES (with config overrides)
  // ==========================================================================

  /// Returns the display title, applying config override if present
  String get displayTitle => config?.titleOverride ?? place.title;

  /// Returns the display subtitle, applying config override if present
  String get displaySubtitle => config?.subtitleOverride ?? place.subtitle;

  /// Returns the display image URL, applying config override if present
  String get displayImage => config?.imageOverride ?? place.imageUrl;

  // ==========================================================================
  // DIRECT PLACE DATA ACCESS (null-safe)
  // ==========================================================================

  /// Unique identifier for the place
  String get id => place.id;

  /// Location/address of the place
  String get location => place.location;

  /// Rating value (0.0 - 5.0)
  double get rating => place.rating.clamp(0.0, 5.0);

  /// Number of reviews
  int get reviewCount => place.reviewCount.clamp(0, 999999999);

  /// Full description of the place
  String get description => place.description;

  /// Opening hours information (safe access)
  String get openingHours => place.openingHours;

  /// Gallery images (safe access, never returns null)
  List<String> get galleryImages => place.galleryImages;

  /// Whether the place is currently open
  bool get isOpenNow => place.isOpenNow;

  /// Distance in kilometers
  double get distanceKm => place.distanceKm;

  // ==========================================================================
  // COMPUTED PROPERTIES & CONVENIENCE METHODS
  // ==========================================================================

  /// Returns true if the place has gallery images
  bool get hasGalleryImages => galleryImages.isNotEmpty;

  /// Returns the number of gallery images
  int get galleryImageCount => galleryImages.length;

  /// Returns true if entry is free (you can customize this logic)
  bool get isFreeEntry {
    // This is a placeholder - adjust based on your PlaceData structure
    // For example, you might have: return place.entryPrice == 0 || place.entryPrice == null;
    return description.toLowerCase().contains('free');
  }

  /// Returns true if the place has reviews
  bool get hasReviews => reviewCount > 0;

  /// Returns true if the place has a high rating (≥4.0)
  bool get hasHighRating => rating >= 4.0;

  /// Returns true if the place has a very high rating (≥4.5)
  bool get hasExcellentRating => rating >= 4.5;

  /// Returns true if the place is nearby (within 1km)
  bool get isNearby => distanceKm > 0 && distanceKm <= 1.0;

  /// Returns true if opening hours information is available
  bool get hasOpeningHours => openingHours.isNotEmpty;

  /// Returns true if the place has a description
  bool get hasDescription => description.isNotEmpty;

  // ==========================================================================
  // FORMATTED OUTPUT METHODS
  // ==========================================================================

  /// Returns formatted distance string (e.g., "2.5 km", "500 m")
  String get formattedDistance {
    if (distanceKm <= 0) return 'Distance unknown';
    if (distanceKm < 1.0) {
      return '${(distanceKm * 1000).round()} m';
    }
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  /// Returns formatted review count (e.g., "1.2K", "15", "2.5M")
  String get formattedReviewCount {
    if (reviewCount <= 0) return 'No reviews';
    if (reviewCount < 1000) return reviewCount.toString();
    if (reviewCount < 1000000) {
      final k = reviewCount / 1000;
      return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
    }
    final m = reviewCount / 1000000;
    return m % 1 == 0 ? '${m.toInt()}M' : '${m.toStringAsFixed(1)}M';
  }

  /// Returns formatted rating (e.g., "4.5")
  String get formattedRating => rating.toStringAsFixed(1);

  /// Returns a short summary of the place
  String get shortSummary {
    final parts = <String>[];
    if (hasHighRating) parts.add('${formattedRating}★');
    if (hasReviews) parts.add(formattedReviewCount);
    if (distanceKm > 0) parts.add(formattedDistance);
    return parts.isEmpty ? 'No info' : parts.join(' • ');
  }

  // ==========================================================================
  // THEME-AWARE DISPLAY HELPERS
  // ==========================================================================

  /// Returns a color based on opening status
  /// - Green if open
  /// - Red if closed
  /// - Grey if unknown
  Color getStatusColor([Brightness brightness = Brightness.light]) {
    if (!hasOpeningHours) {
      return brightness == Brightness.dark ? Colors.grey[600]! : Colors.grey[400]!;
    }
    return isOpenNow ? Colors.green : Colors.red;
  }

  /// Returns an icon based on opening status
  IconData getStatusIcon() {
    if (!hasOpeningHours) return Icons.help_outline;
    return isOpenNow ? Icons.check_circle : Icons.cancel;
  }

  /// Returns a color based on rating
  /// - Gold for excellent (≥4.5)
  /// - Green for high (≥4.0)
  /// - Orange for medium (≥3.0)
  /// - Red for low (<3.0)
  Color getRatingColor() {
    if (rating >= 4.5) return Colors.amber[700]!;
    if (rating >= 4.0) return Colors.green[600]!;
    if (rating >= 3.0) return Colors.orange[600]!;
    return Colors.red[600]!;
  }

  /// Returns an icon for the rating
  IconData getRatingIcon() {
    if (rating >= 4.5) return Icons.star;
    if (rating >= 4.0) return Icons.star_half;
    return Icons.star_border;
  }

  /// Returns an icon for distance
  IconData getDistanceIcon() {
    if (isNearby) return Icons.near_me;
    return Icons.location_on;
  }

  // ==========================================================================
  // JSON SERIALIZATION
  // ==========================================================================

  /// Converts this SectionItem to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'place': place.toJson(),
      'config': config?.toJson(),
    };
  }

  /// Creates a SectionItem from a JSON map
  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      PlaceData.fromJson(json['place'] as Map<String, dynamic>),
      json['config'] != null
          ? PlaceDisplayConfig.fromJson(json['config'] as Map<String, dynamic>)
          : null,
    );
  }

  // ==========================================================================
  // EQUALITY & HASH CODE
  // ==========================================================================

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SectionItem &&
        other.place == place &&
        other.config == config;
  }

  @override
  int get hashCode => Object.hash(place, config);

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Creates a copy of this SectionItem with optional field updates
  SectionItem copyWith({
    PlaceData? place,
    PlaceDisplayConfig? config,
  }) {
    return SectionItem(
      place ?? this.place,
      config ?? this.config,
    );
  }

  /// Creates a copy without the display configuration
  SectionItem withoutConfig() {
    return SectionItem(place, null);
  }

  /// Creates a copy with a new display configuration
  SectionItem withConfig(PlaceDisplayConfig newConfig) {
    return SectionItem(place, newConfig);
  }

  @override
  String toString() {
    return 'SectionItem(id: $id, title: "$displayTitle", rating: $formattedRating, '
        'distance: $formattedDistance, isOpen: $isOpenNow)';
  }

  /// Returns a detailed debug string
  String toDebugString() {
    return '''
SectionItem {
  ID: $id
  Title: $displayTitle
  Subtitle: $displaySubtitle
  Location: $location
  Rating: $formattedRating ($formattedReviewCount)
  Distance: $formattedDistance
  Status: ${isOpenNow ? 'OPEN' : 'CLOSED'}
  Gallery: ${galleryImageCount} images
}''';
  }
}

// ============================================================================
// EXTENSION METHODS FOR COLLECTIONS
// ============================================================================

/// Extension methods for working with lists of SectionItems
extension SectionItemListExtensions on List<SectionItem> {
  /// Filters items that are currently open
  List<SectionItem> get openNow => where((item) => item.isOpenNow).toList();

  /// Filters items with high ratings (≥4.0)
  List<SectionItem> get highRated => where((item) => item.hasHighRating).toList();

  /// Filters items with free entry
  List<SectionItem> get freeEntry => where((item) => item.isFreeEntry).toList();

  /// Filters items that are nearby (≤1km)
  List<SectionItem> get nearby => where((item) => item.isNearby).toList();

  /// Filters items with gallery images
  List<SectionItem> get withGallery => where((item) => item.hasGalleryImages).toList();

  /// Sorts items by rating (highest first)
  List<SectionItem> sortedByRating() {
    final sorted = List<SectionItem>.from(this);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  /// Sorts items by distance (nearest first)
  List<SectionItem> sortedByDistance() {
    final sorted = List<SectionItem>.from(this);
    sorted.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sorted;
  }

  /// Sorts items by review count (most reviewed first)
  List<SectionItem> sortedByPopularity() {
    final sorted = List<SectionItem>.from(this);
    sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return sorted;
  }

  /// Returns the average rating of all items
  double get averageRating {
    if (isEmpty) return 0.0;
    return fold<double>(0, (sum, item) => sum + item.rating) / length;
  }

  /// Returns the total review count of all items
  int get totalReviews {
    return fold<int>(0, (sum, item) => sum + item.reviewCount);
  }
}

// ============================================================================
// PLACEHOLDER CLASSES (Replace with your actual implementations)
// ============================================================================

// These are placeholder classes. Replace them with your actual PlaceData and
// PlaceDisplayConfig classes from your project.

class PlaceData {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final String description;
  final String openingHours;
  final List<String> galleryImages;
  final bool isOpenNow;
  final double distanceKm;

  const PlaceData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.openingHours,
    required this.galleryImages,
    required this.isOpenNow,
    required this.distanceKm,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'imageUrl': imageUrl,
    'location': location,
    'rating': rating,
    'reviewCount': reviewCount,
    'description': description,
    'openingHours': openingHours,
    'galleryImages': galleryImages,
    'isOpenNow': isOpenNow,
    'distanceKm': distanceKm,
  };

  factory PlaceData.fromJson(Map<String, dynamic> json) => PlaceData(
    id: json['id'] as String,
    title: json['title'] as String,
    subtitle: json['subtitle'] as String,
    imageUrl: json['imageUrl'] as String,
    location: json['location'] as String,
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'] as int,
    description: json['description'] as String,
    openingHours: json['openingHours'] as String,
    galleryImages: List<String>.from(json['galleryImages'] as List),
    isOpenNow: json['isOpenNow'] as bool,
    distanceKm: (json['distanceKm'] as num).toDouble(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlaceData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class PlaceDisplayConfig {
  final String? titleOverride;
  final String? subtitleOverride;
  final String? imageOverride;

  const PlaceDisplayConfig({
    this.titleOverride,
    this.subtitleOverride,
    this.imageOverride,
  });

  PlaceDisplayConfig copyWith({
    String? titleOverride,
    String? subtitleOverride,
    String? imageOverride,
  }) {
    return PlaceDisplayConfig(
      titleOverride: titleOverride ?? this.titleOverride,
      subtitleOverride: subtitleOverride ?? this.subtitleOverride,
      imageOverride: imageOverride ?? this.imageOverride,
    );
  }

  Map<String, dynamic> toJson() => {
    'titleOverride': titleOverride,
    'subtitleOverride': subtitleOverride,
    'imageOverride': imageOverride,
  };

  factory PlaceDisplayConfig.fromJson(Map<String, dynamic> json) => PlaceDisplayConfig(
    titleOverride: json['titleOverride'] as String?,
    subtitleOverride: json['subtitleOverride'] as String?,
    imageOverride: json['imageOverride'] as String?,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlaceDisplayConfig &&
              titleOverride == other.titleOverride &&
              subtitleOverride == other.subtitleOverride &&
              imageOverride == other.imageOverride;

  @override
  int get hashCode => Object.hash(titleOverride, subtitleOverride, imageOverride);
}