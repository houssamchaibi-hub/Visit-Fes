// lib/presentation/home/profile/pages/profile_page.dart
// ✅ CORRECTED VERSION - Proper imports and navigation

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/main.dart';

// ✅ Import the actual pages (remove the inline placeholder classes)
import 'package:app_fez_my/presentation/home/profile/pages/favorites_page.dart';
import 'package:app_fez_my/presentation/home/profile/pages/review_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'ar', 'name': 'العربية'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'de', 'name': 'Deutsch'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final selectedLanguage = languages.firstWhere(
          (lang) => lang['code'] == currentLocale.languageCode,
      orElse: () => languages[0],
    )['name']!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Fes Image
            Stack(
              children: [
                // Background Image
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://images.pexels.com/photos/22711547/pexels-photo-22711547.jpeg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                // Content
                Positioned(
                  top: 60,
                  left: currentLocale.languageCode == 'ar' ? null : 24,
                  right: currentLocale.languageCode == 'ar' ? 24 : null,
                  child: Column(
                    crossAxisAlignment: currentLocale.languageCode == 'ar'
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.fes,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        l10n.hello,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        l10n.welcome,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Menu Items
            _buildMenuItem(
              context: context,
              title: l10n.myFavorites,
              onTap: () {
                // ✅ Navigate to the actual FavoritesPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
            Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),

            _buildMenuItem(
              context: context,
              title: l10n.leaveReview,
              onTap: () {
                // ✅ Navigate to the actual ReviewPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewPage(),
                  ),
                );
              },
            ),
            Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),

            _buildMenuItem(
              context: context,
              title: l10n.shareApp,
              onTap: () => _shareApp(context),
            ),
            Divider(height: 1, thickness: 0.5, color: Colors.grey[300]),

            _buildMenuItem(
              context: context,
              title: l10n.language,
              subtitle: selectedLanguage,
              onTap: () => _showLanguageSelector(context),
            ),

            SizedBox(height: 40),

            // Version
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              color: Colors.grey[200],
              width: double.infinity,
              child: Center(
                child: Text(
                  l10n.version,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                        letterSpacing: 0.3,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareApp(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.shareTravelApp,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: QrImageView(
                    data: 'https://yourapp.com/download',
                    version: QrVersions.auto,
                    size: 160,
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  l10n.scanToDownload,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Share.share(
                        'Discover amazing places with our travel app! Download: https://yourapp.com/download',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.share, size: 18),
                        SizedBox(width: 8),
                        Text(
                          l10n.shareLink,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: 'https://yourapp.com/download'),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.linkCopied),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                    );
                  },
                  child: Text(
                    l10n.copyLink,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                l10n.selectLanguage,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
            ...languages.map((lang) => Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  MyApp.of(context)?.setLocale(Locale(lang['code']!));
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          lang['name']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            currentLocale.languageCode == lang['code']
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: currentLocale.languageCode == lang['code']
                                ? Color(0xFFFF6B35)
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                      if (currentLocale.languageCode == lang['code'])
                        Icon(
                          Icons.check,
                          color: Color(0xFFFF6B35),
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            )),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}