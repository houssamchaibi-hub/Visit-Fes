// lib/presentation/home/sections/events_festivals_section.dart
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../events/pages/events_festivals_page.dart';

class EventsFestivalsSection extends StatelessWidget {
  const EventsFestivalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.celebration_rounded,
      title: 'Events & Festivals',
      description: 'Cultural celebrations and annual festivities',
      color: const Color(0xFFFF8F00),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EventsFestivalsPage(),
          ),
        );
      },
    );
  }
}