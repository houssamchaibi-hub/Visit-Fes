// lib/presentation/home/widgets/home_navigation_tabs.dart

import 'package:flutter/material.dart';

class HomeNavigationTabs extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const HomeNavigationTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'About Fes',
              icon: Icons.info_rounded,
              isSelected: selectedTab == 'about',
              onTap: () => onTabSelected('about'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              label: 'Historical Sites',
              icon: Icons.castle_rounded,
              isSelected: selectedTab == 'sites',
              onTap: () => onTabSelected('sites'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              label: 'Map',
              icon: Icons.map_rounded,
              isSelected: selectedTab == 'map',
              onTap: () => onTabSelected('map'),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [
              Color(0xFFFF6B35),
              Color(0xFFFF8F00),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? null
              : Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.grey[700],
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}