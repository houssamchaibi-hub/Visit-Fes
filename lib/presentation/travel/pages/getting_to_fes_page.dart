// lib/presentation/travel/pages/getting_to_fes_page_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/presentation/travel/pages/transport_details_page.dart';

// ============================================================================
// MODELS
// ============================================================================

enum TransportType {
  plane,
  train,
  bus,
  car,
  taxi,
}

enum SortOption {
  priceAsc,
  priceDesc,
  durationAsc,
  popularity,
}

class TransportOption {
  final String id;
  final String title;
  final String titleAr;
  final TransportType type;
  final String description;
  final String duration;
  final String price;
  final double priceValue;
  final int durationMinutes;
  final Color color;
  final IconData icon;
  final List<String> pros;
  final List<String> cons;
  final List<RouteDetail> routes;
  final String bookingInfo;
  final String tips;
  final double rating;
  final int reviewCount;

  TransportOption({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.type,
    required this.description,
    required this.duration,
    required this.price,
    required this.priceValue,
    required this.durationMinutes,
    required this.color,
    required this.icon,
    required this.pros,
    required this.cons,
    required this.routes,
    required this.bookingInfo,
    required this.tips,
    this.rating = 4.0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'titleAr': titleAr,
  };

  factory TransportOption.fromJson(Map<String, dynamic> json) {
    return TransportOption(
      id: json['id'],
      title: json['title'],
      titleAr: json['titleAr'],
      type: TransportType.values[0],
      description: '',
      duration: '',
      price: '',
      priceValue: 0,
      durationMinutes: 0,
      color: Colors.blue,
      icon: Icons.flight,
      pros: [],
      cons: [],
      routes: [],
      bookingInfo: '',
      tips: '',
    );
  }
}

class RouteDetail {
  final String from;
  final String to;
  final String frequency;
  final String duration;
  final String price;
  final String? mapUrl;

  RouteDetail({
    required this.from,
    required this.to,
    required this.frequency,
    required this.duration,
    required this.price,
    this.mapUrl,
  });
}

class AirportInfo {
  final String name;
  final String nameAr;
  final String code;
  final String location;
  final String distance;
  final List<String> facilities;
  final List<String> airlines;
  final String transferInfo;
  final String mapUrl;

