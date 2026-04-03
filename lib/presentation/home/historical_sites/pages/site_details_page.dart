// lib/presentation/home/historical_sites/pages/site_details_page.dart
import 'package:flutter/material.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';

class SiteDetailsPage extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final int reviews;
  final String duration;
  final String price;
  final String year;
  final String badge;
  final String? location;
  final String? category;
  final String? openingHours;
  final String? accessibility;
  final List<String>? facilities;
  final bool? audioGuideAvailable;
  final bool? photographyAllowed;
  final List<Map<String, dynamic>>? userReviews;
  final List<String>? tips;

  const SiteDetailsPage({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.price,
    required this.year,
    required this.badge,
    this.location,
    this.category,
    this.openingHours,
    this.accessibility,
    this.facilities,
    this.audioGuideAvailable,
    this.photographyAllowed,
    this.userReviews,
    this.tips,
  });

  @override
  State<SiteDetailsPage> createState() => _SiteDetailsPageState();
}

class _SiteDetailsPageState extends State<SiteDetailsPage> {
  final FavoritesManager _favoritesManager = FavoritesManager();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _checkFavoriteStatus() {
    setState(() {
      _isFavorite = _favoritesManager.isFavorite(widget.id);
    });
  }

  void _onFavoritesChanged() {
    if (mounted) _checkFavoriteStatus();
  }

