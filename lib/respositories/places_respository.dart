// ============================================================================
// IMPORTS
// ============================================================================

import 'package:flutter/material.dart';
// ============================================================================
// DOMAIN MODELS - Place Categories and Price Info
// ============================================================================

enum PlaceCategory {
  cultural,
  historical,
  religious,
  museum,
  nature,
}

class PriceInfo {
  final bool isFree;
  final double price;

  const PriceInfo.free()
      : isFree = true,
        price = 0.0;

  const PriceInfo.paid({required this.price}) : isFree = false;
}

// ============================================================================
// PLACE DATA MODEL
// ============================================================================

class PlaceData {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final String description;
  final String openingHours;
  final List<String> galleryImages;
  final PlaceCategory category;
  final String visitDuration;
  final PriceInfo priceInfo;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? phoneNumber;
  final List<String> highlights;
  final List<String> tips;
  final bool isOpenNow;
  final double distanceKm;

  const PlaceData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.location = 'Fez, Morocco',
    this.rating = 4.8,
    this.reviewCount = 2345,
    this.description = '',
    this.openingHours = 'Mon - Sat: 8:00 AM - 6:00 PM\nSunday: 9:00 AM - 5:00 PM',
    this.galleryImages = const [],
    this.category = PlaceCategory.cultural,
    this.visitDuration = '1-2 hours',
    this.priceInfo = const PriceInfo.free(),
    this.latitude,
    this.longitude,
    this.address,
    this.phoneNumber,
    this.highlights = const [],
    this.tips = const [],
    this.isOpenNow = true,
    this.distanceKm = 0.0,
  });
}

// ============================================================================
// SECTION MODELS
// ============================================================================

class PlaceDisplayConfig {
  final String? titleOverride;
  final String? subtitleOverride;
  final String? imageOverride;

  const PlaceDisplayConfig({
    this.titleOverride,
    this.subtitleOverride,
    this.imageOverride,
  });
}

class SectionItem {
  final PlaceData place;
  final PlaceDisplayConfig? config;

  const SectionItem(this.place, [this.config]);

  String get displayTitle => config?.titleOverride ?? place.title;
  String get displaySubtitle => config?.subtitleOverride ?? place.subtitle;
  String get displayImage => config?.imageOverride ?? place.imageUrl;
  String get id => place.id;
  String get location => place.location;
  double get rating => place.rating;
  int get reviewCount => place.reviewCount;
  String get description => place.description;
  String get openingHours => place.openingHours;
  List<String> get galleryImages => place.galleryImages;
  bool get isOpenNow => place.isOpenNow;
  double get distanceKm => place.distanceKm;
}

class SectionConfig {
  final String id;
  final String title;
  final String subtitle;
  final List<String> placeIds;
  final Map<String, PlaceDisplayConfig> customConfigs;

  const SectionConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.placeIds,
    this.customConfigs = const {},
  });
}

// ============================================================================
// PLACES REPOSITORY - SINGLETON
// ============================================================================

class PlacesRepository {
  static final PlacesRepository instance = PlacesRepository._();
  PlacesRepository._();

  // ============================================================================
  // REPOSITORY METHODS
  // ============================================================================

  /// Get places for a specific section
  List<SectionItem> getPlacesForSection(String sectionId) {
    final section = _sections[sectionId];
    if (section == null) return [];
    return section.placeIds
        .map((id) => _places[id])
        .whereType<PlaceData>()
        .map((place) => SectionItem(place, section.customConfigs[place.id]))
        .toList();
  }

  /// Get section configuration by ID
  SectionConfig? getSectionConfig(String sectionId) => _sections[sectionId];

  /// Get all places
  List<PlaceData> getAllPlaces() => _places.values.toList();

  /// Get a specific place by ID
  PlaceData? getPlaceById(String id) => _places[id];

