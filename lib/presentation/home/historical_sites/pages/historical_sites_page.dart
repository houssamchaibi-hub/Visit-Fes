// lib/presentation/home/historical_sites/pages/historical_sites_page.dart
import 'package:flutter/material.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/managers/favorites_manager.dart';
import 'site_details_page.dart';

class HistoricalSitesPage extends StatefulWidget {
  const HistoricalSitesPage({super.key});

  @override
  State<HistoricalSitesPage> createState() => _HistoricalSitesPageState();
}

class _HistoricalSitesPageState extends State<HistoricalSitesPage> {
  String _selectedFilter = 'All';
  String _selectedSort = 'Recommended';
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // App Bar - Orange & Black
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.historicalSites,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1A1A1A),
                      Color(0xFF2A2A2A),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Center(
                      child: Icon(
                        Icons.museum_rounded,
                        color: const Color(0xFFFF6B35).withOpacity(0.2),
                        size: 80,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter and Sort Buttons
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showFilterSheet(context),
                      icon: const Icon(Icons.filter_list_rounded, size: 20),
                      label: Text(l10n.filter),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6B35),
                        side: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showOrderSheet(context),
                      icon: const Icon(Icons.sort_rounded, size: 20),
                      label: Text(l10n.sort),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6B35),
                        side: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sites List - Top 13 Sites in Fes
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 1. Al-Qarawiyyin Mosque & University
                _SiteCard(
                  id: 'al-qarawiyyin-mosque',
                  imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/University_of_Al_Qaraouiyine.jpg/500px-University_of_Al_Qaraouiyine.jpg',
                  title: 'Al-Qarawiyyin Mosque & University',
                  rating: 9.8,
                  reviews: 542,
                  duration: '2h',
                  badge: '🕌',
                  price: l10n.free,
                  year: '859 AD',
                  isNew: false,
                  location: 'Fes el-Bali, Fes',
                  category: 'Mosque & University',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 2. Bab Boujloud - Blue Gate
                _SiteCard(
                  id: 'bab-boujloud',
                  imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/30/43/d8/c3/caption.jpg?w=1100&h=-1&s=1',
                  title: 'Bab Boujloud - Blue Gate',
                  rating: 9.4,
                  reviews: 689,
                  duration: '30min',
                  badge: '🚪',
                  price: l10n.free,
                  year: '1913',
                  isNew: false,
                  location: 'Medina, Fes',
                  category: 'Historic Gate',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 3. Bou Inania Madrasa
                _SiteCard(
                  id: 'bou-inania-madrasa',
                  imageUrl: 'https://images.pexels.com/photos/30397288/pexels-photo-30397288.jpeg',
                  title: 'Bou Inania Madrasa',
                  rating: 9.5,
                  reviews: 478,
                  duration: '1.5h',
                  badge: '🏛️',
                  price: '20-60 MAD',
                  year: '1350',
                  isNew: false,
                  location: 'Talaa Kebira, Fes',
                  category: 'Madrasa',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 4. Attarine Madrasa
                _SiteCard(
                  id: 'attarine-madrasa',
                  imageUrl: 'https://images.pexels.com/photos/19190380/pexels-photo-19190380.jpeg',
                  title: 'Attarine Madrasa',
                  rating: 9.3,
                  reviews: 312,
                  duration: '1h',
                  badge: '🏛️',
                  price: '20-60 MAD',
                  year: '1325',
                  isNew: false,
                  location: 'Near Al-Qarawiyyin, Fes',
                  category: 'Madrasa',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 5. Chouara Tannery (Dar Dabagh)
                _SiteCard(
                  id: 'chouara-tannery',
                  imageUrl: 'https://images.pexels.com/photos/11537244/pexels-photo-11537244.jpeg',
                  title: 'Chouara Tannery',
                  rating: 8.8,
                  reviews: 734,
                  duration: '1h',
                  badge: '🎨',
                  price: l10n.free,
                  year: '11th Century',
                  isNew: false,
                  location: 'Chouara Quarter, Fes',
                  category: 'Traditional Craft',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 6. Nejjarine Museum of Wooden Arts
                _SiteCard(
                  id: 'nejjarine-museum',
                  imageUrl: 'https://static.wixstatic.com/media/68ca6c_68273c95489a469b91e40d459432153f~mv2_d_1200_1800_s_2.jpg/v1/fill/w_980,h_1470,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/68ca6c_68273c95489a469b91e40d459432153f~mv2_d_1200_1800_s_2.jpg',
                  title: 'Nejjarine Museum of Wooden Arts',
                  rating: 9.0,
                  reviews: 298,
                  duration: '1.5h',
                  badge: '🪵',
                  price: '20-60 MAD',
                  year: '1711',
                  isNew: false,
                  location: 'Nejjarine Square, Fes',
                  category: 'Museum',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 7. Dar Batha Museum
                _SiteCard(
                  id: 'dar-batha-museum',
                  imageUrl: 'https://th.bing.com/th/id/R.b553c8b9b26f4d4fb2846a036dba4087?rik=ekcKfieqoUBt4g&riu=http%3a%2f%2fsimply-morocco.com%2fwp-content%2fuploads%2f2019%2f06%2fvisit-fes-Dar-Batha-Museum.jpg&ehk=nG0tk00PTqBkZFvuccrbe2HsnwOCj2e2Ca19VcMvEZ4%3d&risl=&pid=ImgRaw&r=0',
                  title: 'Dar Batha Museum',
                  rating: 8.9,
                  reviews: 324,
                  duration: '2h',
                  badge: '🏛️',
                  price: '20-60 MAD',
                  year: '1897',
                  isNew: false,
                  location: 'Place de l\'Istiqlal, Fes',
                  category: 'Museum',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 8. Merenid Tombs
                _SiteCard(
                  id: 'merenid-tombs',
                  imageUrl: 'https://gv-images.viamichelin.com/images/michelin_guide/max/Img_67356.jpg',
                  title: 'Merenid Tombs',
                  rating: 9.4,
                  reviews: 567,
                  duration: '1.5h',
                  badge: '🏛️',
                  price: l10n.free,
                  year: '1358',
                  isNew: false,
                  location: 'Northern Hills, Fes',
                  category: 'Historic Ruins',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 9. Jnan Sbil Garden
                _SiteCard(
                  id: 'jnan-sbil-garden',
                  imageUrl: 'https://lp-cms-production.imgix.net/features/2019/04/jnan-sbil-garden-fez-morocco-f61d8b95a52c.jpg?auto=format&fit=crop&sharp=10&vib=20&ixlib=react-8.6.4&w=850&q=20&dpr=5',
                  title: 'Jnan Sbil Garden',
                  rating: 8.5,
                  reviews: 412,
                  duration: '1h',
                  badge: '🌳',
                  price: l10n.free,
                  year: '1913',
                  isNew: false,
                  location: 'Bab Bou Jeloud, Fes',
                  category: 'Garden',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 10. Zawiya Moulay Idriss II
                _SiteCard(
                  id: 'zawiya-moulay-idriss',
                  imageUrl: 'https://lh3.googleusercontent.com/gps-cs-s/AHVAwepSFedwuQ1fXhjMZvDnU25BEFhh8X_LcXoSMOwnAVDLwftCcYuhqQaF3XjvkfufLuMZz99HFxHMeH-fk_C77Hko7TZqwTE4OJRDAEtl1onzQlNyRZrUKDlhu7e1tiqpKbB71Ari=s1360-w1360-h1020-rw',
                  title: 'Zawiya Moulay Idriss II',
                  rating: 9.5,
                  reviews: 367,
                  duration: '1h',
                  badge: '⭐',
                  price: l10n.free,
                  year: '828 AD',
                  isNew: false,
                  location: 'Fes el-Bali, Fes',
                  category: 'Sacred Site',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 11. Zawiya Tijania
                _SiteCard(
                  id: 'zawiya-tijania',
                  imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Zaouiya_Tidjaniya_de_F%C3%A8s_-_grille.jpg/500px-Zaouiya_Tidjaniya_de_F%C3%A8s_-_grille.jpg',
                  title: 'Zawiya Tijania',
                  rating: 9.2,
                  reviews: 245,
                  duration: '45min',
                  badge: '⭐',
                  price: l10n.free,
                  year: '19th Century',
                  isNew: false,
                  location: 'Fes el-Bali, Fes',
                  category: 'Sacred Site',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 12. Royal Palace (Dar el-Makhzen) - NEW
                _SiteCard(
                  id: 'royal-palace',
                  imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2e/0f/e1/ee/caption.jpg?w=1400&h=-1&s=1',
                  title: 'Royal Palace - Dar el-Makhzen',
                  rating: 9.1,
                  reviews: 523,
                  duration: '45min',
                  badge: '👑',
                  price: l10n.free,
                  year: '13th Century',
                  isNew: true,
                  location: 'Fes el-Jdid, Fes',
                  category: 'Royal Palace',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),

                // 13. Andalusian Mosque - NEW
                _SiteCard(
                  id: 'andalusian-mosque',
                  imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/b9/6c/a4/photo0jpg.jpg?w=700&h=-1&s=1',
                  title: 'Andalusian Mosque',
                  rating: 9.0,
                  reviews: 287,
                  duration: '1h',
                  badge: '🕌',
                  price: l10n.free,
                  year: '859 AD',
                  isNew: true,
                  location: 'Andalusian Quarter, Fes',
                  category: 'Mosque',
                  l10n: l10n,
                  favoritesManager: _favoritesManager,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.filterSites,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _FilterOption(l10n.allSites, _selectedFilter == 'All', () {
              setState(() => _selectedFilter = 'All');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.mosques, _selectedFilter == 'Mosques', () {
              setState(() => _selectedFilter = 'Mosques');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.madrasas, _selectedFilter == 'Madrasas', () {
              setState(() => _selectedFilter = 'Madrasas');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.museums, _selectedFilter == 'Museums', () {
              setState(() => _selectedFilter = 'Museums');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.gatesWalls, _selectedFilter == 'Gates', () {
              setState(() => _selectedFilter = 'Gates');
              Navigator.pop(context);
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.applyFilter,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.sort_rounded,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.sortBy,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _FilterOption(l10n.oldestFirst, _selectedSort == 'Oldest', () {
              setState(() => _selectedSort = 'Oldest');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.newestFirst, _selectedSort == 'Newest', () {
              setState(() => _selectedSort = 'Newest');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.highestRated, _selectedSort == 'Rating', () {
              setState(() => _selectedSort = 'Rating');
              Navigator.pop(context);
            }),
            _FilterOption(l10n.mostPopular, _selectedSort == 'Popular', () {
              setState(() => _selectedSort = 'Popular');
              Navigator.pop(context);
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.applySort,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _FilterOption(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFFFF6B35) : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SITE CARD WIDGET
// ============================================================================

class _SiteCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final double rating;
  final int reviews;
  final String duration;
  final String badge;
  final String price;
  final String year;
  final bool isNew;
  final String location;
  final String category;
  final AppLocalizations l10n;
  final FavoritesManager favoritesManager;

  const _SiteCard({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.badge,
    required this.price,
    required this.year,
    required this.isNew,
    required this.location,
    required this.category,
    required this.l10n,
    required this.favoritesManager,
  });

  void _toggleFavorite(BuildContext context) {
    final isFavorite = favoritesManager.isFavorite(id);

    if (isFavorite) {
      favoritesManager.removeFavorite(id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.heart_broken, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Removed from favorites',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'UNDO',
            textColor: const Color(0xFFFF6B35),
            onPressed: () {
              favoritesManager.undoDelete();
            },
          ),
        ),
      );
    } else {
      final favoriteData = {
        'id': id,
        'name': title,
        'type': 'place',
        'image': imageUrl,
        'location': location,
        'category': category,
        'rating': rating,
        'reviews': reviews,
        'price': price,
        'duration': duration,
        'year': year,
        'badge': badge,
      };

      favoritesManager.addFavorite(favoriteData);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Added to favorites',
                  style: TextStyle(fontSize: 15),
                ),
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

  @override
  Widget build(BuildContext context) {
    final isFavorite = favoritesManager.isFavorite(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              if (isNew)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8F00)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFFF6B35) : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Year badge
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    year,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Rating & Reviews
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($reviews ${l10n.reviews})',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Duration & Badge
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(badge, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),

                // Price & Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.entry,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF6B35),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SiteDetailsPage(
                              id: id,
                              title: title,
                              imageUrl: imageUrl,
                              rating: rating,
                              reviews: reviews,
                              duration: duration,
                              price: price,
                              year: year,
                              badge: badge,
                              location: location,
                              category: category,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.visit,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}