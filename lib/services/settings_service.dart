import 'dart:async';

class SettingsService {
  bool _isDarkMode = false;
  bool _isFirstLaunch = true;
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get darkModeStream => _controller.stream;
  bool isDarkMode() => _isDarkMode;

  void setDarkMode(bool value) {
    _isDarkMode = value;
    _controller.add(value);
  }

  bool isFirstLaunch() => _isFirstLaunch;
  void setFirstLaunchComplete() => _isFirstLaunch = false;
  void dispose() => _controller.close();
}