  void _toggleFavorite() {
    if (_isFavorite) {
      _favoritesManager.removeFavorite(widget.id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.heart_broken, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Removed "${widget.title}" from favorites',
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: const Color(0xFFFF6B35),
            onPressed: () => _favoritesManager.undoDelete(),
          ),
        ),
      ).closed.then((reason) {
        if (reason != SnackBarClosedReason.action) {
          _favoritesManager.clearUndoBuffer();
        }
      });
    } else {
      _favoritesManager.addFavorite({
        'id': widget.id,
        'name': widget.title,
        'type': 'place',
        'image': widget.imageUrl,
        'location': widget.location ?? 'Fes, Morocco',
        'category': widget.category ?? 'Historical Site',
        'rating': widget.rating,
        'reviews': widget.reviews,
        'price': widget.price,
        'duration': widget.duration,
        'year': widget.year,
        'badge': widget.badge,
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Added "${widget.title}" to favorites',
                    style: const TextStyle(fontSize: 15)),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFFF6B35),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ============================================================
  // ALL SITE DATA VIA l10n — unique per place
  // ============================================================

  Map<String, dynamic> _getCurrentSiteInfo(AppLocalizations l10n) {
    switch (widget.title) {

      case 'Al-Qarawiyyin Mosque & University':
        return {
          'description': l10n.alQarawiyyinDesc,
          'included': [l10n.alQarawiyyinIncluded1, l10n.alQarawiyyinIncluded2, l10n.alQarawiyyinIncluded3, l10n.alQarawiyyinIncluded4, l10n.alQarawiyyinIncluded5],
          'info': [l10n.alQarawiyyinInfo1, l10n.alQarawiyyinInfo2, l10n.alQarawiyyinInfo3, l10n.alQarawiyyinInfo4],
          'meeting': l10n.alQarawiyyinMeetingLocation,
          'meetingDesc': l10n.alQarawiyyinMeetingDesc,
        };

      case 'Bab Boujloud - Blue Gate':
        return {
          'description': l10n.babBoujloudDesc,
          'included': [l10n.babBoujloudIncluded1, l10n.babBoujloudIncluded2, l10n.babBoujloudIncluded3, l10n.babBoujloudIncluded4, l10n.babBoujloudIncluded5],
          'info': [l10n.babBoujloudInfo1, l10n.babBoujloudInfo2, l10n.babBoujloudInfo3, l10n.babBoujloudInfo4],
          'meeting': l10n.babBoujloudMeetingLocation,
          'meetingDesc': l10n.babBoujloudMeetingDesc,
        };

      case 'Bou Inania Madrasa':
        return {
          'description': l10n.bouInaniaDesc,
          'included': [l10n.bouInaniaIncluded1, l10n.bouInaniaIncluded2, l10n.bouInaniaIncluded3, l10n.bouInaniaIncluded4, l10n.bouInaniaIncluded5],
          'info': [l10n.bouInaniaInfo1, l10n.bouInaniaInfo2, l10n.bouInaniaInfo3, l10n.bouInaniaInfo4],
          'meeting': l10n.bouInaniaMeetingLocation,
          'meetingDesc': l10n.bouInaniaMeetingDesc,
        };

      case 'Attarine Madrasa':
        return {
          'description': l10n.attarineDesc,
          'included': [l10n.attarineIncluded1, l10n.attarineIncluded2, l10n.attarineIncluded3, l10n.attarineIncluded4, l10n.attarineIncluded5],
          'info': [l10n.attarineInfo1, l10n.attarineInfo2, l10n.attarineInfo3, l10n.attarineInfo4],
          'meeting': l10n.attarineMeetingLocation,
          'meetingDesc': l10n.attarineMeetingDesc,
        };

      case 'Chouara Tannery':
        return {
          'description': l10n.chouaraDesc,
          'included': [l10n.chouaraIncluded1, l10n.chouaraIncluded2, l10n.chouaraIncluded3, l10n.chouaraIncluded4, l10n.chouaraIncluded5],
          'info': [l10n.chouaraInfo1, l10n.chouaraInfo2, l10n.chouaraInfo3, l10n.chouaraInfo4],
          'meeting': l10n.chouaraMeetingLocation,
          'meetingDesc': l10n.chouaraMeetingDesc,
        };

      case 'Nejjarine Museum of Wooden Arts':
        return {
          'description': l10n.nejjarineDesc,
          'included': [l10n.nejjarineIncluded1, l10n.nejjarineIncluded2, l10n.nejjarineIncluded3, l10n.nejjarineIncluded4, l10n.nejjarineIncluded5],
          'info': [l10n.nejjarineInfo1, l10n.nejjarineInfo2, l10n.nejjarineInfo3, l10n.nejjarineInfo4],
          'meeting': l10n.nejjarineMeetingLocation,
          'meetingDesc': l10n.nejjarineMeetingDesc,
        };

      case 'Dar Batha Museum':
        return {
          'description': l10n.darBathaDesc,
          'included': [l10n.darBathaIncluded1, l10n.darBathaIncluded2, l10n.darBathaIncluded3, l10n.darBathaIncluded4, l10n.darBathaIncluded5],
          'info': [l10n.darBathaInfo1, l10n.darBathaInfo2, l10n.darBathaInfo3, l10n.darBathaInfo4],
          'meeting': l10n.darBathaMeetingLocation,
          'meetingDesc': l10n.darBathaMeetingDesc,
        };

      case 'Merenid Tombs':
        return {
          'description': l10n.merenidDesc,
          'included': [l10n.merenidIncluded1, l10n.merenidIncluded2, l10n.merenidIncluded3, l10n.merenidIncluded4, l10n.merenidIncluded5],
          'info': [l10n.merenidInfo1, l10n.merenidInfo2, l10n.merenidInfo3, l10n.merenidInfo4],
          'meeting': l10n.merenidMeetingLocation,
          'meetingDesc': l10n.merenidMeetingDesc,
        };

      case 'Jnan Sbil Garden':
        return {
          'description': l10n.jnanSbilDesc,
          'included': [l10n.jnanSbilIncluded1, l10n.jnanSbilIncluded2, l10n.jnanSbilIncluded3, l10n.jnanSbilIncluded4, l10n.jnanSbilIncluded5],
          'info': [l10n.jnanSbilInfo1, l10n.jnanSbilInfo2, l10n.jnanSbilInfo3, l10n.jnanSbilInfo4],
          'meeting': l10n.jnanSbilMeetingLocation,
          'meetingDesc': l10n.jnanSbilMeetingDesc,
        };

      case 'Zawiya Moulay Idriss II':
        return {
          'description': l10n.zawiyaMoulayIdrissDesc,
          'included': [l10n.zawiyaMoulayIdrissIncluded1, l10n.zawiyaMoulayIdrissIncluded2, l10n.zawiyaMoulayIdrissIncluded3, l10n.zawiyaMoulayIdrissIncluded4, l10n.zawiyaMoulayIdrissIncluded5],
          'info': [l10n.zawiyaMoulayIdrissInfo1, l10n.zawiyaMoulayIdrissInfo2, l10n.zawiyaMoulayIdrissInfo3, l10n.zawiyaMoulayIdrissInfo4],
          'meeting': l10n.zawiyaMoulayIdrissMeetingLocation,
          'meetingDesc': l10n.zawiyaMoulayIdrissMeetingDesc,
        };

      case 'Zawiya Tijania':
        return {
          'description': l10n.zawiyaTijaniaDesc,
          'included': [l10n.zawiyaTijaniaIncluded1, l10n.zawiyaTijaniaIncluded2, l10n.zawiyaTijaniaIncluded3, l10n.zawiyaTijaniaIncluded4, l10n.zawiyaTijaniaIncluded5],
          'info': [l10n.zawiyaTijaniaInfo1, l10n.zawiyaTijaniaInfo2, l10n.zawiyaTijaniaInfo3, l10n.zawiyaTijaniaInfo4],
          'meeting': l10n.zawiyaTijaniaMeetingLocation,
          'meetingDesc': l10n.zawiyaTijaniaMeetingDesc,
        };

      case 'Royal Palace - Dar el-Makhzen':
        return {
          'description': l10n.royalPalaceDesc,
          'included': [l10n.royalPalaceIncluded1, l10n.royalPalaceIncluded2, l10n.royalPalaceIncluded3, l10n.royalPalaceIncluded4, l10n.royalPalaceIncluded5],
          'info': [l10n.royalPalaceInfo1, l10n.royalPalaceInfo2, l10n.royalPalaceInfo3, l10n.royalPalaceInfo4],
          'meeting': l10n.royalPalaceMeetingLocation,
          'meetingDesc': l10n.royalPalaceMeetingDesc,
        };

      case 'Andalusian Mosque':
        return {
          'description': l10n.andalusianMosqueDesc,
          'included': [l10n.andalusianIncluded1, l10n.andalusianIncluded2, l10n.andalusianIncluded3, l10n.andalusianIncluded4, l10n.andalusianIncluded5],
          'info': [l10n.andalusianInfo1, l10n.andalusianInfo2, l10n.andalusianInfo3, l10n.andalusianInfo4],
          'meeting': l10n.andalusianMeetingLocation,
          'meetingDesc': l10n.andalusianMeetingDesc,
        };

      default:
        return {
          'description': l10n.defaultDesc,
          'included': [l10n.defaultIncluded1, l10n.defaultIncluded2, l10n.defaultIncluded3, l10n.defaultIncluded4],
          'info': [l10n.defaultInfo1, l10n.defaultInfo2, l10n.defaultInfo3],
          'meeting': l10n.defaultMeetingLocation,
          'meetingDesc': l10n.defaultMeetingDesc,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final siteInfo = _getCurrentSiteInfo(l10n);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── Image Header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)],
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? const Color(0xFFFF6B35) : const Color(0xFF1A1A1A),
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFFFF6B35).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(widget.year, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Card
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(widget.badge, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(widget.title,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A), height: 1.2, letterSpacing: -0.5)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFFF6B35), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.rating.toString(),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('(${widget.reviews} ${l10n.reviews})',
                                style: TextStyle(fontSize: 15, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Info Cards
                  Row(
                    children: [
                      _InfoCard(icon: Icons.access_time_rounded, label: l10n.duration, value: widget.duration),
                      const SizedBox(width: 12),
                      _InfoCard(icon: Icons.calendar_today_rounded, label: l10n.era, value: widget.year),
                      const SizedBox(width: 12),
                      const _InfoCard(icon: Icons.attach_money_rounded, label: 'Free', value: 'Entry'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Additional Details (optional props)
                  if (widget.openingHours != null || widget.accessibility != null ||
                      (widget.facilities != null && widget.facilities!.isNotEmpty))
                    _AdditionalDetailsSection(
                      openingHours: widget.openingHours,
                      accessibility: widget.accessibility,
                      facilities: widget.facilities,
                      audioGuideAvailable: widget.audioGuideAvailable,
                      photographyAllowed: widget.photographyAllowed,
                      l10n: l10n,
                    ),

                  const SizedBox(height: 16),

                  // Description
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(Icons.description_rounded, l10n.historyDescription),
                        const SizedBox(height: 16),
                        Text(siteInfo['description'],
                            style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // What's Included
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(Icons.checklist_rounded, l10n.whatsIncluded),
                        const SizedBox(height: 16),
                        ...(siteInfo['included'] as List<String>)
                            .map((item) => _IncludedItem(Icons.check_circle_rounded, item)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Important Information (dark)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: const Color(0xFFFF6B35).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.info_rounded, color: Color(0xFFFF6B35), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(l10n.importantInformation,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...(siteInfo['info'] as List<String>)
                            .map((item) => _InfoItem(Icons.info_outline, item)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meeting Point
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(Icons.location_on_rounded, l10n.meetingPoint),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.location_on, color: Color(0xFFFF6B35), size: 24),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(siteInfo['meeting'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                                    const SizedBox(height: 4),
                                    Text(siteInfo['meetingDesc'],
                                        style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFFF6B35)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tips
                  if (widget.tips != null && widget.tips!.isNotEmpty)
                    _TipsSection(tips: widget.tips!, l10n: l10n),

                  const SizedBox(height: 16),

                  // Reviews
                  if (widget.userReviews != null && widget.userReviews!.isNotEmpty)
                    _ReviewsSection(reviews: widget.userReviews!, l10n: l10n),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  // ✅ FIX: Wrapped Text with Expanded to prevent overflow in any language
  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ADDITIONAL DETAILS SECTION
// ============================================================================
class _AdditionalDetailsSection extends StatelessWidget {
  final String? openingHours;
  final String? accessibility;
  final List<String>? facilities;
  final bool? audioGuideAvailable;
  final bool? photographyAllowed;
  final AppLocalizations l10n;

  const _AdditionalDetailsSection({
    this.openingHours, this.accessibility, this.facilities,
    this.audioGuideAvailable, this.photographyAllowed, required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFFF6B35).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.business_center_rounded, color: Color(0xFFFF6B35), size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Additional Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (openingHours != null) _DetailRow(icon: Icons.schedule, title: 'Opening Hours', value: openingHours!),
          if (accessibility != null) _DetailRow(icon: Icons.accessible, title: 'Accessibility', value: accessibility!),
          if (audioGuideAvailable != null) _DetailRow(icon: Icons.headset, title: 'Audio Guide', value: audioGuideAvailable! ? 'Available' : 'Not Available', iconColor: audioGuideAvailable! ? Colors.green : Colors.grey),
          if (photographyAllowed != null) _DetailRow(icon: Icons.camera_alt, title: 'Photography', value: photographyAllowed! ? 'Allowed' : 'Not Allowed', iconColor: photographyAllowed! ? Colors.green : Colors.red),
          if (facilities != null && facilities!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Row(children: [Icon(Icons.holiday_village, color: Color(0xFFFF6B35), size: 20), SizedBox(width: 12), Text('Facilities:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)))]),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: facilities!.map((f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFF6B35).withOpacity(0.2))),
                child: Text(f, style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  const _DetailRow({required this.icon, required this.title, required this.value, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFFFF6B35), size: 20),
          const SizedBox(width: 12),
          Text('$title: ', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
          Expanded(child: Text(value, style: TextStyle(fontSize: 15, color: Colors.grey[700]))),
        ],
      ),
    );
  }
}

// ============================================================================
// TIPS SECTION
// ============================================================================
class _TipsSection extends StatelessWidget {
  final List<String> tips;
  final AppLocalizations l10n;
  const _TipsSection({required this.tips, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFFFF6B35).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 24)),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Local Tips & Advice', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
            ),
          ]),
          const SizedBox(height: 8),
          Text('Insider tips from local guides', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          ...tips.asMap().entries.map((e) => _TipItem(number: e.key + 1, tip: e.value)),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final int number;
  final String tip;
  const _TipItem({required this.number, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFFF8C5A)]), borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text('$number', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF1A1A1A), fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

// ============================================================================
// REVIEWS SECTION
// ============================================================================
class _ReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final AppLocalizations l10n;
  const _ReviewsSection({required this.reviews, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final displayReviews = reviews.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFF6B35).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.rate_review_rounded, color: Color(0xFFFF6B35), size: 20)),
                const SizedBox(width: 12),
                const Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
              ]),
              if (reviews.length > 3)
                TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: Color(0xFFFF6B35), fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 16),
          ...displayReviews.map((r) => _ReviewItem(
            name: r['name'] ?? 'Anonymous',
            rating: (r['rating'] ?? 5).toDouble(),
            comment: r['comment'] ?? '',
            date: r['date'] ?? '',
            avatar: r['avatar'],
          )),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String date;
  final String? avatar;
  const _ReviewItem({required this.name, required this.rating, required this.comment, required this.date, this.avatar});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFFF6B35),
              backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
              child: avatar == null ? Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 2),
                Row(children: [
                  ...List.generate(5, (i) => Icon(i < rating ? Icons.star : Icons.star_border, color: const Color(0xFFFF6B35), size: 14)),
                  const SizedBox(width: 8),
                  Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ]),
              ],
            )),
          ]),
          const SizedBox(height: 12),
          Text(comment, style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

// ============================================================================
// SMALL WIDGETS
// ============================================================================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(children: [
          Icon(icon, color: const Color(0xFFFF6B35), size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _IncludedItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IncludedItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFFF6B35), size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15, color: Color(0xFF1A1A1A), fontWeight: FontWeight.w500))),
      ]),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Icon(icon, color: const Color(0xFFFF6B35), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)))),
      ]),
    );
  }
}