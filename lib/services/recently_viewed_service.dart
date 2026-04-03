import 'dart:async';

class RecentlyViewedService {
  final List<String> _recentlyViewed = [];
  static const int maxRecent = 10;
  final _controller = StreamController<List<String>>.broadcast();

  Stream<List<String>> get recentStream => _controller.stream;
  List<String> getRecentlyViewed() => List.from(_recentlyViewed);

  void addPlace(String id) {
    _recentlyViewed.remove(id);
    _recentlyViewed.insert(0, id);

    if (_recentlyViewed.length > maxRecent) {
      _recentlyViewed.removeRange(maxRecent, _recentlyViewed.length);
    }
    _controller.add(getRecentlyViewed());
  }

  void clearRecent() {
    _recentlyViewed.clear();
    _controller.add(getRecentlyViewed());
  }

  void dispose() => _controller.close();
}