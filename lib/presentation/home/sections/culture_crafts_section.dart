// lib/presentation/home/sections/culture_crafts_section.dart
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../culture/pages/culture_crafts_page.dart';

class CultureCraftsSection extends StatelessWidget {
  const CultureCraftsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.palette_rounded,
      title: 'Culture & Crafts',
      description: 'Traditional arts, craftsmanship, and local artisans',
      color: const Color(0xFF1A1A1A),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CultureCraftsPage(),
          ),
        );
      },
    );
  }
}