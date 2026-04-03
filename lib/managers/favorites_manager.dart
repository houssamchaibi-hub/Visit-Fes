// lib/managers/favorites_manager.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager extends ChangeNotifier {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal() {
    _loadFavorites();
  }

  List<Map<String, dynamic>> _favorites = [];
  Map<String, dynamic>? _lastDeletedFavorite;
  bool _isLoading = true;

  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get lastDeletedFavorite => _lastDeletedFavorite;

  static const String _favoritesKey = 'user_favorites';

  // Load favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson != null) {
        final List<dynamic> decodedList = json.decode(favoritesJson);
        _favorites = decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      _favorites = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String favoritesJson = json.encode(_favorites);
      await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Add favorite
  Future<void> addFavorite(Map<String, dynamic> favorite) async {
    if (!isFavorite(favorite['id'])) {
      _favorites.add(favorite);
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Remove favorite with undo support
  Future<void> removeFavorite(String id) async {
    final index = _favorites.indexWhere((f) => f['id'] == id);
    if (index != -1) {
      _lastDeletedFavorite = Map<String, dynamic>.from(_favorites[index]);
      _favorites.removeAt(index);
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Undo last delete
  Future<void> undoDelete() async {
    if (_lastDeletedFavorite != null) {
      _favorites.add(_lastDeletedFavorite!);
      await _saveFavorites();
      _lastDeletedFavorite = null;
      notifyListeners();
    }
  }

  // Clear undo buffer
  void clearUndoBuffer() {
    _lastDeletedFavorite = null;
  }

  // Check if item is favorite
  bool isFavorite(String id) {
    return _favorites.any((f) => f['id'] == id);
  }

  // Toggle favorite
  Future<void> toggleFavorite(Map<String, dynamic> item) async {
    if (isFavorite(item['id'])) {
      await removeFavorite(item['id']);
    } else {
      await addFavorite(item);
    }
  }

  // Get favorite by ID
  Map<String, dynamic>? getFavorite(String id) {
    try {
      return _favorites.firstWhere((f) => f['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  // Get favorites count
  int get favoritesCount => _favorites.length;

  // Get favorites by type
  List<Map<String, dynamic>> getFavoritesByType(String type) {
    return _favorites.where((f) => f['type'] == type).toList();
  }
}