  /// Search places by query
  List<PlaceData> searchPlaces(String query) {
    if (query.isEmpty) return getAllPlaces();
    final lowerQuery = query.toLowerCase();
    return _places.values.where((place) {
      return place.title.toLowerCase().contains(lowerQuery) ||
          place.subtitle.toLowerCase().contains(lowerQuery) ||
          place.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter places based on various criteria
  List<PlaceData> filterPlaces({
    bool? freeOnly,
    bool? openNow,
    double? maxDistance,
    double? minRating,
  }) {
    return _places.values.where((place) {
      if (freeOnly == true && place.priceInfo.isFree == false) return false;
      if (openNow == true && place.isOpenNow == false) return false;
      if (maxDistance != null && place.distanceKm > maxDistance) return false;
      if (minRating != null && place.rating < minRating) return false;
      return true;
    }).toList();
  }

  /// Get place recommendations based on a place ID
  List<PlaceData> getRecommendations(String basedOnId) {
    final basePlace = _places[basedOnId];
    if (basePlace == null) return [];

    return _places.values
        .where((p) => p.id != basedOnId && p.category == basePlace.category)
        .take(3)
        .toList();
  }

  /// Get places by category
  List<PlaceData> getPlacesByCategory(PlaceCategory category) {
    return _places.values
        .where((place) => place.category == category)
        .toList();
  }

  /// Get free places only
  List<PlaceData> getFreePlaces() {
    return _places.values
        .where((place) => place.priceInfo.isFree)
        .toList();
  }

  /// Get currently open places
  List<PlaceData> getOpenPlaces() {
    return _places.values
        .where((place) => place.isOpenNow)
        .toList();
  }

  /// Get nearby places (within distance)
  List<PlaceData> getNearbyPlaces(double maxDistanceKm) {
    return _places.values
        .where((place) => place.distanceKm <= maxDistanceKm)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  /// Get top rated places
  List<PlaceData> getTopRatedPlaces({int limit = 10}) {
    final sortedPlaces = _places.values.toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sortedPlaces.take(limit).toList();
  }

  /// Get places sorted by review count
  List<PlaceData> getMostReviewedPlaces({int limit = 10}) {
    final sortedPlaces = _places.values.toList()
      ..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    return sortedPlaces.take(limit).toList();
  }
}
// ALL PLACES DATA
// ============================================================================

final Map<String, PlaceData> _places = {
  'bab_boujloud': PlaceData(
    id: 'bab_boujloud',
    title: 'Bab Boujloud',
    subtitle: 'The Blue Gate',
    imageUrl: 'https://i.pinimg.com/736x/ce/06/70/ce067028079b46fd27911437c5d5d728.jpg',
    description: 'The iconic Blue Gate is the main entrance to Fez el-Bali, the old medina. Built in 1913, this magnificent gate features intricate Islamic tilework in blue and green.',
    category: PlaceCategory.historical,
    visitDuration: '30 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0638,
    longitude: -4.9770,
    isOpenNow: true,
    distanceKm: 2.5,
    highlights: [
      'Stunning blue and green tilework',
      'Main entrance to the medina',
      'Perfect photo opportunity',
      'Historic architecture from 1913'
    ],
    tips: [
      'Visit early morning for best photos',
      'Great starting point for medina tours',
      'Watch out for friendly local guides'
    ],
    galleryImages: [
      'https://images.pexels.com/photos/33514523/pexels-photo-33514523.jpeg',
      'https://images.pexels.com/photos/30279399/pexels-photo-30279399.jpeg',
      'https://images.pexels.com/photos/29594127/pexels-photo-29594127.jpeg',
    ],
  ),
  'al_qarawiyyin': PlaceData(
    id: 'al_qarawiyyin',
    title: 'Al-Qarawiyyin',
    subtitle: 'Ancient University',
    imageUrl: 'https://i.pinimg.com/1200x/29/4d/c7/294dc7ce9f96b58ebe8d46335631c89e.jpg',
    description: 'Founded in 859 AD by Fatima al-Fihri, Al-Qarawiyyin is recognized by UNESCO and Guinness World Records as the oldest continually operating educational institution in the world.',
    category: PlaceCategory.religious,
    visitDuration: '1 hour',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0645,
    longitude: -4.9759,
    isOpenNow: true,
    distanceKm: 3.1,
    highlights: [
      'Oldest university in the world (859 AD)',
      'UNESCO World Heritage Site',
      'Magnificent Islamic architecture',
      'Historic library with rare manuscripts'
    ],
    tips: [
      'Non-Muslims can visit courtyard',
      'Dress modestly',
      'Best visited with a guide',
      'Photography restricted in some areas'
    ],
    galleryImages: [
      'https://images.pexels.com/photos/30159106/pexels-photo-30159106.jpeg',
      'https://images.pexels.com/photos/17454026/pexels-photo-17454026.jpeg',
      'https://images.pexels.com/photos/35070809/pexels-photo-35070809.jpeg',
      'https://tse4.mm.bing.net/th/id/OIP.MhncBMhAt92bjy4blHc-JQHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
    ],
  ),
  'chouara_tannery': PlaceData(
    id: 'chouara_tannery',
    title: 'Chouara Tannery',
    subtitle: 'Traditional Leather',
    imageUrl: 'https://i.pinimg.com/1200x/a5/6a/86/a56a86ba2005e61425393694165b5478.jpg',
    description: 'The Chouara Tannery is one of the oldest tanneries in the world. Ancient leather-making processes unchanged for centuries create a mesmerizing sight with colorful dye vats.',
    category: PlaceCategory.cultural,
    visitDuration: '45 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0655,
    longitude: -4.9745,
    isOpenNow: true,
    distanceKm: 1.8,
    highlights: [
      'Centuries-old leather production',
      'Colorful dye vats',
      'Traditional craftsmanship',
      'Authentic cultural experience'
    ],
    tips: [
      'Strong smell - mint leaves offered',
      'Best view from surrounding shops',
      'Morning visits recommended',
      'Bargain for leather goods'
    ],
    galleryImages: [
      'https://i.pinimg.com/1200x/a5/6a/86/a56a86ba2005e61425393694165b5478.jpg',
      'https://images.pexels.com/photos/11537244/pexels-photo-11537244.jpeg',
    ],
  ),
  'jnan_sbil': PlaceData(
    id: 'jnan_sbil',
    title: 'Jnan Sbil Gardens',
    subtitle: 'Royal Botanical Gardens',
    imageUrl: 'https://i.pinimg.com/1200x/e7/8a/1d/e78a1d897770f9424e40b73df0773b35.jpg',
    description: 'Beautiful royal gardens offering a peaceful escape from the bustling medina. Features exotic plants, fountains, and traditional Moroccan landscaping.',
    category: PlaceCategory.nature,
    visitDuration: '1-2 hours',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0595,
    longitude: -4.9803,
    isOpenNow: true,
    distanceKm: 4.2,
    highlights: [
      'Historic royal gardens',
      'Exotic plant species',
      'Traditional fountains',
      'Peaceful atmosphere'
    ],
    tips: [
      'Perfect for relaxation',
      'Bring camera for nature photos',
      'Shaded areas for hot days',
      'Small entrance fee'
    ],
    galleryImages: [
      'https://i.pinimg.com/1200x/e7/8a/1d/e78a1d897770f9424e40b73df0773b35.jpg',
      'https://thumbs.dreamstime.com/b/fez-morocco-jan-jardin-jnan-sbil-royal-garden-gardens-jinan-was-founded-th-century-sultan-moulay-abdellah-jardin-jnan-101768884.jpg',
      'https://jardinessinfronteras.com/wp-content/uploads/2021/02/jnane-sbil-2.jpg',
      'https://thumbs.dreamstime.com/b/jardin-jnan-sbil-royal-garden-fes-morroco-jardin-jnan-sbil-royal-garden-sunset-gardens-jinan-was-founded-th-century-101741009.jpg',
    ],
  ),
  'nejjarine': PlaceData(
    id: 'nejjarine',
    title: 'Nejjarine Museum',
    subtitle: 'Woodworking Heritage',
    imageUrl: 'https://i.pinimg.com/736x/76/70/10/7670101abcad8273199e1dcf71da0acc.jpg',
    description: 'Showcases the rich tradition of woodworking in Morocco. Housed in a beautifully restored funduq (caravanserai) with intricate cedar carvings.',
    category: PlaceCategory.museum,
    visitDuration: '1 hour',
    priceInfo: const PriceInfo.paid(price: 30),
    latitude: 34.0640,
    longitude: -4.9755,
    isOpenNow: false,
    distanceKm: 2.9,
    highlights: [
      'Traditional woodworking tools',
      'Historic caravanserai building',
      'Intricate cedar carvings',
      'Moroccan craftsmanship history'
    ],
    tips: [
      'Check opening hours',
      'Photography allowed',
      'Rooftop terrace with views',
      'Cool interior in summer'
    ],
    galleryImages: [
      'https://i.pinimg.com/736x/76/70/10/7670101abcad8273199e1dcf71da0acc.jpg',
      'https://www.infinite-morocco.com/wp-content/uploads/2024/02/Nejjarine-Museum.jpg',
      'https://images.pexels.com/photos/15511991/pexels-photo-15511991.jpeg',
      'https://www.infinite-morocco.com/wp-content/uploads/2024/02/Nejjarine-Museum-2.jpg',
    ],
  ),
  'moulay_idriss': PlaceData(
    id: 'moulay_idriss',
    title: 'Mausoleum Moulay Idriss II',
    subtitle: 'Sacred Shrine',
    imageUrl: 'https://mobile.ledesk.ma/wp-content/uploads/2024/12/15.jpg',
    description: 'The shrine of Moulay Idriss II, founder of Fez and descendant of Prophet Muhammad. One of the most important religious sites in Morocco.',
    category: PlaceCategory.religious,
    visitDuration: '30 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0642,
    longitude: -4.9762,
    isOpenNow: true,
    distanceKm: 3.5,
    highlights: [
      'Sacred pilgrimage site',
      'Beautiful Islamic architecture',
      'Historic significance',
      'Peaceful atmosphere'
    ],
    tips: [
      'Muslims only inside',
      'Dress modestly',
      'Respectful behavior required',
      'Visit outer courtyard'
    ],
    galleryImages: [
      'https://mobile.ledesk.ma/wp-content/uploads/2024/12/15.jpg',
    ],
  ),
  'bou_inania': PlaceData(
    id: 'bou_inania',
    title: 'Bou Inania Madrasa',
    subtitle: 'Architectural Masterpiece',
    imageUrl: 'https://images.pexels.com/photos/30397288/pexels-photo-30397288.jpeg',
    description: 'Built between 1350-1355, this is the finest example of Marinid architecture in Morocco. Features stunning zellige tilework, carved cedar, and marble.',
    category: PlaceCategory.historical,
    visitDuration: '45 minutes',
    priceInfo: const PriceInfo.paid(price: 60),
    latitude: 34.0641,
    longitude: -4.9758,
    rating: 4.7,
    reviewCount: 1876,
    isOpenNow: true,
    distanceKm: 2.3,
    highlights: [
      'Marinid architecture masterpiece',
      'Intricate zellige tilework',
      'Carved cedar details',
      'Water clock mechanism'
    ],
    tips: [
      'Worth the entrance fee',
      'Photography allowed',
      'Visit in morning for best light',
      'Guided tours available'
    ],
    galleryImages: [
      'https://images.pexels.com/photos/30397278/pexels-photo-30397278.jpeg',
      'https://images.pexels.com/photos/30397290/pexels-photo-30397290.jpeg',
    ],
  ),
  'dar_batha': PlaceData(
    id: 'dar_batha',
    title: 'Dar Batha Museum',
    subtitle: 'Arts & Traditions',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/ff/Batha_Museum_%284317468784%29.jpg',
    description: '19th-century Hispano-Moorish summer palace showcasing traditional Moroccan arts, ceramics, embroidery, and carpets.',
    category: PlaceCategory.museum,
    visitDuration: '1-2 hours',
    priceInfo: const PriceInfo.paid(price: 20),
    latitude: 34.0633,
    longitude: -4.9789,
    rating: 4.6,
    reviewCount: 1542,
    isOpenNow: true,
    distanceKm: 3.7,
    highlights: [
      'Moroccan traditional arts',
      'Beautiful palace architecture',
      'Ceramic collections',
      'Andalusian gardens'
    ],
    tips: [
      'Air-conditioned rooms',
      'Peaceful gardens',
      'Photography permitted',
      'English descriptions available'
    ],
    galleryImages: [
      'https://upload.wikimedia.org/wikipedia/commons/f/ff/Batha_Museum_%284317468784%29.jpg',
      'https://www.fez-guide.com/wp-content/uploads/2014/03/Dar-Batha-Museum-fes-medina-fez-Morocco-823x420.jpg',
      'https://tse3.mm.bing.net/th/id/OIP.5yGsrDJ6xpqxTogxNDLT3QHaE9?rs=1&pid=ImgDetMain&o=7&rm=3',
    ],
  ),
  'merenid_tombs': PlaceData(
    id: 'merenid_tombs',
    title: 'Merenid Tombs',
    subtitle: 'Panoramic Viewpoint',
    imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/6f/15/c0/the-old-architecture.jpg?w=1200&h=1200&s=1',
    description: 'Breathtaking panoramic views of the entire medina from these 14th-century hillside ruins. Best spot for sunset views over Fez.',
    category: PlaceCategory.historical,
    visitDuration: '30-45 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0715,
    longitude: -4.9738,
    rating: 4.9,
    reviewCount: 2103,
    isOpenNow: true,
    distanceKm: 5.1,
    highlights: [
      'Best panoramic views of Fez',
      'Sunset photography spot',
      '14th-century ruins',
      'Free entrance'
    ],
    tips: [
      'Best at sunset',
      'Bring camera',
      'Taxi recommended',
      'Watch belongings'
    ],
    galleryImages: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/6f/15/c0/the-old-architecture.jpg?w=1200&h=1200&s=1',
      'https://images.pexels.com/photos/6545520/pexels-photo-6545520.jpeg',
      'https://images.pexels.com/photos/6545521/pexels-photo-6545521.jpeg',
    ],
  ),
  'attarine_madrasa': PlaceData(
    id: 'attarine_madrasa',
    title: 'Attarine Madrasa',
    subtitle: 'Pearl of Islamic Art',
    imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/8b/2e/6c/caption.jpg',
    description: 'Built in 1323, this stunning madrasa is considered one of the finest examples of Marinid architecture with exquisite zellige and carved cedar.',
    category: PlaceCategory.historical,
    visitDuration: '40 minutes',
    priceInfo: const PriceInfo.paid(price: 20),
    latitude: 34.0648,
    longitude: -4.9753,
    rating: 4.8,
    reviewCount: 1234,
    isOpenNow: true,
    distanceKm: 2.7,
    highlights: [
      'Stunning tilework and carvings',
      'Marinid architecture',
      'Peaceful courtyard',
      'Historic student cells'
    ],
    tips: [
      'Less crowded than Bou Inania',
      'Photography allowed',
      'Combined ticket available',
      'Near spice market'
    ],
    galleryImages: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/8b/2e/6c/caption.jpg',
      'https://images.pexels.com/photos/19190380/pexels-photo-19190380.jpeg',
      'https://images.pexels.com/photos/16992935/pexels-photo-16992935.jpeg',
    ],
  ),
  'royal_palace': PlaceData(
    id: 'royal_palace',
    title: 'Royal Palace',
    subtitle: 'Dar al-Makhzen',
    imageUrl: 'https://www.voyage-maroc.com/cdn/ma-public/shutterstock_2637428545palais_royal_fez-MAX-w1000h600.jpg',
    description: 'The magnificent Royal Palace of Fez with its famous golden doors. While interior is closed to public, the exterior gates are a masterpiece.',
    category: PlaceCategory.historical,
    visitDuration: '20 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0535,
    longitude: -5.0006,
    rating: 4.5,
    reviewCount: 2876,
    isOpenNow: true,
    distanceKm: 4.8,
    highlights: [
      'Famous golden doors',
      'Brass decorations',
      'Royal architecture',
      'Photo opportunity'
    ],
    tips: [
      'Exterior viewing only',
      'Best for photos',
      'Large plaza in front',
      'Free to visit'
    ],
    galleryImages: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1c/bb/42/41/when-we-think-of-morocco.jpg?w=900&h=-1&s=1',
      'https://dynamic-media-cdn.tripadvisor.com/media/daodao/photo-o/1b/36/72/0b/photo2jpg.jpg?w=1400&h=-1&s=1',
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1a/dc/25/30/img-20191222-151732601.jpg?w=1400&h=-1&s=1',
    ],
  ),
  'andalusian_mosque': PlaceData(
    id: 'andalusian_mosque',
    title: 'Andalusian Mosque',
    subtitle: 'Historic Prayer House',
    imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/b9/6c/a4/photo0jpg.jpg?w=700&h=-1&s=1',
    description: 'Founded in 859-860 AD, this ancient mosque showcases beautiful Andalusian architecture and is one of the oldest mosques in Fez.',
    category: PlaceCategory.religious,
    visitDuration: '25 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0671,
    longitude: -4.9721,
    rating: 4.6,
    reviewCount: 987,
    isOpenNow: true,
    distanceKm: 3.2,
    highlights: [
      'Andalusian architecture',
      '9th century foundation',
      'Historic significance',
      'Beautiful entrance gate'
    ],
    tips: [
      'Muslims only inside',
      'View from outside',
      'Dress modestly',
      'Near Andalusian quarter'
    ],
    galleryImages: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1c/80/9c/3c/andalusian-mosque.jpg?w=1400&h=-1&s=1',
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/e1/e6/59/caption.jpg?w=1100&h=-1&s=1',
    ],
  ),
  'borj_nord': PlaceData(
    id: 'borj_nord',
    title: 'Borj Nord',
    subtitle: 'Military Museum',
    imageUrl: 'https://www.touropia.com/gfx/b/2019/11/borj_nord.jpg',
    description: '16th-century fortress turned military museum offering panoramic views and exhibits of Moroccan military history and weaponry.',
    category: PlaceCategory.museum,
    visitDuration: '1 hour',
    priceInfo: const PriceInfo.paid(price: 30),
    latitude: 34.0702,
    longitude: -4.9785,
    rating: 4.4,
    reviewCount: 756,
    isOpenNow: true,
    distanceKm: 5.3,
    highlights: [
      'Historic fortress',
      'Military artifacts',
      'Panoramic views',
      'Weapon collections'
    ],
    tips: [
      'Taxi recommended',
      'Great views',
      'Photography allowed',
      'Less touristy'
    ],
    galleryImages: [
      'https://globalcastaway.com/wp-content/uploads/2018/12/borj-nord.jpg',
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Borj_Nord_interior.jpg/330px-Borj_Nord_interior.jpg',
      'https://i1.hespress.com/wp-content/uploads/2016/07/musee_arme1_675085231.jpg',
    ],
  ),
  'souk_attarine': PlaceData(
    id: 'souk_attarine',
    title: 'Souk Attarine',
    subtitle: 'Spice & Perfume Market',
    imageUrl: 'https://www.getyourguide.com/fr-fr/fes-l829/visite-de-fes-monuments-historiques-marche-et-visite-de-la-medina-t507249/',
    description: 'Traditional market selling spices, perfumes, herbs, and traditional Moroccan remedies. A sensory experience of colors and aromas.',
    category: PlaceCategory.cultural,
    visitDuration: '1 hour',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0645,
    longitude: -4.9750,
    rating: 4.7,
    reviewCount: 1543,
    isOpenNow: true,
    distanceKm: 2.4,
    highlights: [
      'Traditional spices',
      'Local perfumes',
      'Medicinal herbs',
      'Authentic atmosphere'
    ],
    tips: [
      'Bargaining expected',
      'Sample before buying',
      'Morning visits best',
      'Bring cash'
    ],
    galleryImages: [
      'https://www.getyourguide.com/fr-fr/fes-l829/visite-de-fes-monuments-historiques-marche-et-visite-de-la-medina-t507249/',
    ],
  ),
  'jardin_lalla_mina': PlaceData(
    id: 'jardin_lalla_mina',
    title: 'Jardin Lalla Mina',
    subtitle: 'Hidden Garden Oasis',
    imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/ea/7f/3a/jardin-lalla-mina.jpg',
    description: 'A serene garden oasis within the medina walls, featuring traditional Moroccan landscaping, fountains, and shaded pathways.',
    category: PlaceCategory.nature,
    visitDuration: '45 minutes',
    priceInfo: const PriceInfo.free(),
    latitude: 34.0625,
    longitude: -4.9795,
    rating: 4.5,
    reviewCount: 654,
    isOpenNow: true,
    distanceKm: 3.9,
    highlights: [
      'Peaceful escape',
      'Traditional landscaping',
      'Shaded walkways',
      'Local gathering spot'
    ],
    tips: [
      'Perfect for breaks',
      'Free entrance',
      'Quiet atmosphere',
      'Locals favorite'
    ],
    galleryImages: [
      'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/ea/7f/3a/jardin-lalla-mina.jpg',
    ],
  ),
};

