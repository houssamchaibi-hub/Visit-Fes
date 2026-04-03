// lib/presentation/travel/pages/local_transport_page.dart
import 'package:flutter/material.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math' as math;

class LocalTransportPage extends StatefulWidget {
  const LocalTransportPage({super.key});

  @override
  State<LocalTransportPage> createState() => _LocalTransportPageState();
}

class _LocalTransportPageState extends State<LocalTransportPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Builds the transport-option list from localised strings at call time so
  /// that the current locale is always respected (even after a language switch).
  List<Map<String, dynamic>> _transportOptions() {
    final l = AppLocalizations.of(context)!;
    return [
      {
        'id': 'petit_taxi',
        'title': l.localTransportPetitTaxi,
        'titleAr': l.localTransportPetitTaxiAr,
        'description': l.localTransportPetitTaxiDesc,
        'price': l.localTransportPetitTaxiPrice,
        'icon': Icons.local_taxi,
        'color': const Color(0xFF2196F3),
        'rating': 4.2,
        'details': l.localTransportPetitTaxiDetails,
      },
      {
        'id': 'grand_taxi',
        'title': l.localTransportGrandTaxi,
        'titleAr': l.localTransportGrandTaxiAr,
        'description': l.localTransportGrandTaxiDesc,
        'price': l.localTransportGrandTaxiPrice,
        'icon': Icons.airport_shuttle,
        'color': const Color(0xFFFF9800),
        'rating': 4.0,
        'details': l.localTransportGrandTaxiDetails,
      },
      {
        'id': 'bus',
        'title': l.localTransportCityBus,
        'titleAr': l.localTransportCityBusAr,
        'description': l.localTransportCityBusDesc,
        'price': l.localTransportCityBusPrice,
        'icon': Icons.directions_bus,
        'color': const Color(0xFF4CAF50),
        'rating': 3.5,
        'details': l.localTransportCityBusDetails,
      },
      {
        'id': 'walking',
        'title': l.localTransportWalking,
        'titleAr': l.localTransportWalkingAr,
        'description': l.localTransportWalkingDesc,
        'price': l.free,
        'icon': Icons.directions_walk,
        'color': const Color(0xFF9C27B0),
        'rating': 4.8,
        'details': l.localTransportWalkingDetails,
      },
      {
        'id': 'bike',
        'title': l.localTransportBikeRental,
        'titleAr': l.localTransportBikeRentalAr,
        'description': l.localTransportBikeRentalDesc,
        'price': l.localTransportBikeRentalPrice,
        'icon': Icons.pedal_bike,
        'color': const Color(0xFFE91E63),
        'rating': 3.8,
        'details': l.localTransportBikeRentalDetails,
      },
      {
        'id': 'private_driver',
        'title': l.localTransportPrivateDriver,
        'titleAr': l.localTransportPrivateDriverAr,
        'description': l.localTransportPrivateDriverDesc,
        'price': l.localTransportPrivateDriverPrice,
        'icon': Icons.car_rental,
        'color': const Color(0xFF607D8B),
        'rating': 4.6,
        'details': l.localTransportPrivateDriverDetails,
      },
    ];
  }

  List<Map<String, dynamic>> get filteredOptions {
    final options = _transportOptions();
    if (_searchQuery.isEmpty) return options;

    return options.where((option) {
      final query = _searchQuery.toLowerCase();
      return option['title'].toString().toLowerCase().contains(query) ||
          option['titleAr'].toString().contains(query) ||
          option['description'].toString().toLowerCase().contains(query);
    }).toList();
  }

  void _showDetails(Map<String, dynamic> option) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: option['color'],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(option['icon'], color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['title'],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            option['titleAr'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: 'Amiri',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  option['description'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: option['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: option['color'].withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.payments, color: option['color'], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l.priceRange,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['price'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: option['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: option['color'].withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: option['color'], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l.importantInfo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option['details'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF2196F3).withOpacity(0.4),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.local_taxi,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                            ).createShader(bounds),
                            child: Text(
                              l.localTransport,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: l.searchTransport,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Transport Cards
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final option = filteredOptions[index];
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final delay = index * 0.1;
                      final animationValue = Curves.easeOutCubic.transform(
                        math.max(0, (_animationController.value - delay) / (1 - delay)),
                      );

                      return Opacity(
                        opacity: animationValue,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - animationValue)),
                          child: child,
                        ),
                      );
                    },
                    child: GestureDetector(
                      onTap: () => _showDetails(option),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF2D2D2D).withOpacity(0.9),
                              const Color(0xFF1A1A1A).withOpacity(0.9),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: option['color'].withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: option['color'].withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    option['icon'],
                                    color: option['color'],
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option['title'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        option['titleAr'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.6),
                                          fontFamily: 'Amiri',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: option['color'],
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              option['description'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.7),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  option['rating'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: option['color'].withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: option['color'].withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    option['price'],
                                    style: TextStyle(
                                      color: option['color'],
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredOptions.length,
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2D2D2D).withOpacity(0.8),
                    const Color(0xFF1A1A1A).withOpacity(0.95),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2196F3).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF2196F3), size: 32),
                  const SizedBox(height: 12),
                  Text(
                    l.needHelpTransport,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.askHotelRiad,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}