import 'dart:async';

class FavoritesService {
  final Set<String> _favoriteIds = {};
  final _controller = StreamController<Set<String>>.broadcast();

  Stream<Set<String>> get favoritesStream => _controller.stream;
  Set<String> getFavorites() => Set.from(_favoriteIds);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    _controller.add(getFavorites());
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void dispose() => _controller.close();
}