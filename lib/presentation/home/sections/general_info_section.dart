// lib/presentation/home/sections/general_info_section.dart
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../general_info/pages/general_info_page.dart';

class GeneralInfoSection extends StatelessWidget {
  const GeneralInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      icon: Icons.info_outline_rounded,
      title: 'General Information',
      description: 'Essential travel info, transport, and practical tips',
      color: const Color(0xFFFF6B35),
      isLarge: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GeneralInfoPage(),
          ),
        );
      },
    );
  }
}