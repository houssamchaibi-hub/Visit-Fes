// lib/presentation/home/sections/home_header_section.dart
// COMPLETE FILE - Contains AboutFesPage + HomeHeaderSection

import 'package:flutter/material.dart';

// ============================================================================
// ABOUT FES PAGE - Full Page Version
// ============================================================================

class AboutFesPage extends StatelessWidget {
  const AboutFesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ============================================================
          // HEADER WITH IMAGE
          // ============================================================
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFFF6B35),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'À propos de Fès',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1569163139394-de4798aa62b6?w=1200&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFFF6B35),
                      child: const Icon(
                        Icons.location_city,
                        size: 100,
                        color: Colors.white24,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // CONTENT
          // ============================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction Card
                  _buildIntroCard(),
                  const SizedBox(height: 24),

                  // Historical Timeline
                  _buildSectionTitle('Chronologie Historique'),
                  const SizedBox(height: 16),
                  const _TimelineItem(
                    year: '789 AD',
                    title: 'Fondation de Fès',
                    description: 'Fondée par Idris I, établissant la première dynastie islamique au Maroc.',
                    icon: Icons.flag_rounded,
                  ),
                  const _TimelineItem(
                    year: '859 AD',
                    title: 'Université Al-Qarawiyyin',
                    description: 'Fatima al-Fihri a fondé la plus ancienne université en activité continue au monde.',
                    icon: Icons.school_rounded,
                  ),
                  const _TimelineItem(
                    year: '1276 AD',
                    title: 'Fès el-Jdid',
                    description: 'La dynastie Mérinide a construit la "Nouvelle Fès" incluant le Palais Royal.',
                    icon: Icons.account_balance_rounded,
                  ),
                  const _TimelineItem(
                    year: '1981',
                    title: 'Reconnaissance UNESCO',
                    description: 'La Médina de Fès désignée site du patrimoine mondial de l\'UNESCO.',
                    icon: Icons.verified_rounded,
                  ),
                  const _TimelineItem(
                    year: 'Aujourd\'hui',
                    title: 'Capitale Culturelle',
                    description: 'Fès continue d\'être le centre spirituel et artisanal du Maroc avec plus de 1,1 million d\'habitants.',
                    icon: Icons.celebration_rounded,
                    isLast: true,
                  ),

                  const SizedBox(height: 32),

                  // Facts & Figures
                  _buildSectionTitle('Chiffres Clés'),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: _FactCard(
                          number: '789',
                          label: 'Année de fondation',
                          icon: Icons.calendar_today_rounded,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FactCard(
                          number: '1.1M',
                          label: 'Population',
                          icon: Icons.people_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: _FactCard(
                          number: '9000+',
                          label: 'Ruelles',
                          icon: Icons.signpost_rounded,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _FactCard(
                          number: '1235',
                          label: 'Ans d\'histoire',
                          icon: Icons.history_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Must-Visit Places
                  _buildSectionTitle('Lieux Incontournables'),
                  const SizedBox(height: 16),
                  const _PlaceCard(
                    title: 'Bab Boujloud',
                    description: 'La porte bleue emblématique et entrée principale de la médina.',
                    emoji: '🚪',
                  ),
                  const _PlaceCard(
                    title: 'Tannerie Chouara',
                    description: 'Anciennes tanneries avec méthodes traditionnelles de teinture.',
                    emoji: '🎨',
                  ),
                  const _PlaceCard(
                    title: 'Mosquée Al-Qarawiyyin',
                    description: 'L\'une des plus grandes mosquées d\'Afrique et plus ancienne université.',
                    emoji: '🕌',
                  ),
                  const _PlaceCard(
                    title: 'Médersa Bou Inania',
                    description: 'Magnifique école islamique du XIVe siècle avec architecture complexe.',
                    emoji: '🏛️',
                  ),
                  const _PlaceCard(
                    title: 'Palais Royal',
                    description: 'Belles portes dorées et architecture marocaine impressionnante.',
                    emoji: '👑',
                  ),

                  const SizedBox(height: 32),

                  // Cultural Significance
                  _buildSectionTitle('Importance Culturelle'),
                  const SizedBox(height: 16),
                  _buildCulturalCard(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8F00)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.location_city_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Découvrir Fès',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Capitale Spirituelle du Maroc',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Fondée en 789 après JC par Idris I, Fès est l\'une des plus anciennes villes médiévales continuellement habitées au monde. Abritant la prestigieuse Université d\'Al Qaraouiyine—la plus ancienne institution éducative existante au monde—Fès reste le cœur battant de la tradition marocaine et de l\'érudition islamique.',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[700],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF6B35).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.castle_rounded,
                  color: Color(0xFFFF6B35),
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Site du patrimoine mondial UNESCO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'Médina de Fès el-Bali',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF6B35), size: 28),
              SizedBox(width: 12),
              Text(
                'Pourquoi Fès est importante',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCulturalPoint(
            icon: Icons.book_rounded,
            title: 'Héritage Éducatif',
            text: 'Abrite la plus ancienne université du monde, établie en 859 après JC.',
          ),
          const SizedBox(height: 16),
          _buildCulturalPoint(
            icon: Icons.handshake_rounded,
            title: 'Excellence Artisanale',
            text: 'Artisanat traditionnel transmis de génération en génération depuis des siècles.',
          ),
          const SizedBox(height: 16),
          _buildCulturalPoint(
            icon: Icons.mosque_rounded,
            title: 'Centre Spirituel',
            text: 'Important lieu de pèlerinage et centre d\'apprentissage islamique en Afrique du Nord.',
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalPoint({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFFF6B35), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: Color(0xFF1A1A1A),
        letterSpacing: -0.5,
      ),
    );
  }
}

// ============================================================================
// HOME HEADER SECTION - Widget for Home Page (si bghiti tsthmlha)
// ============================================================================

class HomeHeaderSection extends StatelessWidget {
  final String userName;

  const HomeHeaderSection({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFFF8F00),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1569163139394-de4798aa62b6?w=1200&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFFF6B35),
              child: const Icon(
                Icons.location_city,
                size: 100,
                color: Colors.white24,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Bonjour, $userName! ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '👋',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'Visitez Fès',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Découvrez la beauté de la\ncapitale culturelle du Maroc',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TIMELINE ITEM
// ============================================================================

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.description,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8F00)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFFF6B35),
                        const Color(0xFFFF6B35).withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF6B35),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey[600],
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

// ============================================================================
// FACT CARD
// ============================================================================

class _FactCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _FactCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFEA580C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PLACE CARD
// ============================================================================

class _PlaceCard extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;

  const _PlaceCard({
    required this.title,
    required this.description,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}