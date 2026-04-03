// lib/managers/reviews_manager.dart
// ✨ Complete ReviewsManager implementation with SharedPreferences

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Manages all review-related operations with local persistence
/// Uses Singleton pattern to ensure single instance across the app
class ReviewsManager extends ChangeNotifier {
  // Singleton pattern
  static final ReviewsManager _instance = ReviewsManager._internal();
  factory ReviewsManager() => _instance;
  ReviewsManager._internal();

  // Private fields
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  // Getters
  List<Map<String, dynamic>> get reviews => _reviews;
  bool get isLoading => _isLoading;
  int get reviewsCount => _reviews.length;

  /// Calculate average rating from all reviews
  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    double sum = _reviews.fold(
      0.0,
          (sum, review) => sum + (review['rating'] as num).toDouble(),
    );
    return sum / _reviews.length;
  }

  /// Load reviews from SharedPreferences
  Future<void> loadReviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? reviewsJson = prefs.getString('reviews');

      if (reviewsJson != null && reviewsJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(reviewsJson);
        _reviews = decoded.map((item) {
          return {
            'id': item['id'] as String,
            'placeName': item['placeName'] as String,
            'rating': (item['rating'] as num).toDouble(),
            'comment': item['comment'] as String? ?? '',
            'date': DateTime.parse(item['date'] as String),
            'updatedAt': item['updatedAt'] != null
                ? DateTime.parse(item['updatedAt'] as String)
                : null,
          };
        }).toList();

        // Sort by date (newest first)
        _reviews.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
      }
    } catch (e) {
      debugPrint('❌ Error loading reviews: $e');
      _reviews = []; // Reset to empty list on error
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Add a new review
  Future<void> addReview(Map<String, dynamic> review) async {
    try {
      _reviews.insert(0, review); // Add to beginning (newest first)
      await _saveReviews();
      notifyListeners();
      debugPrint('✅ Review added successfully');
    } catch (e) {
      debugPrint('❌ Error adding review: $e');
      rethrow;
    }
  }

  /// Update an existing review
  Future<void> updateReview(String id, Map<String, dynamic> updates) async {
    try {
      final index = _reviews.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _reviews[index] = {
          ..._reviews[index],
          ...updates,
          'updatedAt': DateTime.now(),
        };
        await _saveReviews();
        notifyListeners();
        debugPrint('✅ Review updated successfully');
      } else {
        debugPrint('⚠️ Review not found with id: $id');
      }
    } catch (e) {
      debugPrint('❌ Error updating review: $e');
      rethrow;
    }
  }

  /// Delete a review by ID
  Future<void> deleteReview(String id) async {
    try {
      final initialLength = _reviews.length;
      _reviews.removeWhere((r) => r['id'] == id);

      if (_reviews.length < initialLength) {
        await _saveReviews();
        notifyListeners();
        debugPrint('✅ Review deleted successfully');
      } else {
        debugPrint('⚠️ Review not found with id: $id');
      }
    } catch (e) {
      debugPrint('❌ Error deleting review: $e');
      rethrow;
    }
  }

  /// Clear all reviews
  Future<void> clearAllReviews() async {
    try {
      _reviews.clear();
      await _saveReviews();
      notifyListeners();
      debugPrint('✅ All reviews cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing reviews: $e');
      rethrow;
    }
  }

  /// Get reviews by rating
  List<Map<String, dynamic>> getReviewsByRating(int rating) {
    return _reviews
        .where((r) => (r['rating'] as num).toInt() == rating)
        .toList();
  }

  /// Get reviews for a specific place
  List<Map<String, dynamic>> getReviewsByPlace(String placeName) {
    return _reviews
        .where((r) => r['placeName'] == placeName)
        .toList();
  }

  /// Save reviews to SharedPreferences
  Future<void> _saveReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Convert reviews to JSON-serializable format
      final List<Map<String, dynamic>> serializable = _reviews.map((review) {
        return {
          'id': review['id'],
          'placeName': review['placeName'],
          'rating': review['rating'],
          'comment': review['comment'] ?? '',
          'date': (review['date'] as DateTime).toIso8601String(),
          'updatedAt': review['updatedAt'] != null
              ? (review['updatedAt'] as DateTime).toIso8601String()
              : null,
        };
      }).toList();

      // Save to SharedPreferences
      await prefs.setString('reviews', json.encode(serializable));
      debugPrint('💾 Reviews saved to local storage (${_reviews.length} items)');
    } catch (e) {
      debugPrint('❌ Error saving reviews: $e');
      rethrow;
    }
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    if (_reviews.isEmpty) {
      return {
        'totalReviews': 0,
        'averageRating': 0.0,
        'fiveStarCount': 0,
        'fourStarCount': 0,
        'threeStarCount': 0,
        'twoStarCount': 0,
        'oneStarCount': 0,
      };
    }

    return {
      'totalReviews': _reviews.length,
      'averageRating': averageRating,
      'fiveStarCount': getReviewsByRating(5).length,
      'fourStarCount': getReviewsByRating(4).length,
      'threeStarCount': getReviewsByRating(3).length,
      'twoStarCount': getReviewsByRating(2).length,
      'oneStarCount': getReviewsByRating(1).length,
    };
  }

  /// Check if a place has been reviewed
  bool hasReviewedPlace(String placeName) {
    return _reviews.any((r) => r['placeName'] == placeName);
  }

  /// Get the most recent review
  Map<String, dynamic>? get mostRecentReview {
    if (_reviews.isEmpty) return null;
    return _reviews.first;
  }

  /// Export reviews as JSON string (for backup/sharing)
  String exportReviewsAsJson() {
    try {
      final serializable = _reviews.map((review) {
        return {
          'id': review['id'],
          'placeName': review['placeName'],
          'rating': review['rating'],
          'comment': review['comment'],
          'date': (review['date'] as DateTime).toIso8601String(),
          'updatedAt': review['updatedAt'] != null
              ? (review['updatedAt'] as DateTime).toIso8601String()
              : null,
        };
      }).toList();

      return json.encode(serializable);
    } catch (e) {
      debugPrint('❌ Error exporting reviews: $e');
      return '[]';
    }
  }

  /// Import reviews from JSON string
  Future<void> importReviewsFromJson(String jsonString) async {
    try {
      final List<dynamic> decoded = json.decode(jsonString);
      final imported = decoded.map((item) {
        return {
          'id': item['id'] as String,
          'placeName': item['placeName'] as String,
          'rating': (item['rating'] as num).toDouble(),
          'comment': item['comment'] as String? ?? '',
          'date': DateTime.parse(item['date'] as String),
          'updatedAt': item['updatedAt'] != null
              ? DateTime.parse(item['updatedAt'] as String)
              : null,
        };
      }).toList();

      _reviews = imported;
      await _saveReviews();
      notifyListeners();
      debugPrint('✅ Reviews imported successfully (${_reviews.length} items)');
    } catch (e) {
      debugPrint('❌ Error importing reviews: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
    debugPrint('🧹 ReviewsManager disposed');
  }
}