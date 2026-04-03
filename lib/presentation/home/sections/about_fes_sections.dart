// lib/presentation/home/sections/about_fes_section.dart
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import 'home_header_section.dart'; // AboutFesPage is in this file

class AboutFesSection extends StatelessWidget {
  const AboutFesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.history_edu_rounded,
      title: 'À propos de Fès',
      description: 'Histoire, patrimoine et sites UNESCO',
      color: const Color(0xFFE91E63),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutFesPage(),
          ),
        );
      },
    );
  }
}