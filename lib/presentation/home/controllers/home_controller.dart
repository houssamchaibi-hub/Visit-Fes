// lib/presentation/home/controllers/home_controller.dart

import 'package:flutter/foundation.dart';
import '../domain/home_state.dart';

/// Business logic controller for home page
class HomeController extends ChangeNotifier {
  // State
  FilteredPlaces _filteredPlaces = FilteredPlaces.empty();
  FilterState _filterState = FilterState.initial();
  String _searchQuery = '';
  List<Map<String, dynamic>> _recentlyViewed = [];
  Set<String> _favorites = {};

  // Getters
  FilteredPlaces get filteredPlaces => _filteredPlaces;
  FilterState get filterState => _filterState;
  String get searchQuery => _searchQuery;
  List<Map<String, dynamic>> get recentlyViewed => _recentlyViewed;
  Set<String> get favorites => _favorites;

  bool get hasActiveFilters =>
      _filterState.freeOnly ||
          _filterState.openNow ||
          _filterState.topRated ||
          _filterState.nearby ||
          _searchQuery.isNotEmpty;

  // Initialize
  void initialize() {
    _loadMockData();
    _applyFilters();
  }

  // Data management
  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loadMockData();
    _applyFilters();
    notifyListeners();
  }

  // Search
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Filters
  void updateFilters(FilterState newState) {
    _filterState = newState;
    _applyFilters();
    notifyListeners();
  }

  void resetFilters() {
    _filterState = FilterState.initial();
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  void toggleFreeOnly() {
    _filterState = _filterState.copyWith(freeOnly: !_filterState.freeOnly);
    _applyFilters();
    notifyListeners();
  }

  void toggleOpenNow() {
    _filterState = _filterState.copyWith(openNow: !_filterState.openNow);
    _applyFilters();
    notifyListeners();
  }

  void toggleTopRated() {
    _filterState = _filterState.copyWith(topRated: !_filterState.topRated);
    _applyFilters();
    notifyListeners();
  }

  void toggleNearby() {
    _filterState = _filterState.copyWith(nearby: !_filterState.nearby);
    _applyFilters();
    notifyListeners();
  }

  void showNearbyPlaces() {
    _filterState = _filterState.copyWith(nearby: true);
    _applyFilters();
    notifyListeners();
  }

  String getFilterMessage() {
    final active = <String>[];
    if (_filterState.freeOnly) active.add('Free');
    if (_filterState.openNow) active.add('Open Now');
    if (_filterState.topRated) active.add('Top Rated');
    if (_filterState.nearby) active.add('Nearby');

    if (active.isEmpty) return '✓ No filters active';
    return '✓ Filters: ${active.join(', ')}';
  }

  // Recently viewed
  void addToRecentlyViewed(String placeId) {
    final place = _allPlaces.firstWhere(
          (p) => p['id'] == placeId,
      orElse: () => {},
    );

    if (place.isEmpty) return;

    _recentlyViewed.removeWhere((p) => p['id'] == placeId);
    _recentlyViewed.insert(0, place);

    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }

    notifyListeners();
  }

  void clearRecentlyViewed() {
    _recentlyViewed.clear();
    notifyListeners();
  }

  // Favorites
  bool isFavorite(String placeId) => _favorites.contains(placeId);

  void toggleFavorite(String placeId) {
    if (_favorites.contains(placeId)) {
      _favorites.remove(placeId);
    } else {
      _favorites.add(placeId);
    }
    notifyListeners();
  }

  // Private methods
  List<Map<String, dynamic>> _allPlaces = [];

  void _loadMockData() {
    _allPlaces = [
      // Featured places
      {
        'id': 'featured_1',
        'title': 'Bab Boujloud',
        'subtitle': 'The iconic Blue Gate',
        'imageUrl': 'https://images.unsplash.com/photo-1489749798305-4fea3ae63d43?w=800',
        'location': 'Medina, Fes',
        'rating': 4.8,
        'reviewCount': 2450,
        'description': 'The famous blue gate entrance to Fes el-Bali',
        'visitDuration': '30 mins',
        'isFree': true,
        'distanceKm': 0.5,
        'latitude': 34.0642,
        'longitude': -4.9758,
        'address': 'Medina, Fes',
        'category': 'featured',
      },
      {
        'id': 'featured_2',
        'title': 'Al-Qarawiyyin University',
        'subtitle': 'World\'s oldest university',
        'imageUrl': 'https://images.unsplash.com/photo-1564769625905-50e93615e769?w=800',
        'location': 'Medina, Fes',
        'rating': 4.9,
        'reviewCount': 1850,
        'description': 'Founded in 859 AD, the oldest continually operating university',
        'visitDuration': '2 hours',
        'isFree': false,
        'distanceKm': 0.8,
        'latitude': 34.0645,
        'longitude': -4.9780,
        'address': 'Medina, Fes',
        'category': 'featured',
      },
      {
        'id': 'featured_3',
        'title': 'Chouara Tannery',
        'subtitle': 'Ancient leather dyeing pits',
        'imageUrl': 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?w=800',
        'location': 'Medina, Fes',
        'rating': 4.6,
        'reviewCount': 3200,
        'description': 'Traditional leather tannery dating back to the 11th century',
        'visitDuration': '1 hour',
        'isFree': false,
        'distanceKm': 1.2,
        'latitude': 34.0658,
        'longitude': -4.9765,
        'address': 'Medina, Fes',
        'category': 'featured',
      },

      // Popular places
      {
        'id': 'popular_1',
        'title': 'Bou Inania Madrasa',
        'subtitle': 'Stunning Islamic architecture',
        'imageUrl': 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800',
        'location': 'Medina, Fes',
        'rating': 4.7,
        'reviewCount': 1620,
        'description': 'Beautiful 14th century Islamic school with intricate details',
        'visitDuration': '1 hour',
        'isFree': false,
        'distanceKm': 0.9,
        'latitude': 34.0652,
        'longitude': -4.9770,
        'address': 'Medina, Fes',
        'category': 'popular',
      },
      {
        'id': 'popular_2',
        'title': 'Nejjarine Museum',
        'subtitle': 'Wood arts and crafts',
        'imageUrl': 'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=800',
        'location': 'Medina, Fes',
        'rating': 4.5,
        'reviewCount': 980,
        'description': 'Museum showcasing traditional Moroccan woodworking',
        'visitDuration': '1.5 hours',
        'isFree': false,
        'distanceKm': 1.0,
        'latitude': 34.0648,
        'longitude': -4.9775,
        'address': 'Medina, Fes',
        'category': 'popular',
      },
      {
        'id': 'popular_3',
        'title': 'Dar Batha Museum',
        'subtitle': 'Traditional Moroccan arts',
        'imageUrl': 'https://images.unsplash.com/photo-1591825729269-caeb344f6df2?w=800',
        'location': 'Ville Nouvelle, Fes',
        'rating': 4.4,
        'reviewCount': 720,
        'description': 'Museum of traditional arts and crafts',
        'visitDuration': '2 hours',
        'isFree': false,
        'distanceKm': 1.5,
        'latitude': 34.0638,
        'longitude': -4.9785,
        'address': 'Ville Nouvelle, Fes',
        'category': 'popular',
      },

      // Explore places
      {
        'id': 'explore_1',
        'title': 'Mellah (Jewish Quarter)',
        'subtitle': 'Historic Jewish neighborhood',
        'imageUrl': 'https://images.unsplash.com/photo-1570654599445-8f6c0e5dd0d0?w=800',
        'location': 'Fes el-Jdid',
        'rating': 4.3,
        'reviewCount': 560,
        'description': 'Explore the historic Jewish quarter with its unique architecture',
        'visitDuration': '1.5 hours',
        'isFree': true,
        'distanceKm': 2.0,
        'latitude': 34.0610,
        'longitude': -4.9800,
        'address': 'Fes el-Jdid',
        'category': 'explore',
      },
      {
        'id': 'explore_2',
        'title': 'Royal Palace',
        'subtitle': 'Magnificent golden gates',
        'imageUrl': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'location': 'Fes el-Jdid',
        'rating': 4.6,
        'reviewCount': 1240,
        'description': 'View the stunning golden doors of the Royal Palace',
        'visitDuration': '30 mins',
        'isFree': true,
        'distanceKm': 2.2,
        'latitude': 34.0605,
        'longitude': -4.9810,
        'address': 'Fes el-Jdid',
        'category': 'explore',
      },

      // Hidden gems
      {
        'id': 'hidden_1',
        'title': 'Attarine Madrasa',
        'subtitle': 'Hidden architectural gem',
        'imageUrl': 'https://images.unsplash.com/photo-1590073844006-33249db05f79?w=800',
        'location': 'Medina, Fes',
        'rating': 4.8,
        'reviewCount': 420,
        'description': 'Smaller but equally beautiful 14th century madrasa',
        'visitDuration': '45 mins',
        'isFree': false,
        'distanceKm': 0.7,
        'latitude': 34.0655,
        'longitude': -4.9768,
        'address': 'Medina, Fes',
        'category': 'highlights',
      },
      {
        'id': 'hidden_2',
        'title': 'Zaouia Moulay Idriss II',
        'subtitle': 'Sacred shrine',
        'imageUrl': 'https://images.unsplash.com/photo-1584461687928-c5c6f894df8b?w=800',
        'location': 'Medina, Fes',
        'rating': 4.7,
        'reviewCount': 380,
        'description': 'Important religious site and peaceful sanctuary',
        'visitDuration': '30 mins',
        'isFree': true,
        'distanceKm': 0.6,
        'latitude': 34.0650,
        'longitude': -4.9772,
        'address': 'Medina, Fes',
        'category': 'highlights',
      },

      // Cultural experiences
      {
        'id': 'cultural_1',
        'title': 'Traditional Souk',
        'subtitle': 'Authentic market experience',
        'imageUrl': 'https://images.unsplash.com/photo-1577201339003-ec6f63d0ffce?w=800',
        'location': 'Medina, Fes',
        'rating': 4.5,
        'reviewCount': 2100,
        'description': 'Experience the bustling traditional marketplace',
        'visitDuration': '2 hours',
        'isFree': true,
        'distanceKm': 0.8,
        'latitude': 34.0648,
        'longitude': -4.9762,
        'address': 'Medina, Fes',
        'category': 'cultural',
      },
      {
        'id': 'cultural_2',
        'title': 'Pottery Quarter',
        'subtitle': 'Traditional ceramics',
        'imageUrl': 'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800',
        'location': 'Ain Nokbi',
        'rating': 4.4,
        'reviewCount': 680,
        'description': 'Watch artisans create traditional Fassi pottery',
        'visitDuration': '1 hour',
        'isFree': true,
        'distanceKm': 3.0,
        'latitude': 34.0580,
        'longitude': -4.9850,
        'address': 'Ain Nokbi',
        'category': 'cultural',
      },

      // Relaxation spots
      {
        'id': 'relax_1',
        'title': 'Jnan Sbil Gardens',
        'subtitle': 'Peaceful botanical garden',
        'imageUrl': 'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=800',
        'location': 'Near Bab Boujloud',
        'rating': 4.6,
        'reviewCount': 890,
        'description': 'Beautiful gardens perfect for a relaxing stroll',
        'visitDuration': '1 hour',
        'isFree': true,
        'distanceKm': 0.4,
        'latitude': 34.0635,
        'longitude': -4.9745,
        'address': 'Near Bab Boujloud',
        'category': 'relaxation',
      },
      {
        'id': 'relax_2',
        'title': 'Traditional Hammam',
        'subtitle': 'Authentic spa experience',
        'imageUrl': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
        'location': 'Medina, Fes',
        'rating': 4.7,
        'reviewCount': 1120,
        'description': 'Rejuvenate in a traditional Moroccan bathhouse',
        'visitDuration': '2 hours',
        'isFree': false,
        'distanceKm': 1.0,
        'latitude': 34.0640,
        'longitude': -4.9760,
        'address': 'Medina, Fes',
        'category': 'relaxation',
      },
    ];
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allPlaces);

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((place) {
        final title = (place['title'] ?? '').toLowerCase();
        final subtitle = (place['subtitle'] ?? '').toLowerCase();
        final location = (place['location'] ?? '').toLowerCase();
        return title.contains(query) ||
            subtitle.contains(query) ||
            location.contains(query);
      }).toList();
    }

    // Apply filters
    if (_filterState.freeOnly) {
      filtered = filtered.where((p) => p['isFree'] == true).toList();
    }
    if (_filterState.topRated) {
      filtered = filtered.where((p) => (p['rating'] ?? 0.0) >= 4.5).toList();
    }
    if (_filterState.nearby) {
      filtered = filtered.where((p) => (p['distanceKm'] ?? 100.0) <= 2.0).toList();
    }

    // Categorize filtered places
    final featured = filtered.where((p) => p['category'] == 'featured').toList();
    final popular = filtered.where((p) => p['category'] == 'popular').toList();
    final explore = filtered.where((p) => p['category'] == 'explore').toList();
    final highlights = filtered.where((p) => p['category'] == 'highlights').toList();
    final cultural = filtered.where((p) => p['category'] == 'cultural').toList();
    final relaxation = filtered.where((p) => p['category'] == 'relaxation').toList();

    _filteredPlaces = FilteredPlaces(
      featured: featured,
      popular: popular,
      explore: explore,
      highlights: highlights,
      cultural: cultural,
      relaxation: relaxation,
      allPlaces: filtered,
    );
  }
}