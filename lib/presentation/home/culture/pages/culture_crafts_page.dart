// lib/presentation/culture/pages/culture_crafts_page.dart
import 'package:flutter/material.dart';

class CultureCraftsPage extends StatelessWidget {
  const CultureCraftsPage({super.key});

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
            backgroundColor: const Color(0xFF1A1A1A),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Culture & Crafts',
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
                    colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
                  ),
                ),
                child: const Icon(
                  Icons.palette_rounded,
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
                    'Traditional Crafts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCraftCard(
                    emoji: '🎨',
                    title: 'Pottery & Ceramics',
                    description: 'Famous blue and white pottery from Fes el-Bali',
                    location: 'Place Seffarine',
                  ),
                  _buildCraftCard(
                    emoji: '🧵',
                    title: 'Textile Weaving',
                    description: 'Traditional handwoven rugs and fabrics',
                    location: 'Souk Attarine',
                  ),
                  _buildCraftCard(
                    emoji: '🪵',
                    title: 'Woodwork & Carving',
                    description: 'Intricate cedar wood carvings and furniture',
                    location: 'Nejjarine Museum',
                  ),
                  _buildCraftCard(
                    emoji: '💍',
                    title: 'Metalwork & Jewelry',
                    description: 'Brass, copper, and silver craftsmanship',
                    location: 'Souk Seffarine',
                  ),
                  _buildCraftCard(
                    emoji: '👞',
                    title: 'Leather Tanning',
                    description: 'Ancient leather dyeing techniques at Chouara',
                    location: 'Chouara Tannery',
                  ),
                  _buildCraftCard(
                    emoji: '🪡',
                    title: 'Embroidery',
                    description: 'Traditional Fassi embroidery and textiles',
                    location: 'Medina Workshops',
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

  Widget _buildCraftCard({
    required String emoji,
    required String title,
    required String description,
    required String location,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Color(0xFFFF6B35),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B35),
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