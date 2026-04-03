// lib/presentation/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/presentation/taste_of_page/pages/taste_of_fes_page.dart';
import 'package:app_fez_my/presentation/shopping/pages/what_to_buy_page.dart';
import 'package:app_fez_my/presentation/travel/pages/getting_to_fes_page.dart';
import 'package:app_fez_my/presentation/pages/about_fes_page.dart';
import 'package:app_fez_my/presentation/travel/pages/local_transport_page.dart';
import 'package:app_fez_my/presentation/home/historical_sites/pages/historical_sites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      print('🎬 Starting video initialization...');

      // ✅ OPTION 1: Use asset video (if you have the video file)
      _controller = VideoPlayerController.asset(
        'assets/videos/fes_tourism.mp4',
      );

      // ✅ OPTION 2: Use network video (if you don't have local video)
      // Uncomment this and comment the asset line above
      // _controller = VideoPlayerController.networkUrl(
      //   Uri.parse(
      //     'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      //   ),
      // );

      print('📥 Loading video...');
      await _controller.initialize();

      print('✅ Video initialized successfully!');
      print('Duration: ${_controller.value.duration}');
      print('Size: ${_controller.value.size}');

      _controller.setLooping(true);
      _controller.setVolume(0); // Muted by default
      _controller.play();

      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _hasError = false;
        });
      }
    } catch (e) {
      print('❌ VIDEO ERROR: $e');

      if (mounted) {
        setState(() {
          _hasError = true;
          _isVideoInitialized = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Video failed to load: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ============================================================
          // HERO HEADER WITH VIDEO BACKGROUND
          // ============================================================
          Stack(
            children: [
              // Video Background
              SizedBox(
                height: 450,
                width: double.infinity,
                child: _hasError
                    ? _buildErrorPlaceholder(l10n)
                    : _isVideoInitialized
                    ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
                    : Container(
                  color: const Color(0xFF1A1A1A),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ),

              // Dark Overlay
              Container(
                height: 450,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              // Top Bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.visitFes,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          // Video Control Button (only show if video is loaded)
                          if (_isVideoInitialized && !_hasError)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          const SizedBox(width: 12),
                          // Shopping Cart
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Main Title in Center
              Positioned(
                left: 0,
                right: 0,
                top: 160,
                child: Center(
                  child: Column(
                    children: [
                      // Title with Shadow
                      Text(
                        l10n.fes,
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -2,
                          height: 1,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Badge with Orange gradient
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF6B35),
                              Color(0xFFFF8F00),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B35).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          l10n.culturalCapital,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ============================================================
          // GRID OF CARDS (2x3) - Enhanced with animations
          // ============================================================
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              childAspectRatio: 1.1,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              children: [
                _buildMenuCard(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: l10n.generalInformation,
                  color: const Color(0xFFFF6B35),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutFesPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context: context,
                  icon: Icons.favorite_outline_rounded,
                  title: l10n.topAttractions,
                  color: const Color(0xFF1A1A1A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoricalSitesPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context: context,
                  icon: Icons.alt_route_rounded,
                  title: l10n.gettingToFes,
                  color: const Color(0xFFFF6B35),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GettingToFesPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context: context,
                  icon: Icons.directions_bus_rounded,
                  title: l10n.localTransport,
                  color: const Color(0xFF1A1A1A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocalTransportPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context: context,
                  icon: Icons.restaurant_rounded,
                  title: l10n.tasteOfFes,
                  color: const Color(0xFFFF6B35),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasteOfFesPage(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context: context,
                  icon: Icons.shopping_bag_rounded,
                  title: l10n.whatToBuy,
                  color: const Color(0xFF1A1A1A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WhatToBuyPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Error Placeholder Widget (if video fails to load)
  Widget _buildErrorPlaceholder(AppLocalizations l10n) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2D2D2D),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mosque_outlined,
              size: 100,
              color: const Color(0xFFFF6B35).withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.discoverFes,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.videoUnavailable,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu Card Widget
  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: color.withOpacity(0.1),
      highlightColor: color.withOpacity(0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with effect
            Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                icon,
                size: 60,
                color: color,
              ),
            ),
            const SizedBox(height: 14),
            // Text
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
                height: 1.3,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}