import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:app_fez_my/navigation/main_app_scaffold.dart';
import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final List<Timer> _timers = [];

  bool _imageLoaded = false;
  bool _imageError = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    );
  }

  Future<void> _safeDelay(Duration duration) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    _timers.add(timer);
    return completer.future;
  }

  Future<void> _startAnimationSequence() async {
    await _safeDelay(const Duration(milliseconds: 200));
    if (!mounted) return;
    _controller.forward();
  }

  // Check connection when user presses button
  Future<bool> _checkConnection() async {
    try {
      // Check network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }

      // Verify actual internet connection
      final response = await http.get(
        Uri.parse('https://www.google.com'),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Handle Get Started button press
  void _handleGetStarted() async {
    if (_isNavigating) return;

    setState(() => _isNavigating = true);
    HapticFeedback.mediumImpact();

    // Check connection
    final hasConnection = await _checkConnection();

    if (!mounted) return;

    if (!hasConnection) {
      setState(() => _isNavigating = false);
      _showNoConnectionDialog();
      return;
    }

    // Navigate to main app
    await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainAppScaffold(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // Show no connection dialog
  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Colors.orange[400],
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'No Connection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Please check your internet connection and try again',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _handleGetStarted();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(),
          _buildGradientOverlay(),
          _buildContent(size, textScaleFactor),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Image.network(
      'https://images.pexels.com/photos/19190850/pexels-photo-19190850.jpeg',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_imageLoaded) {
              setState(() => _imageLoaded = true);
            }
          });
          return child;
        }
        return Container(
          color: const Color(0xFF1A1A1A),
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF9800)),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_imageError) {
            setState(() => _imageError = true);
          }
        });
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2C1810),
                Color(0xFF1A1A1A),
              ],
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.location_city,
              size: 120,
              color: Colors.white24,
            ),
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
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.85),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildContent(Size size, double textScaleFactor) {
    final isSmallScreen = size.height < 700;
    final contentPadding = isSmallScreen ? 24.0 : 32.0;
    final titleSize = isSmallScreen ? 40.0 : 48.0;
    final subtitleSize = isSmallScreen ? 14.0 : 16.0;

    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const Spacer(flex: 2),
            SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: contentPadding),
                child: Column(
                  children: [
                    _buildLogo(),
                    SizedBox(height: isSmallScreen ? 24 : 32),
                    _buildTitle(titleSize, textScaleFactor),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildSubtitle(subtitleSize, textScaleFactor),
                    SizedBox(height: isSmallScreen ? 40 : 60),
                    _buildGetStartedButton(),
                    SizedBox(height: isSmallScreen ? 40 : 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF9800).withOpacity(0.5),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.location_city,
        size: 48,
        color: Color(0xFFFF9800),
      ),
    );
  }

  Widget _buildTitle(double fontSize, double textScaleFactor) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: const Color(0xFFFF9800),
      period: const Duration(milliseconds: 2000),
      child: Text(
        'Visit Fez',
        style: TextStyle(
          fontSize: fontSize / textScaleFactor.clamp(1.0, 1.3),
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1.5,
          height: 1.2,
          shadows: [
            Shadow(
              offset: const Offset(0, 2),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.6),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle(double fontSize, double textScaleFactor) {
    return Text(
      'Explore Morocco\'s spiritual capital',
      style: TextStyle(
        fontSize: (fontSize - 4) / textScaleFactor.clamp(1.0, 1.3),
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.90),
        height: 1.4,
        letterSpacing: 0.5,
        shadows: [
          Shadow(
            offset: const Offset(0, 1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGetStartedButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isNavigating ? null : _handleGetStarted,
            borderRadius: BorderRadius.circular(30),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF9800),
                    Color(0xFFF57C00),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 18,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isNavigating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else ...[
                      const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    _controller.dispose();
    super.dispose();
  }
}