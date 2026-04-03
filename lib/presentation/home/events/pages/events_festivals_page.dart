// lib/presentation/events/pages/events_festivals_page.dart
import 'package:flutter/material.dart';

class EventsFestivalsPage extends StatelessWidget {
  const EventsFestivalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFFFF8F00),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Events & Festivals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF8F00), Color(0xFFFF6B35)],
                  ),
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  size: 100,
                  color: Colors.white24,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Annual Celebrations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildEventCard(
                    title: 'Fes Festival of World Sacred Music',
                    period: 'May - June',
                    description: 'Week-long celebration bringing together musicians from around the world in a spirit of tolerance and understanding.',
                    icon: Icons.music_note_rounded,
                    color: const Color(0xFFFF6B35),
                  ),
                  _buildEventCard(
                    title: 'Moussem of Moulay Idriss II',
                    period: 'September',
                    description: 'Religious festival honoring the founder of Fes with processions, music, and traditional ceremonies.',
                    icon: Icons.mosque_rounded,
                    color: const Color(0xFF1A1A1A),
                  ),
                  _buildEventCard(
                    title: 'Fes Festival of Sufi Culture',
                    period: 'October',
                    description: 'Spiritual gathering showcasing Sufi music, poetry, and mystical traditions.',
                    icon: Icons.self_improvement_rounded,
                    color: const Color(0xFFE91E63),
                  ),
                  _buildEventCard(
                    title: 'Cherry Festival',
                    period: 'June',
                    description: 'Celebration of the cherry harvest in nearby Sefrou with folk music and dancing.',
                    icon: Icons.festival_rounded,
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildEventCard(
                    title: 'Ramadan Nights',
                    period: 'Islamic Calendar',
                    description: 'Special evening activities, traditional foods, and spiritual gatherings throughout the holy month.',
                    icon: Icons.nightlight_round,
                    color: const Color(0xFF2196F3),
                  ),
                  _buildEventCard(
                    title: 'Fes Film Festival',
                    period: 'November',
                    description: 'Showcasing Moroccan and international cinema in historic venues.',
                    icon: Icons.movie_rounded,
                    color: const Color(0xFFFF8F00),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String period,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      period,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}