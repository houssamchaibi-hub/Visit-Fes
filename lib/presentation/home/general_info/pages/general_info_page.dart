// lib/presentation/general_info/pages/general_info_page.dart
import 'package:flutter/material.dart';

class GeneralInfoPage extends StatelessWidget {
  const GeneralInfoPage({super.key});

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
            backgroundColor: const Color(0xFFFF6B35),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'General Information',
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
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8F00)],
                  ),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
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
                  _buildInfoCard(
                    icon: Icons.language_rounded,
                    title: 'Languages',
                    content: 'Arabic (official), French widely spoken, English in tourist areas',
                    color: const Color(0xFFFF6B35),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.attach_money_rounded,
                    title: 'Currency',
                    content: 'Moroccan Dirham (MAD). ATMs available, cards accepted in most hotels',
                    color: const Color(0xFF1A1A1A),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.wb_sunny_rounded,
                    title: 'Best Time to Visit',
                    content: 'Spring (March-May) and Fall (September-November) for pleasant weather',
                    color: const Color(0xFFFF8F00),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.directions_bus_rounded,
                    title: 'Getting Around',
                    content: 'Petit taxis, walking in medina, train station for intercity travel',
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.phone_rounded,
                    title: 'Emergency Numbers',
                    content: 'Police: 19 | Ambulance: 15 | Fire: 15 | Tourist Police: 0535-62-41-76',
                    color: const Color(0xFFE91E63),
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

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
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
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}