  AirportInfo({
    required this.name,
    required this.nameAr,
    required this.code,
    required this.location,
    required this.distance,
    required this.facilities,
    required this.airlines,
    required this.transferInfo,
    this.mapUrl = 'https://maps.google.com/?q=Fes-Saiss+Airport',
  });
}

class TravelTip {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  TravelTip({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// ============================================================================
// MAIN PAGE
// ============================================================================

class GettingToFesPage extends StatefulWidget {
  const GettingToFesPage({super.key});

  @override
  State<GettingToFesPage> createState() => _GettingToFesPageState();
}

class _GettingToFesPageState extends State<GettingToFesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  TransportType? _selectedType;
  SortOption _sortOption = SortOption.popularity;
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _searchController = TextEditingController();

  late List<TransportOption> transportOptions;
  late AirportInfo airportInfo;
  late List<TravelTip> travelTips;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;

    transportOptions = _buildTransportOptions(l10n);
    airportInfo = _buildAirportInfo(l10n);
    travelTips = _buildTravelTips(l10n);

    if (_isLoading) {
      _loadData();
    }
  }

  List<TransportOption> _buildTransportOptions(AppLocalizations l10n) {
    return [
      // PLANE
      TransportOption(
        id: 'plane_001',
        title: l10n.transportByPlane,
        titleAr: l10n.transportByPlaneAr,
        type: TransportType.plane,
        description: l10n.transportPlaneDesc,
        duration: l10n.variesByOrigin,
        price: '500-3000 MAD',
        priceValue: 1500,
        durationMinutes: 195,
        color: const Color(0xFF2196F3),
        icon: Icons.flight,
        rating: 4.5,
        reviewCount: 234,
        pros: [
          l10n.fastestOption,
          l10n.directFlights,
          l10n.comfortableReliable,
          l10n.airportCloseToCity,
        ],
        cons: [
          l10n.moreExpensive,
          l10n.limitedFlightFrequency,
          l10n.requiresAdvanceBooking,
          l10n.additionalTransferCosts,
        ],
        routes: [
          RouteDetail(
            from: 'Paris (CDG/ORY)',
            to: 'Fes (FEZ)',
            frequency: l10n.daily,
            duration: '3h 15${l10n.minutesShort}',
            price: '800-2500 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Paris&daddr=Fes',
          ),
          RouteDetail(
            from: 'Casablanca (CMN)',
            to: 'Fes (FEZ)',
            frequency: l10n.multipleDaily,
            duration: '55 ${l10n.minutesShort}',
            price: '500-1200 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Casablanca&daddr=Fes',
          ),
          RouteDetail(
            from: 'Brussels (BRU)',
            to: 'Fes (FEZ)',
            frequency: '3-4 ${l10n.weekly}',
            duration: '3h 30${l10n.minutesShort}',
            price: '900-2800 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Brussels&daddr=Fes',
          ),
        ],
        bookingInfo: l10n.bookingInfoPlane,
        tips: l10n.tipsPlane,
      ),

      // TRAIN
      TransportOption(
        id: 'train_001',
        title: l10n.transportByTrain,
        titleAr: l10n.transportByTrainAr,
        type: TransportType.train,
        description: l10n.transportTrainDesc,
        duration: '3-7 ${l10n.hoursShort}',
        price: '80-300 MAD',
        priceValue: 150,
        durationMinutes: 235,
        color: const Color(0xFF4CAF50),
        icon: Icons.train,
        rating: 4.3,
        reviewCount: 456,
        pros: [
          l10n.comfortableSpacious,
          l10n.scenicRoutes,
          l10n.reliableSchedule,
          l10n.affordablePricing,
          l10n.centralStationLocation,
          l10n.airConditionedCarriages,
        ],
        cons: [
          l10n.slowerThanFlying,
          l10n.limitedRoutes,
          l10n.crowdedDuringHolidays,
          l10n.firstClassFillsQuickly,
        ],
        routes: [
          RouteDetail(
            from: 'Casablanca Voyageurs',
            to: 'Fes',
            frequency: l10n.everyHours('1-2'),
            duration: '3h 55${l10n.minutesShort}',
            price: '100-165 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Casablanca&daddr=Fes',
          ),
          RouteDetail(
            from: 'Rabat',
            to: 'Fes',
            frequency: l10n.everyHours('1-2'),
            duration: '2h 30${l10n.minutesShort}',
            price: '80-135 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Rabat&daddr=Fes',
          ),
          RouteDetail(
            from: 'Marrakech',
            to: 'Fes',
            frequency: '3-4 ${l10n.daily}',
            duration: '7h 30${l10n.minutesShort}',
            price: '200-310 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Marrakech&daddr=Fes',
          ),
          RouteDetail(
            from: 'Tangier',
            to: 'Fes',
            frequency: '4-5 ${l10n.daily}',
            duration: '4h 40${l10n.minutesShort}',
            price: '130-215 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Tangier&daddr=Fes',
          ),
          RouteDetail(
            from: 'Meknes',
            to: 'Fes',
            frequency: l10n.everyHours('30-60 min'),
            duration: '35-45 ${l10n.minutesShort}',
            price: '22-35 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Meknes&daddr=Fes',
          ),
        ],
        bookingInfo: l10n.bookingInfoTrain,
        tips: l10n.tipsTrain,
      ),

      // BUS
      TransportOption(
        id: 'bus_001',
        title: l10n.transportByBus,
        titleAr: l10n.transportByBusAr,
        type: TransportType.bus,
        description: l10n.transportBusDesc,
        duration: '4-9 ${l10n.hoursShort}',
        price: '50-250 MAD',
        priceValue: 120,
        durationMinutes: 390,
        color: const Color(0xFFFF9800),
        icon: Icons.directions_bus,
        rating: 4.0,
        reviewCount: 567,
        pros: [
          l10n.mostEconomical,
          l10n.extensiveNetwork,
          l10n.frequentDepartures,
          l10n.directRoutesToManyCities,
          l10n.goodForBudget,
        ],
        cons: [
          l10n.longerTravelTime,
          l10n.lessComfortableThanTrain,
          l10n.canBeCrowded,
          l10n.limitedLegroom,
          l10n.stopsAlongWay,
        ],
        routes: [
          RouteDetail(
            from: 'Casablanca',
            to: 'Fes',
            frequency: l10n.everyHours('hour'),
            duration: '4h 30${l10n.minutesShort}',
            price: '90-110 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Casablanca&daddr=Fes',
          ),
          RouteDetail(
            from: 'Marrakech',
            to: 'Fes',
            frequency: '4-5 ${l10n.daily}',
            duration: '8-9 ${l10n.hoursShort}',
            price: '200-250 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Marrakech&daddr=Fes',
          ),
          RouteDetail(
            from: 'Chefchaouen',
            to: 'Fes',
            frequency: '3-4 ${l10n.daily}',
            duration: '4 ${l10n.hoursShort}',
            price: '70-85 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Chefchaouen&daddr=Fes',
          ),
          RouteDetail(
            from: 'Rabat',
            to: 'Fes',
            frequency: l10n.everyHours('1-2'),
            duration: '3h 30${l10n.minutesShort}',
            price: '70-90 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Rabat&daddr=Fes',
          ),
        ],
        bookingInfo: l10n.bookingInfoBus,
        tips: l10n.tipsBus,
      ),

      // CAR
      TransportOption(
        id: 'car_001',
        title: l10n.transportByCar,
        titleAr: l10n.transportByCarAr,
        type: TransportType.car,
        description: l10n.transportCarDesc,
        duration: '3-8 ${l10n.hoursShort}',
        price: '300-800 MAD${l10n.perDay}',
        priceValue: 500,
        durationMinutes: 330,
        color: const Color(0xFF9C27B0),
        icon: Icons.directions_car,
        rating: 4.2,
        reviewCount: 189,
        pros: [
          l10n.completeFlexibility,
          l10n.stopAtAttractions,
          l10n.goodForGroups,
          l10n.exploreSurroundingAreas,
          l10n.carryMoreLuggage,
        ],
        cons: [
          l10n.drivingCanBeChallenging,
          l10n.parkingDifficult,
          l10n.tollRoadsAddCost,
          l10n.fuelCosts,
          l10n.needInternationalLicense,
        ],
        routes: [
          RouteDetail(
            from: 'Casablanca',
            to: 'Fes',
            frequency: l10n.anytime,
            duration: '3h 15${l10n.minutesShort}',
            price: '${l10n.fuel}: ~200 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Casablanca&daddr=Fes&dirflg=d',
          ),
          RouteDetail(
            from: 'Marrakech',
            to: 'Fes',
            frequency: l10n.anytime,
            duration: '6h 30${l10n.minutesShort}',
            price: '${l10n.fuel}: ~400 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Marrakech&daddr=Fes&dirflg=d',
          ),
          RouteDetail(
            from: 'Rabat',
            to: 'Fes',
            frequency: l10n.anytime,
            duration: '2h 15${l10n.minutesShort}',
            price: '${l10n.fuel}: ~150 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Rabat&daddr=Fes&dirflg=d',
          ),
          RouteDetail(
            from: 'Tangier',
            to: 'Fes',
            frequency: l10n.anytime,
            duration: '4h 15${l10n.minutesShort}',
            price: '${l10n.fuel}: ~250 MAD',
            mapUrl: 'https://maps.google.com/?saddr=Tangier&daddr=Fes&dirflg=d',
          ),
        ],
        bookingInfo: l10n.bookingInfoCar,
        tips: l10n.tipsCar,
      ),

      // GRAND TAXI
      TransportOption(
        id: 'taxi_001',
        title: l10n.transportByTaxi,
        titleAr: l10n.transportByTaxiAr,
        type: TransportType.taxi,
        description: l10n.transportTaxiDesc,
        duration: '1-3 ${l10n.hoursShort}',
        price: '20-150 MAD',
        priceValue: 70,
        durationMinutes: 120,
        color: const Color(0xFFF44336),
        icon: Icons.local_taxi,
        rating: 3.8,
        reviewCount: 312,
        pros: [
          l10n.veryEconomicalShared,
          l10n.fasterThanBus,
          l10n.frequentWhenFull,
          l10n.directRoutesShort,
          l10n.localExperience,
        ],
        cons: [
          l10n.waitUntilFull,
          l10n.canBeCramped,
          l10n.noFixedSchedule,
          l10n.limitedLuggageSpace,
          l10n.notComfortableLongDistances,
        ],
        routes: [
          RouteDetail(
            from: 'Meknes',
            to: 'Fes',
            frequency: l10n.continuous,
            duration: '45 ${l10n.minutesShort}',
            price: '20-25 MAD${l10n.perSeat}',
            mapUrl: 'https://maps.google.com/?saddr=Meknes&daddr=Fes',
          ),
          RouteDetail(
            from: 'Ifrane',
            to: 'Fes',
            frequency: l10n.regular,
            duration: '1 hour',
            price: '30-35 MAD${l10n.perSeat}',
            mapUrl: 'https://maps.google.com/?saddr=Ifrane&daddr=Fes',
          ),
          RouteDetail(
            from: 'Sefrou',
            to: 'Fes',
            frequency: l10n.continuous,
            duration: '30 ${l10n.minutesShort}',
            price: '15-20 MAD${l10n.perSeat}',
            mapUrl: 'https://maps.google.com/?saddr=Sefrou&daddr=Fes',
          ),
          RouteDetail(
            from: 'Taza',
            to: 'Fes',
            frequency: l10n.regular,
            duration: '2 ${l10n.hoursShort}',
            price: '50-60 MAD${l10n.perSeat}',
            mapUrl: 'https://maps.google.com/?saddr=Taza&daddr=Fes',
          ),
        ],
        bookingInfo: l10n.bookingInfoTaxi,
        tips: l10n.tipsTaxi,
      ),
    ];
  }

  AirportInfo _buildAirportInfo(AppLocalizations l10n) {
    return AirportInfo(
      name: l10n.fesSaissAirport,
      nameAr: l10n.fesSaissAirportAr,
      code: l10n.airportCode,
      location: l10n.airportLocation,
      distance: l10n.distanceToMedina,
      facilities: [
        l10n.freeWifi,
        l10n.cafesRestaurants,
        l10n.carRentalDesks,
        l10n.atmsExchange,
        l10n.dutyFreeShops,
        l10n.prayerRoom,
      ],
      airlines: [
        l10n.royalAirMaroc,
        l10n.ryanair,
        l10n.airArabia,
        l10n.transavia,
        l10n.vueling,
      ],
      transferInfo: l10n.transferInfo,
      mapUrl: 'https://maps.google.com/?q=Fes-Saiss+Airport',
    );
  }

  List<TravelTip> _buildTravelTips(AppLocalizations l10n) {
    return [
      TravelTip(
        title: l10n.bestTimeToTravel,
        description: l10n.bestTimeDesc,
        icon: Icons.wb_sunny,
        color: const Color(0xFFFFB300),
      ),
      TravelTip(
        title: l10n.bookInAdvance,
        description: l10n.bookInAdvanceDesc,
        icon: Icons.calendar_today,
        color: const Color(0xFF2196F3),
      ),
      TravelTip(
        title: l10n.travelDocuments,
        description: l10n.travelDocumentsDesc,
        icon: Icons.description,
        color: const Color(0xFF4CAF50),
      ),
      TravelTip(
        title: l10n.luggageTips,
        description: l10n.luggageTipsDesc,
        icon: Icons.luggage,
        color: const Color(0xFF9C27B0),
      ),
      TravelTip(
        title: l10n.localCurrency,
        description: l10n.localCurrencyDesc,
        icon: Icons.payments,
        color: const Color(0xFFFF5722),
      ),
      TravelTip(
        title: l10n.stayConnected,
        description: l10n.stayConnectedDesc,
        icon: Icons.wifi,
        color: const Color(0xFF00BCD4),
      ),
    ];
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.failedToLoadData;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<TransportOption> get filteredOptions {
    var options = transportOptions;

    if (_selectedType != null) {
      options = options.where((opt) => opt.type == _selectedType).toList();
    }

    if (_searchQuery.isNotEmpty) {
      options = options.where((opt) {
        final query = _searchQuery.toLowerCase();
        return opt.title.toLowerCase().contains(query) ||
            opt.titleAr.contains(query) ||
            opt.description.toLowerCase().contains(query) ||
            opt.routes.any((route) =>
            route.from.toLowerCase().contains(query) ||
                route.to.toLowerCase().contains(query));
      }).toList();
    }

    switch (_sortOption) {
      case SortOption.priceAsc:
        options.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case SortOption.priceDesc:
        options.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case SortOption.durationAsc:
        options.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
      case SortOption.popularity:
        options.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return options;
  }

  void _showTransportDetails(TransportOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransportDetailsPage(
          option: option,
          isFavorite: false,
          onFavoriteToggle: () {},
        ),
      ),
    );
  }

  void _showAirportInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AirportInfoModal(info: airportInfo),
    );
  }

