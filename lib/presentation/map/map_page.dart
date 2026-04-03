import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin, pi;
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';
import '../home/historical_sites/pages/site_details_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  bool _isCalculatingRoute = false;
  Set<Polyline> _polylines = {};
  Set<Marker> _routeMarkers = {};
  RouteInfo? _currentRoute;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  bool _isSearchVisible = false;
  Timer? _debounceTimer;

  // ⚠️ ضع Google API Key هنا
  static const String _googleApiKey = 'YOUR_GOOGLE_API_KEY_HERE';

  // Filter and sort states
  PlaceCategory? _selectedCategory;
  List<PlaceInfo> _filteredPlaces = [];
  bool _showFilters = false;
  SortOption _selectedSort = SortOption.none;
  bool _showSortOptions = false;

  // Marker icon cache
  final Map<String, BitmapDescriptor> _markerIconCache = {};

  static const CameraPosition _kFesCenter = CameraPosition(
    target: LatLng(34.0331, -5.0003),
    zoom: 14.0,
  );

  Set<Marker> _markers = {};
  PlaceInfo? _selectedPlace;
  TravelMode _selectedTravelMode = TravelMode.walking;

  // Places data - will be populated with localized names
  List<PlaceInfo> _kPlaces = [];

  static const String _kDarkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#1a1a1a"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8a8a8a"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1a1a1a"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#757575"}]
  },
  {
    "featureType": "poi",
    "stylers": [{"visibility": "off"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#2c2c2c"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#9ca5b3"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#0d0d0d"}]
  }
]
''';

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializePlaces();
    _initializeMarkers();
    _getCurrentLocation();
  }

  void _initializePlaces() {
    final l10n = AppLocalizations.of(context)!;

    _kPlaces = [
      PlaceInfo(
        id: 'bab-boujloud',
        name: l10n.babBoujloudFull,
        category: PlaceCategory.landmark,
        latitude: 34.0640,
        longitude: -4.9760,
        imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/30/43/d8/c3/caption.jpg?w=1100&h=-1&s=1',
        rating: 9.4,
        reviews: 689,
        duration: l10n.duration30min,
        badge: '🚪',
        price: l10n.free,
        year: '1913',
        location: 'Medina, Fes',
        categoryName: 'Historic Gate',
      ),
      PlaceInfo(
        id: 'al-qarawiyyin-mosque',
        name: l10n.alQarawiyyinFull,
        category: PlaceCategory.religious,
        latitude: 34.0642,
        longitude: -4.9737,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/University_of_Al_Qaraouiyine.jpg/500px-University_of_Al_Qaraouiyine.jpg',
        rating: 9.8,
        reviews: 542,
        duration: l10n.duration2h,
        badge: '🕌',
        price: l10n.free,
        year: '859 AD',
        location: 'Fes el-Bali, Fes',
        categoryName: 'Mosque & University',
      ),
      PlaceInfo(
        id: 'chouara-tannery',
        name: l10n.chouaraTanneryFull,
        category: PlaceCategory.attraction,
        latitude: 34.0650,
        longitude: -4.9720,
        imageUrl: 'https://images.pexels.com/photos/11537244/pexels-photo-11537244.jpeg',
        rating: 8.8,
        reviews: 734,
        duration: l10n.duration1h,
        badge: '🎨',
        price: l10n.price20Mad,
        year: '11th Century',
        location: 'Chouara Quarter, Fes',
        categoryName: 'Traditional Craft',
      ),
      PlaceInfo(
        id: 'bou-inania-madrasa',
        name: l10n.bouInaniaMadrasa,
        category: PlaceCategory.museum,
        latitude: 34.0638,
        longitude: -4.9753,
        imageUrl: 'https://images.pexels.com/photos/30397288/pexels-photo-30397288.jpeg',
        rating: 9.5,
        reviews: 478,
        duration: l10n.duration1h30,
        badge: '🏛️',
        price: l10n.price20Mad,
        year: '1350',
        location: 'Talaa Kebira, Fes',
        categoryName: 'Madrasa',
      ),
      PlaceInfo(
        id: 'merenid-tombs',
        name: l10n.merenidTombs,
        category: PlaceCategory.attraction,
        latitude: 34.0710,
        longitude: -4.9780,
        imageUrl: 'https://gv-images.viamichelin.com/images/michelin_guide/max/Img_67356.jpg',
        rating: 9.4,
        reviews: 567,
        duration: l10n.duration1h30,
        badge: '🏛️',
        price: l10n.free,
        year: '1358',
        location: 'Northern Hills, Fes',
        categoryName: 'Historic Ruins',
      ),
      PlaceInfo(
        id: 'nejjarine-museum',
        name: l10n.nejjarineMuseum,
        category: PlaceCategory.museum,
        latitude: 34.0645,
        longitude: -4.9728,
        imageUrl: 'https://static.wixstatic.com/media/68ca6c_68273c95489a469b91e40d459432153f~mv2_d_1200_1800_s_2.jpg/v1/fill/w_980,h_1470,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/68ca6c_68273c95489a469b91e40d459432153f~mv2_d_1200_1800_s_2.jpg',
        rating: 9.0,
        reviews: 298,
        duration: l10n.duration1h30,
        badge: '🪵',
        price: l10n.price20Mad,
        year: '1711',
        location: 'Nejjarine Square, Fes',
        categoryName: 'Museum',
      ),
      PlaceInfo(
        id: 'dar-batha-museum',
        name: l10n.darBathaMuseum,
        category: PlaceCategory.museum,
        latitude: 34.0620,
        longitude: -4.9800,
        imageUrl: 'https://th.bing.com/th/id/R.b553c8b9b26f4d4fb2846a036dba4087?rik=ekcKfieqoUBt4g&riu=http%3a%2f%2fsimply-morocco.com%2fwp-content%2fuploads%2f2019%2f06%2fvisit-fes-Dar-Batha-Museum.jpg&ehk=nG0tk00PTqBkZFvuccrbe2HsnwOCj2e2Ca19VcMvEZ4%3d&risl=&pid=ImgRaw&r=0',
        rating: 8.9,
        reviews: 324,
        duration: l10n.duration2h,
        badge: '🏛️',
        price: l10n.price20Mad,
        year: '1897',
        location: 'Place de l\'Istiqlal, Fes',
        categoryName: 'Museum',
      ),
      PlaceInfo(
        id: 'attarine-madrasa',
        name: l10n.attarineMadrasa,
        category: PlaceCategory.museum,
        latitude: 34.0643,
        longitude: -4.9732,
        imageUrl: 'https://images.pexels.com/photos/19190380/pexels-photo-19190380.jpeg',
        rating: 9.3,
        reviews: 312,
        duration: l10n.duration1h,
        badge: '🏛️',
        price: l10n.price20Mad,
        year: '1325',
        location: 'Near Al-Qarawiyyin, Fes',
        categoryName: 'Madrasa',
      ),
      PlaceInfo(
        id: 'zawiya-moulay-idriss',
        name: l10n.zawiyaMoulayIdriss,
        category: PlaceCategory.religious,
        latitude: 34.0648,
        longitude: -4.9740,
        imageUrl: 'https://lh3.googleusercontent.com/gps-proxy/AHVAwepSFedwuQ1fXhjMZvDnU25BEFhh8X_LcXoSMOwnAVDLwftCcYuhqQaF3XjvkfufLuMZz99HFxHMeH-fk_C77Hko7TZqwTE4OJRDAEtl1onzQlNyRZrUKDlhu7e1tiqpKbB71Ari=s1360-w1360-h1020-rw',
        rating: 9.5,
        reviews: 367,
        duration: l10n.duration1h,
        badge: '⭐',
        price: l10n.free,
        year: '828 AD',
        location: 'Fes el-Bali, Fes',
        categoryName: 'Sacred Site',
      ),
      PlaceInfo(
        id: 'jnan-sbil-garden',
        name: l10n.jnanSbilGarden,
        category: PlaceCategory.park,
        latitude: 34.0590,
        longitude: -4.9830,
        imageUrl: 'https://lp-cms-production.imgix.net/features/2019/04/jnan-sbil-garden-fez-morocco-f61d8b95a52c.jpg?auto=format&fit=crop&sharp=10&vib=20&ixlib=react-8.6.4&w=850&q=20&dpr=5',
        rating: 8.5,
        reviews: 412,
        duration: l10n.duration1h,
        badge: '🌳',
        price: l10n.price10Mad,
        year: '1913',
        location: 'Bab Bou Jeloud, Fes',
        categoryName: 'Garden',
      ),
      PlaceInfo(
        id: 'zawiya-tijania',
        name: l10n.zawiyaTijania,
        category: PlaceCategory.religious,
        latitude: 34.0635,
        longitude: -4.9750,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Zaouiya_Tidjaniya_de_F%C3%A8s_-_grille.jpg/500px-Zaouiya_Tidjaniya_de_F%C3%A8s_-_grille.jpg',
        rating: 9.2,
        reviews: 245,
        duration: l10n.duration45min,
        badge: '⭐',
        price: l10n.free,
        year: '19th Century',
        location: 'Fes el-Bali, Fes',
        categoryName: 'Sacred Site',
      ),
      PlaceInfo(
        id: 'royal-palace',
        name: l10n.royalPalace,
        category: PlaceCategory.landmark,
        latitude: 34.0565,
        longitude: -4.9881,
        imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/4a/4b/5c/caption.jpg?w=1200&h=-1&s=1',
        rating: 9.1,
        reviews: 523,
        duration: l10n.duration45min,
        badge: '👑',
        price: l10n.free,
        year: '13th Century',
        location: 'Fes el-Jdid, Fes',
        categoryName: 'Royal Palace',
      ),
      PlaceInfo(
        id: 'andalusian-mosque',
        name: l10n.andalusianMosque,
        category: PlaceCategory.religious,
        latitude: 34.0655,
        longitude: -4.9715,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/Grande_Mosquee_des_Andalous_de_Fes.jpg/500px-Grande_Mosquee_des_Andalous_de_Fes.jpg',
        rating: 9.0,
        reviews: 287,
        duration: l10n.duration1h,
        badge: '🕌',
        price: l10n.free,
        year: '859 AD',
        location: 'Andalusian Quarter, Fes',
        categoryName: 'Mosque',
      ),
    ];

    _filteredPlaces = List.from(_kPlaces);
  }

  Future<void> _initializeMarkers() async {
    try {
      final markers = await Future.wait(_filteredPlaces.map((place) async {
        try {
          final icon = await _createCustomMarkerBitmap(
            place.category,
            place == _selectedPlace,
          );
          return Marker(
            markerId: MarkerId(place.id),
            position: LatLng(place.latitude, place.longitude),
            onTap: () => _onMarkerTapped(place),
            icon: icon,
            anchor: const Offset(0.5, 0.5),
          );
        } catch (e) {
          debugPrint('Error creating marker for ${place.name}: $e');
          return null;
        }
      }));

      if (mounted) {
        setState(() {
          _markers = markers.whereType<Marker>().toSet();
        });
      }
    } catch (e) {
      debugPrint('Error initializing markers: $e');
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerBitmap(
      PlaceCategory category,
      bool isSelected,
      ) async {
    final cacheKey = '${category.name}_$isSelected';

    if (_markerIconCache.containsKey(cacheKey)) {
      return _markerIconCache[cacheKey]!;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = isSelected ? 60.0 : 50.0;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(
      Offset(size / 2, size / 2 + 2),
      size / 2 - 2,
      shadowPaint,
    );

    final outerPaint = Paint()
      ..color = _getCategoryColor(category)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      outerPaint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = isSelected ? 4 : 3;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2 - 2,
      borderPaint,
    );

    final iconPainter = TextPainter(
      text: TextSpan(
        text: _getCategoryIcon(category),
        style: TextStyle(
          fontSize: isSelected ? 28 : 24,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        (size - iconPainter.width) / 2,
        (size - iconPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    final icon = BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
    _markerIconCache[cacheKey] = icon;
    return icon;
  }

  Color _getCategoryColor(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.museum:
        return const Color(0xFF9C27B0);
      case PlaceCategory.landmark:
        return const Color(0xFFFF6B35);
      case PlaceCategory.religious:
        return const Color(0xFF2196F3);
      case PlaceCategory.park:
        return const Color(0xFF4CAF50);
      case PlaceCategory.attraction:
        return const Color(0xFFE91E63);
    }
  }

  String _getCategoryIcon(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.museum:
        return '🏛️';
      case PlaceCategory.landmark:
        return '🚪';
      case PlaceCategory.religious:
        return '🕌';
      case PlaceCategory.park:
        return '🌳';
      case PlaceCategory.attraction:
        return '⭐';
    }
  }

  void _filterPlaces(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredPlaces = _kPlaces.where((place) {
            final matchesSearch = query.isEmpty ||
                place.name.toLowerCase().contains(query.toLowerCase());
            final matchesCategory = _selectedCategory == null ||
                place.category == _selectedCategory;
            return matchesSearch && matchesCategory;
          }).toList();
          _applySorting();
        });
        _initializeMarkers();
      }
    });
  }

  void _applySorting() {
    if (_selectedSort == SortOption.distance && _currentPosition != null) {
      _filteredPlaces.sort((a, b) {
        final distA = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          a.latitude,
          a.longitude,
        );
        final distB = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });
    } else if (_selectedSort == SortOption.rating) {
      _filteredPlaces.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  void _selectSort(SortOption sort) {
    setState(() {
      _selectedSort = sort;
      _showSortOptions = false;
      _applySorting();
    });
    _initializeMarkers();
  }

  void _shareLocation(PlaceInfo place) {
    final l10n = AppLocalizations.of(context)!;
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';

    final message = l10n.shareMessage(
      place.badge,
      place.name,
      place.rating.toString(),
      googleMapsUrl,
    );

    Share.share(
      message,
      subject: l10n.shareSubject(place.name),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
        _filterPlaces('');
      }
    });
  }

  void _selectCategory(PlaceCategory? category) {
    setState(() {
      _selectedCategory = category;
      _showFilters = false;
    });
    _filterPlaces(_searchController.text);
  }

  Future<void> _getCurrentLocation() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.locationServicesDisabled),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.locationPermissionDenied),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.locationPermissionPermanentlyDenied),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _updateMarkers();
          if (_selectedSort == SortOption.distance) {
            _filterPlaces(_searchController.text);
          }
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorGettingLocation}: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _updateMarkers() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentPosition == null) return;

    final userMarker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: l10n.yourLocation),
    );

    setState(() {
      _markers.add(userMarker);
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // ✅ الفونكشن المحسّنة - فتح الخريطة الخارجية
  Future<void> _openInExternalMaps(PlaceInfo place) async {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.lightImpact();

    try {
      // إذا الموقع ماكاينش، نطلبوه أولاً
      if (_currentPosition == null) {
        await _getCurrentLocation();
        // نستناو شوية باش الموقع يتحصّل
        await Future.delayed(const Duration(milliseconds: 500));
      }

      Uri uri;

      if (Platform.isIOS) {
        // Apple Maps على iOS
        if (_currentPosition != null) {
          // فتح مع directions (navigation)
          uri = Uri.parse(
              'maps://?saddr=${_currentPosition!.latitude},${_currentPosition!.longitude}'
                  '&daddr=${place.latitude},${place.longitude}'
                  '&dirflg=d'
          );
        } else {
          // فتح بلا directions
          uri = Uri.parse(
              'maps://?q=${Uri.encodeComponent(place.name)}'
                  '&ll=${place.latitude},${place.longitude}'
          );
        }
      } else {
        // Google Maps على Android
        if (_currentPosition != null) {
          // فتح مع directions (navigation)
          // استعمال google.navigation scheme للـ navigation المباشر
          uri = Uri.parse(
              'google.navigation:q=${place.latitude},${place.longitude}'
                  '&mode=d' // d = driving
          );
        } else {
          // فتح بلا directions - فقط نعرضو المكان
          uri = Uri.parse(
              'geo:${place.latitude},${place.longitude}?q=${place.latitude},${place.longitude}(${Uri.encodeComponent(place.name)})'
          );
        }
      }

      // محاولة فتح في تطبيق الخرائط
      bool launched = false;

      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        debugPrint('Failed with first URI scheme: $e');

        // إذا فشل، نجربو بـ HTTPS URL (fallback)
        if (Platform.isAndroid) {
          if (_currentPosition != null) {
            uri = Uri.parse(
                'https://www.google.com/maps/dir/?api=1'
                    '&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}'
                    '&destination=${place.latitude},${place.longitude}'
                    '&travelmode=driving'
            );
          } else {
            uri = Uri.parse(
                'https://www.google.com/maps/search/?api=1'
                    '&query=${place.latitude},${place.longitude}'
            );
          }
        } else {
          // iOS fallback
          if (_currentPosition != null) {
            uri = Uri.parse(
                'http://maps.apple.com/?saddr=${_currentPosition!.latitude},${_currentPosition!.longitude}'
                    '&daddr=${place.latitude},${place.longitude}'
                    '&dirflg=d'
            );
          } else {
            uri = Uri.parse(
                'http://maps.apple.com/?ll=${place.latitude},${place.longitude}'
                    '&q=${Uri.encodeComponent(place.name)}'
            );
          }
        }

        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }

      if (!launched && mounted) {
        throw Exception('Failed to launch maps application');
      }
    } catch (e) {
      debugPrint('Error opening maps: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('خطأ في فتح الخرائط. تأكد من تثبيت Google Maps أو Apple Maps.')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _drawRoute(PlaceInfo place) async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentPosition == null) {
      if (mounted) {
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.location_off, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.pleaseEnableLocation)),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B35),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() {
      _isCalculatingRoute = true;
      _polylines.clear();
      _routeMarkers.clear();
      _currentRoute = null;
    });

    try {
      final directionsData = await _getDirections(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        LatLng(place.latitude, place.longitude),
      );

      if (directionsData == null) {
        throw Exception('Failed to get directions');
      }

      final polyline = Polyline(
        polylineId: const PolylineId('route'),
        points: directionsData['points'],
        color: const Color(0xFFFF6B35),
        width: 6,
        patterns: [
          PatternItem.dash(20),
          PatternItem.gap(10),
        ],
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      );

      final startMarker = await _createRouteMarker(
        'route_start',
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        '🚀',
        'Start',
      );

      final endMarker = await _createRouteMarker(
        'route_end',
        LatLng(place.latitude, place.longitude),
        '🎯',
        place.name,
      );

      if (mounted) {
        setState(() {
          _polylines.add(polyline);
          _routeMarkers = {startMarker, endMarker};
          _currentRoute = RouteInfo(
            distance: directionsData['distance'],
            duration: directionsData['duration'],
            travelMode: _selectedTravelMode,
            steps: directionsData['steps'],
          );
          _isCalculatingRoute = false;
        });

        final bounds = _calculateBounds(directionsData['points']);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );

        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      debugPrint('Error drawing route: $e');
      if (mounted) {
        setState(() => _isCalculatingRoute = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorCalculatingRoute}: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _getDirections(LatLng origin, LatLng destination) async {
    final travelModeStr = _getTravelModeString(_selectedTravelMode);

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
            'origin=${origin.latitude},${origin.longitude}&'
            'destination=${destination.latitude},${destination.longitude}&'
            'mode=$travelModeStr&'
            'key=$_googleApiKey'
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          final points = _decodePolyline(route['overview_polyline']['points']);

          final steps = <RouteStep>[];
          for (var step in leg['steps']) {
            final instruction = _cleanHtmlTags(step['html_instructions']);
            final distance = (step['distance']['value'] / 1000.0);
            final position = LatLng(
              step['start_location']['lat'],
              step['start_location']['lng'],
            );

            steps.add(RouteStep(
              instruction: instruction,
              distance: distance,
              position: position,
            ));
          }

          return {
            'points': points,
            'distance': leg['distance']['value'] / 1000.0,
            'duration': (leg['duration']['value'] / 60.0).round(),
            'steps': steps,
          };
        } else {
          debugPrint('Directions API error: ${data['status']}');
          return null;
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception in getDirections: $e');
      return null;
    }
  }

  String _getTravelModeString(TravelMode mode) {
    switch (mode) {
      case TravelMode.walking:
        return 'walking';
      case TravelMode.driving:
        return 'driving';
      case TravelMode.bicycling:
        return 'bicycling';
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  String _cleanHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>');
    return htmlString
        .replaceAll(regex, '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .trim();
  }

  Future<Marker> _createRouteMarker(
      String id,
      LatLng position,
      String emoji,
      String title,
      ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 80.0;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(size / 2, size / 2 + 3), size / 2 - 5, shadowPaint);

    final outerPaint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 2, outerPaint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2 - 4, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(fontSize: 36),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List()),
      anchor: const Offset(0.5, 0.5),
      infoWindow: InfoWindow(title: title),
    );
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _clearRoute() {
    HapticFeedback.lightImpact();
    setState(() {
      _polylines.clear();
      _routeMarkers.clear();
      _currentRoute = null;
    });
  }

  void _onMarkerTapped(PlaceInfo place) {
    HapticFeedback.lightImpact();
    setState(() => _selectedPlace = place);
    _initializeMarkers();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showPlaceBottomSheet();
      }
    });
  }

  void _showPlaceBottomSheet() {
    if (_selectedPlace == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PlaceBottomSheet(
        place: _selectedPlace!,
        currentPosition: _currentPosition,
        currentRoute: _currentRoute,
        selectedTravelMode: _selectedTravelMode,
        isCalculating: _isCalculatingRoute,
        onViewDetails: () {
          Navigator.pop(context);
          _navigateToDetails(_selectedPlace!);
        },
        onGetDirections: () {
          Navigator.pop(context);
          _drawRoute(_selectedPlace!);
        },
        onTravelModeChanged: (mode) {
          setState(() => _selectedTravelMode = mode);
          if (_currentRoute != null && _selectedPlace != null) {
            _drawRoute(_selectedPlace!);
          }
        },
        onClearRoute: _clearRoute,
        onShare: () {
          _shareLocation(_selectedPlace!);
        },
        onViewSteps: () {
          Navigator.pop(context);
          if (_currentRoute != null && _currentRoute!.steps.isNotEmpty) {
            _showRouteStepsSheet();
          }
        },
        onOpenInExternalMaps: () {
          Navigator.pop(context);
          _openInExternalMaps(_selectedPlace!);
        },
      ),
    ).then((_) {
      setState(() => _selectedPlace = null);
      _initializeMarkers();
    });
  }

  void _showRouteStepsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _RouteStepsSheet(
        route: _currentRoute!,
        place: _selectedPlace!,
      ),
    );
  }

  void _navigateToDetails(PlaceInfo place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteDetailsPage(
          id: place.id,
          title: place.name,
          imageUrl: place.imageUrl,
          rating: place.rating,
          reviews: place.reviews,
          duration: place.duration,
          price: place.price,
          year: place.year,
          badge: place.badge,
          location: place.location,
          category: place.categoryName,
        ),
      ),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    try {
      await controller.setMapStyle(_kDarkMapStyle);
    } catch (e) {
      debugPrint('Failed to set map style: $e');
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _markers.clear();
    _polylines.clear();
    _routeMarkers.clear();
    _markerIconCache.clear();
    _mapController?.dispose();
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          RepaintBoundary(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kFesCenter,
              markers: {..._markers, ..._routeMarkers},
              polylines: _polylines,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(12.0, 18.0),
            ),
          ),

          // App Bar with Search
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (!_isSearchVisible) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.map_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.exploreFes,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                        if (_isSearchVisible)
                          Expanded(
                            child: FadeTransition(
                              opacity: _searchAnimation,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: l10n.searchPlaces,
                                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),
                                  onChanged: _filterPlaces,
                                ),
                              ),
                            ),
                          ),
                        IconButton(
                          onPressed: _toggleSearch,
                          icon: Icon(
                            _isSearchVisible ? Icons.close : Icons.search,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() => _showSortOptions = !_showSortOptions);
                              },
                              icon: const Icon(
                                Icons.sort,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A1A),
                              ),
                            ),
                            if (_selectedSort != SortOption.none)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B35),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() => _showFilters = !_showFilters);
                              },
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A1A),
                              ),
                            ),
                            if (_selectedCategory != null)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B35),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    // Sort Options
                    if (_showSortOptions)
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _SortChip(
                                label: l10n.sortDefault,
                                icon: Icons.clear_all,
                                isSelected: _selectedSort == SortOption.none,
                                onTap: () => _selectSort(SortOption.none),
                              ),
                              const SizedBox(width: 8),
                              _SortChip(
                                label: l10n.sortDistance,
                                icon: Icons.near_me,
                                isSelected: _selectedSort == SortOption.distance,
                                onTap: () => _selectSort(SortOption.distance),
                                isDisabled: _currentPosition == null,
                              ),
                              const SizedBox(width: 8),
                              _SortChip(
                                label: l10n.sortRating,
                                icon: Icons.star,
                                isSelected: _selectedSort == SortOption.rating,
                                onTap: () => _selectSort(SortOption.rating),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Filter Chips
                    if (_showFilters)
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _FilterChip(
                                label: l10n.allSites,
                                icon: Icons.grid_view,
                                isSelected: _selectedCategory == null,
                                onTap: () => _selectCategory(null),
                              ),
                              const SizedBox(width: 8),
                              ...PlaceCategory.values.map((category) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _FilterChip(
                                    label: _getCategoryLabel(category, l10n),
                                    icon: _getCategoryIconData(category),
                                    color: _getCategoryColor(category),
                                    isSelected: _selectedCategory == category,
                                    onTap: () => _selectCategory(category),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Results Count
          if (_isSearchVisible || _selectedCategory != null || _selectedSort != SortOption.none)
            Positioned(
              top: _showFilters || _showSortOptions ? 180 : 90,
              left: 16,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.placesCount(_filteredPlaces.length.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_selectedSort != SortOption.none) ...[
                        const SizedBox(width: 6),
                        Text(
                          '• ${_selectedSort == SortOption.distance ? '📍' : '⭐'}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // My Location Button
          Positioned(
            right: 16,
            bottom: _currentRoute != null ? 200 : 100,
            child: FloatingActionButton(
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              backgroundColor: const Color(0xFF1A1A1A),
              child: _isLoadingLocation
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFF6B35),
                ),
              )
                  : const Icon(
                Icons.my_location,
                color: Color(0xFFFF6B35),
              ),
            ),
          ),

          // Route Info Card
          if (_currentRoute != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: _RouteInfoCard(
                route: _currentRoute!,
                onClear: _clearRoute,
                onViewSteps: _showRouteStepsSheet,
              ),
            ),
        ],
      ),
    );
  }

  String _getCategoryLabel(PlaceCategory category, AppLocalizations l10n) {
    switch (category) {
      case PlaceCategory.museum:
        return l10n.museums;
      case PlaceCategory.landmark:
        return l10n.filterLandmarks;
      case PlaceCategory.religious:
        return l10n.filterReligious;
      case PlaceCategory.park:
        return l10n.filterParks;
      case PlaceCategory.attraction:
        return l10n.filterAttractions;
    }
  }

  IconData _getCategoryIconData(PlaceCategory category) {
    switch (category) {
      case PlaceCategory.museum:
        return Icons.museum;
      case PlaceCategory.landmark:
        return Icons.location_city;
      case PlaceCategory.religious:
        return Icons.mosque;
      case PlaceCategory.park:
        return Icons.park;
      case PlaceCategory.attraction:
        return Icons.place;
    }
  }
}

// ============================================================================
// WIDGETS
// ============================================================================

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDisabled;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color(0xFF1A1A1A).withOpacity(0.5)
              : isSelected
              ? const Color(0xFFFF6B35)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDisabled
                ? const Color(0xFF424242).withOpacity(0.5)
                : isSelected
                ? const Color(0xFFFF6B35)
                : const Color(0xFF424242),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isDisabled
                  ? const Color(0xFF9E9E9E).withOpacity(0.5)
                  : isSelected
                  ? Colors.white
                  : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? const Color(0xFF9E9E9E).withOpacity(0.5)
                    : isSelected
                    ? Colors.white
                    : const Color(0xFF9E9E9E),
              ),
            ),
            if (isDisabled)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.location_off,
                  size: 14,
                  color: Color(0xFF9E9E9E),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? const Color(0xFFFF6B35))
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? const Color(0xFFFF6B35))
                : const Color(0xFF424242),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInfoCard extends StatelessWidget {
  final RouteInfo route;
  final VoidCallback onClear;
  final VoidCallback onViewSteps;

  const _RouteInfoCard({
    required this.route,
    required this.onClear,
    required this.onViewSteps,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTravelModeIcon(route.travelMode),
                  color: const Color(0xFFFF6B35),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${route.distance.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.routeSummary(
                        route.duration.toString(),
                        route.steps.length.toString(),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClear,
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
          if (route.steps.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onViewSteps,
                icon: const Icon(Icons.list_alt, size: 20),
                label: Text(l10n.viewDirections),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTravelModeIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.walking:
        return Icons.directions_walk;
      case TravelMode.driving:
        return Icons.directions_car;
      case TravelMode.bicycling:
        return Icons.directions_bike;
    }
  }
}

class _RouteStepsSheet extends StatelessWidget {
  final RouteInfo route;
  final PlaceInfo place;

  const _RouteStepsSheet({
    required this.route,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF424242),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.directions,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        l10n.directionTo(place.name),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _RouteStat(
                    icon: Icons.straighten,
                    label: l10n.statDistance,
                    value: '${route.distance.toStringAsFixed(1)} km',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFF424242),
                  ),
                  _RouteStat(
                    icon: Icons.access_time,
                    label: l10n.duration,
                    value: '${route.duration} min',
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFF424242),
                  ),
                  _RouteStat(
                    icon: Icons.list_alt,
                    label: l10n.statSteps,
                    value: '${route.steps.length}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: route.steps.length,
                itemBuilder: (context, index) {
                  final step = route.steps[index];
                  final isLast = index == route.steps.length - 1;

                  return _StepItem(
                    step: step,
                    index: index + 1,
                    isLast: isLast,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RouteStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFFF6B35), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final RouteStep step;
  final int index;
  final bool isLast;

  const _StepItem({
    required this.step,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLast
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLast
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFF424242),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                isLast ? '🎯' : '$index',
                style: TextStyle(
                  fontSize: isLast ? 20 : 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLast
                    ? const Color(0xFFFF6B35).withOpacity(0.1)
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLast
                      ? const Color(0xFFFF6B35).withOpacity(0.3)
                      : const Color(0xFF424242),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.instruction,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isLast
                          ? const Color(0xFFFF6B35)
                          : Colors.white,
                    ),
                  ),
                  if (step.distance > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.straighten,
                          size: 14,
                          color: Color(0xFF9E9E9E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(step.distance * 1000).toStringAsFixed(0)} m',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceBottomSheet extends StatelessWidget {
  final PlaceInfo place;
  final Position? currentPosition;
  final RouteInfo? currentRoute;
  final TravelMode selectedTravelMode;
  final bool isCalculating;
  final VoidCallback onViewDetails;
  final VoidCallback onGetDirections;
  final Function(TravelMode) onTravelModeChanged;
  final VoidCallback onClearRoute;
  final VoidCallback onShare;
  final VoidCallback onViewSteps;
  final VoidCallback onOpenInExternalMaps;

  const _PlaceBottomSheet({
    required this.place,
    required this.currentPosition,
    required this.currentRoute,
    required this.selectedTravelMode,
    required this.isCalculating,
    required this.onViewDetails,
    required this.onGetDirections,
    required this.onTravelModeChanged,
    required this.onClearRoute,
    required this.onShare,
    required this.onViewSteps,
    required this.onOpenInExternalMaps,
  });

  double _calculateDistance() {
    if (currentPosition == null) return 0;

    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((place.latitude - currentPosition!.latitude) * p) / 2 +
        cos(currentPosition!.latitude * p) *
            cos(place.latitude * p) *
            (1 - cos((place.longitude - currentPosition!.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final distance = currentPosition != null ? _calculateDistance() : null;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      place.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 180,
                          color: const Color(0xFF2A2A2A),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFFFF6B35),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onShare();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    place.badge,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.reviewsCount(place.reviews.toString()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (distance != null) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFFF6B35),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _QuickInfo(
                    icon: Icons.access_time_rounded,
                    text: place.duration,
                  ),
                  const SizedBox(width: 16),
                  _QuickInfo(
                    icon: Icons.calendar_today_rounded,
                    text: place.year,
                  ),
                  const Spacer(),
                  Text(
                    place.price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ زر Directions - يفتح Google Maps / Apple Maps مباشرة
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onOpenInExternalMaps,
                  icon: const Icon(Icons.navigation, size: 22),
                  label: const Text(
                    'Directions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // زر Details
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(
                    Icons.info_outline,
                    size: 20,
                  ),
                  label: Text(
                    l10n.details,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2A2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TravelModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFF424242),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _QuickInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF9E9E9E),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

enum PlaceCategory {
  museum,
  landmark,
  religious,
  park,
  attraction,
}

enum TravelMode {
  walking,
  driving,
  bicycling,
}

enum SortOption {
  none,
  distance,
  rating,
}

class PlaceInfo {
  final String id;
  final String name;
  final PlaceCategory category;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String duration;
  final String badge;
  final String price;
  final String year;
  final String location;
  final String categoryName;

  const PlaceInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.badge,
    required this.price,
    required this.year,
    required this.location,
    required this.categoryName,
  });
}

class RouteInfo {
  final double distance;
  final int duration;
  final TravelMode travelMode;
  final List<RouteStep> steps;

  const RouteInfo({
    required this.distance,
    required this.duration,
    required this.travelMode,
    required this.steps,
  });
}

class RouteStep {
  final String instruction;
  final double distance;
  final LatLng position;

  const RouteStep({
    required this.instruction,
    required this.distance,
    required this.position,
  });
}