// ============================================================================
// SECTIONS CONFIGURATION
// ============================================================================

final Map<String, SectionConfig> _sections = {
  'featured': SectionConfig(
    id: 'featured',
    title: "Let's explore Fez",
    subtitle: 'Discover the magic of Morocco',
    placeIds: ['bab_boujloud', 'al_qarawiyyin', 'chouara_tannery'],
  ),
  'popular': SectionConfig(
    id: 'popular',
    title: 'Popular Destinations',
    subtitle: 'Most visited places in Fez',
    placeIds: ['bou_inania', 'dar_batha', 'merenid_tombs', 'royal_palace'],
  ),
  'explore': SectionConfig(
    id: 'explore',
    title: 'Explore More',
    subtitle: 'Hidden gems and local favorites',
    placeIds: ['jnan_sbil', 'nejjarine', 'moulay_idriss', 'attarine_madrasa'],
  ),
  'highlights': SectionConfig(
    id: 'highlights',
    title: 'Top Highlights',
    subtitle: 'Must-see attractions in Fez',
    placeIds: ['bab_boujloud', 'merenid_tombs', 'bou_inania', 'chouara_tannery'],
  ),
  'cultural': SectionConfig(
    id: 'cultural',
    title: 'Cultural Experiences',
    subtitle: 'Immerse in Moroccan culture',
    placeIds: ['souk_attarine', 'chouara_tannery', 'attarine_madrasa', 'andalusian_mosque'],
  ),
  'relaxation': SectionConfig(
    id: 'relaxation',
    title: 'Peaceful Escapes',
    subtitle: 'Relax and unwind',
    placeIds: ['jnan_sbil', 'jardin_lalla_mina', 'dar_batha'],
  ),
};

// ============================================================================