  void _showPriceComparison() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PriceComparisonModal(options: transportOptions),
    );
  }

  void _showSortOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D2D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.sort, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    l10n.sortBy,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            _SortOptionTile(
              title: l10n.sortPriceLowToHigh,
              icon: Icons.arrow_upward,
              isSelected: _sortOption == SortOption.priceAsc,
              onTap: () {
                setState(() => _sortOption = SortOption.priceAsc);
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              title: l10n.sortPriceHighToLow,
              icon: Icons.arrow_downward,
              isSelected: _sortOption == SortOption.priceDesc,
              onTap: () {
                setState(() => _sortOption = SortOption.priceDesc);
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              title: l10n.sortDurationShortest,
              icon: Icons.access_time,
              isSelected: _sortOption == SortOption.durationAsc,
              onTap: () {
                setState(() => _sortOption = SortOption.durationAsc);
                Navigator.pop(context);
              },
            ),
            _SortOptionTile(
              title: l10n.sortMostPopular,
              icon: Icons.star,
              isSelected: _sortOption == SortOption.popularity,
              onTap: () {
                setState(() => _sortOption = SortOption.popularity);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF2196F3)),
              const SizedBox(height: 24),
              Text(
                l10n.loadingTravelOptions,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 24),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            // ✅ Removed: favorite button from AppBar
            actions: [
              IconButton(
                icon: const Icon(Icons.compare_arrows, color: Colors.white),
                onPressed: _showPriceComparison,
                tooltip: l10n.comparePrices,
              ),
              IconButton(
                icon: const Icon(Icons.sort, color: Colors.white),
                onPressed: _showSortOptions,
                tooltip: l10n.sortOptions,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1A1A1A),
                          Color(0xFF2D2D2D),
                          Color(0xFF1A1A1A),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.1,
                    child: CustomPaint(painter: TravelPatternPainter()),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
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
                                    Icons.flight_takeoff,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF00BCD4), Color(0xFF2196F3)],
                              ).createShader(bounds),
                              child: Text(
                                l10n.gettingToFesTitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(opacity: value, child: child);
                            },
                            child: Text(
                              l10n.gettingToFesSubtitle,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF00BCD4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white70, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: l10n.searchRoutesPlaceholder,
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) {
                                      setState(() => _searchQuery = value);
                                    },
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _showAirportInfo,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flight, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${l10n.fesSaissAirport} (${l10n.airportCode})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '15km ${l10n.fromMedina} • ${l10n.tapForDetails}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _TransportTypeChip(
                    label: l10n.allTransport,
                    icon: Icons.apps,
                    isSelected: _selectedType == null,
                    onTap: () => setState(() => _selectedType = null),
                  ),
                  _TransportTypeChip(
                    label: l10n.plane,
                    icon: Icons.flight,
                    isSelected: _selectedType == TransportType.plane,
                    color: const Color(0xFF2196F3),
                    onTap: () => setState(() => _selectedType = TransportType.plane),
                  ),
                  _TransportTypeChip(
                    label: l10n.train,
                    icon: Icons.train,
                    isSelected: _selectedType == TransportType.train,
                    color: const Color(0xFF4CAF50),
                    onTap: () => setState(() => _selectedType = TransportType.train),
                  ),
                  _TransportTypeChip(
                    label: l10n.bus,
                    icon: Icons.directions_bus,
                    isSelected: _selectedType == TransportType.bus,
                    color: const Color(0xFFFF9800),
                    onTap: () => setState(() => _selectedType = TransportType.bus),
                  ),
                  _TransportTypeChip(
                    label: l10n.car,
                    icon: Icons.directions_car,
                    isSelected: _selectedType == TransportType.car,
                    color: const Color(0xFF9C27B0),
                    onTap: () => setState(() => _selectedType = TransportType.car),
                  ),
                  _TransportTypeChip(
                    label: l10n.taxi,
                    icon: Icons.local_taxi,
                    isSelected: _selectedType == TransportType.taxi,
                    color: const Color(0xFFF44336),
                    onTap: () => setState(() => _selectedType = TransportType.taxi),
                  ),
                ],
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.resultsFound(filteredOptions.length),
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              ),
            ),
          if (filteredOptions.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noResultsFound,
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.tryAdjustingSearch,
                      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
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
                          math.max(
                            0,
                            (_animationController.value - delay) / (1 - delay),
                          ),
                        );
                        return Opacity(
                          opacity: animationValue,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - animationValue)),
                            child: child,
                          ),
                        );
                      },
                      // ✅ Removed: isFavorite and onFavoriteToggle props
                      child: TransportCard(
                        option: option,
                        onTap: () => _showTransportDetails(option),
                      ),
                    );
                  },
                  childCount: filteredOptions.length,
                ),
              ),
            ),
          if (filteredOptions.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.travelTips,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) => TravelTipCard(tip: travelTips[index]),
                  childCount: travelTips.length,
                ),
              ),
            ),
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
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF2196F3), size: 32),
                    const SizedBox(height: 12),
                    Text(
                      l10n.needMoreHelp,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.contactTouristInfo,
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
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 3;
    if (width >= 600) return 2;
    return 1;
  }
}

// ============================================================================
// TRANSPORT CARD — Favorites removed
// ============================================================================

class TransportCard extends StatefulWidget {
  final TransportOption option;
  final VoidCallback onTap;

  const TransportCard({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  State<TransportCard> createState() => _TransportCardState();
}

class _TransportCardState extends State<TransportCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
              color: _isHovered
                  ? widget.option.color.withOpacity(0.5)
                  : widget.option.color.withOpacity(0.2),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: widget.option.color.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.option.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.option.icon, color: widget.option.color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.option.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.option.titleAr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.6),
                            fontFamily: 'Amiri',
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ Removed: favorite IconButton
                  Icon(Icons.arrow_forward_ios, color: widget.option.color, size: 20),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.option.description,
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
                    widget.option.rating.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${widget.option.reviewCount} ${l10n.reviews})',
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(
                    icon: Icons.access_time,
                    label: widget.option.duration,
                    color: widget.option.color,
                  ),
                  _InfoChip(
                    icon: Icons.payments,
                    label: widget.option.price,
                    color: widget.option.color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// MODAL WIDGETS
// ============================================================================

class PriceComparisonModal extends StatelessWidget {
  final List<TransportOption> options;

  const PriceComparisonModal({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.compare_arrows, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.priceComparison,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.comparingAllTransportOptions,
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2D2D2D).withOpacity(0.9),
                        const Color(0xFF1A1A1A).withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: option.color.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(option.icon, color: option.color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.white.withOpacity(0.6), size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${l10n.avgDuration}: ${option.duration}',
                                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.payments, color: option.color, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${l10n.avgPrice}: ${option.price}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: option.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: option.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              option.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

class AirportInfoModal extends StatelessWidget {
  final AirportInfo info;

  const AirportInfoModal({super.key, required this.info});

  Future<void> _openMaps() async {
    final uri = Uri.parse(info.mapUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.flight, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${info.name} (${info.code})',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              info.nameAr,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Amiri',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openMaps,
                    icon: const Icon(Icons.map),
                    label: Text(l10n.openInMaps),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _InfoRow(icon: Icons.location_on, label: l10n.location, value: info.location),
                const SizedBox(height: 16),
                _InfoRow(icon: Icons.straighten, label: l10n.distanceToMedina, value: info.distance),
                const SizedBox(height: 32),
                _SectionTitle(title: l10n.facilities, color: const Color(0xFF2196F3), icon: Icons.store),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: info.facilities
                      .map((facility) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 16),
                        const SizedBox(width: 8),
                        Text(facility, style: const TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 32),
                _SectionTitle(title: l10n.airlines, color: const Color(0xFF2196F3), icon: Icons.flight_takeoff),
                const SizedBox(height: 16),
                ...info.airlines.map((airline) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flight, color: Color(0xFF2196F3), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        airline,
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 32),
                _SectionTitle(title: l10n.groundTransportation, color: const Color(0xFF2196F3), icon: Icons.local_taxi),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
                  ),
                  child: Text(
                    info.transferInfo,
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), height: 1.6),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TravelTipCard extends StatelessWidget {
  final TravelTip tip;

  const TravelTipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tip.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tip.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(tip.icon, color: tip.color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            tip.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            tip.description,
            style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7), height: 1.5),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPER WIDGETS
// ============================================================================

class _TransportTypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _TransportTypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? const Color(0xFF2196F3);

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [chipColor, chipColor.withOpacity(0.7)])
                : null,
            color: isSelected ? null : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? chipColor : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;

  const _SectionTitle({required this.title, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2196F3), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SortOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF2196F3) : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF2196F3)) : null,
      onTap: onTap,
    );
  }
}

class TravelPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const spacing = 80.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final path = Path();
        path.moveTo(x - 20, y);
        path.quadraticBezierTo(x, y - 10, x + 20, y);
        canvas.drawPath(path, paint);
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}