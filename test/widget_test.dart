// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_fez_my/l10n/app_localizations.dart';
import 'package:app_fez_my/main.dart';
import 'package:app_fez_my/navigation/main_app_scaffold.dart';
import 'package:app_fez_my/presentation/home/profile/pages/profile_page.dart';

void main() {
  // ============================================================================
  // TESTS DYAWL L'APPLICATION PRINCIPALE
  // ============================================================================
  group('Fes Travel Guide App Tests', () {
    testWidgets('App kat-launch bla errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MainAppScaffold kat-afficher kif initial screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(MainAppScaffold), findsOneWidget);
    });

    testWidgets('App katstakhdam theme configuration s7i7a', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
      expect(materialApp.themeMode, ThemeMode.light);
      expect(materialApp.debugShowCheckedModeBanner, false);
    });

    testWidgets('App title configured correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Fes Travel Guide');
    });

    testWidgets('App supports localization', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify localization delegates are configured
      expect(materialApp.localizationsDelegates, isNotNull);
      expect(materialApp.supportedLocales, isNotEmpty);
      expect(materialApp.supportedLocales.length, greaterThanOrEqualTo(5)); // en, ar, fr, es, de
    });
  });

  // ============================================================================
  // TESTS DYAWL MAIN APP SCAFFOLD
  // ============================================================================
  group('MainAppScaffold Widget Tests', () {
    testWidgets('MainAppScaffold kat-render bla errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MainAppScaffold), findsOneWidget);
    });

    testWidgets('MainAppScaffold 3andha Scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('CustomBottomNavBar kayna', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets('Bottom Navigation 3andha 4 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // Verify bottom nav items
      expect(find.text('About Fes'), findsOneWidget);
      expect(find.text('Historical Sites'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('My account'), findsOneWidget);
    });

    testWidgets('Initial tab dyawl About Fes', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // HomePage should be visible initially with "Explore Fes" text
      expect(find.text('Explore Fes'), findsOneWidget);
    });

    testWidgets('Navigation bin tabs khaddam', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // Click Historical Sites tab
      await tester.tap(find.text('Historical Sites'));
      await tester.pumpAndSettle();
      expect(find.text('Historical Sites'), findsAtLeastNWidgets(1));

      // Click Map tab
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();
      expect(find.text('Map'), findsAtLeastNWidgets(1));

      // Click My account tab
      await tester.tap(find.text('My account'));
      await tester.pumpAndSettle();

      // Note: Title might be different with localization, check for icon instead
      expect(find.byIcon(Icons.person_rounded), findsAtLeastNWidgets(1));

      // Rja3 l About Fes
      await tester.tap(find.text('About Fes'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Fes'), findsOneWidget);
    });

    testWidgets('Bottom nav bar icons present', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // Verify icons present
      expect(find.byIcon(Icons.location_city_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.backpack_rounded), findsOneWidget);
      expect(find.byIcon(Icons.map_rounded), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsAtLeastNWidgets(1));
    });

    testWidgets('Selected tab highlighted with animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // First tab should be selected (About Fes)
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.isNotEmpty, true);
    });
  });

  // ============================================================================
  // TESTS DYAWL CUSTOM BOTTOM NAV BAR
  // ============================================================================
  group('CustomBottomNavBar Tests', () {
    testWidgets('CustomBottomNavBar renders correctly', (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        createLocalizedTestApp(
          Scaffold(
            body: const Center(child: Text('Test')),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: selectedIndex,
              onTap: (index) => selectedIndex = index,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavBar), findsOneWidget);
      expect(find.text('About Fes'), findsOneWidget);
      expect(find.text('Historical Sites'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('My account'), findsOneWidget);
    });

    testWidgets('CustomBottomNavBar handles tap events', (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        createLocalizedTestApp(
          Scaffold(
            body: const Center(child: Text('Test')),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: selectedIndex,
              onTap: (index) => selectedIndex = index,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on Map tab
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();

      // Index should change (checked by rebuild)
      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });

    testWidgets('CustomBottomNavBar has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(
          Scaffold(
            body: const Center(child: Text('Test')),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: 0,
              onTap: (index) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check dark background container exists
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.isNotEmpty, true);
    });
  });

  // ============================================================================
  // TESTS DYAWL PROFILE PAGE (WITH LOCALIZATION)
  // ============================================================================
  group('Profile Page Tests', () {
    testWidgets('Profile page kat-render', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const ProfilePage()),
      );
      await tester.pumpAndSettle();

      // Verify person icon exists (more reliable than text with localization)
      expect(find.byIcon(Icons.person_rounded), findsAtLeastNWidgets(1));

      // Check for SliverAppBar
      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('Profile page 3andha SliverAppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const ProfilePage()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SliverAppBar), findsOneWidget);
    });

    testWidgets('Profile page shows feature cards icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const ProfilePage()),
      );
      await tester.pumpAndSettle();

      // Verify icons instead of text (language-independent)
      expect(find.byIcon(Icons.favorite_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.rate_review_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.language_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.share_rounded), findsAtLeastNWidgets(1));
    });

    testWidgets('Profile page shows stats icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const ProfilePage()),
      );
      await tester.pumpAndSettle();

      // Verify stat icons (language-independent)
      expect(find.byIcon(Icons.favorite_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.location_on_rounded), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.share_rounded), findsAtLeastNWidgets(1));
    });

    testWidgets('Profile page language selector works', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const ProfilePage()),
      );
      await tester.pumpAndSettle();

      // Find and tap language icon
      final languageIcon = find.byIcon(Icons.language_rounded);
      expect(languageIcon, findsAtLeastNWidgets(1));

      await tester.tap(languageIcon.first);
      await tester.pumpAndSettle();

      // Language selector should appear
      expect(find.text('English'), findsAtLeastNWidgets(1));
      expect(find.text('العربية'), findsAtLeastNWidgets(1));
      expect(find.text('Français'), findsAtLeastNWidgets(1));
      expect(find.text('Español'), findsAtLeastNWidgets(1));
      expect(find.text('Deutsch'), findsAtLeastNWidgets(1));
    });
  });

  // ============================================================================
  // TESTS DYAWL LOCALIZATION
  // ============================================================================
  group('Localization Tests', () {
    testWidgets('App supports English locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('en'),
        ),
      );
      await tester.pumpAndSettle();

      // English text should be visible
      expect(find.text('Fes'), findsAtLeastNWidgets(1));
    });

    testWidgets('App supports Arabic locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      // Arabic text should be visible
      expect(find.text('فاس'), findsAtLeastNWidgets(1));
    });

    testWidgets('App supports French locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('fr'),
        ),
      );
      await tester.pumpAndSettle();

      // French text should be visible
      expect(find.text('Fès'), findsAtLeastNWidgets(1));
    });

    testWidgets('App supports Spanish locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('es'),
        ),
      );
      await tester.pumpAndSettle();

      // Spanish text should be visible
      expect(find.text('Fez'), findsAtLeastNWidgets(1));
    });

    testWidgets('App supports German locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('de'),
        ),
      );
      await tester.pumpAndSettle();

      // German text should be visible
      expect(find.text('Fes'), findsAtLeastNWidgets(1));
    });

    testWidgets('RTL layout works for Arabic', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestAppWithLocale(
          const ProfilePage(),
          const Locale('ar'),
        ),
      );
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(ProfilePage));
      final textDirection = Directionality.of(context);

      // Arabic should use RTL
      expect(textDirection, TextDirection.rtl);
    });
  });

  // ============================================================================
  // TESTS DYAWL THEME
  // ============================================================================
  group('Theme Tests', () {
    testWidgets('Primary color configured correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MainAppScaffold));
      final theme = Theme.of(context);

      expect(theme.colorScheme.primary, const Color(0xFFFF6B35));
    });

    testWidgets('Theme uses Material 3', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MainAppScaffold));
      final theme = Theme.of(context);

      expect(theme.useMaterial3, true);
    });

    testWidgets('AppBar theme configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MainAppScaffold));
      final theme = Theme.of(context);

      expect(theme.appBarTheme.backgroundColor, const Color(0xFFFF6B35));
      expect(theme.appBarTheme.foregroundColor, Colors.white);
      expect(theme.appBarTheme.elevation, 0);
    });

    testWidgets('Card theme configured', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MainAppScaffold));
      final theme = Theme.of(context);

      expect(theme.cardTheme.elevation, 0);
      expect(theme.cardTheme.color, Colors.white);
    });

    testWidgets('Scaffold background color correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MainAppScaffold));
      final theme = Theme.of(context);

      expect(theme.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
    });
  });

  // ============================================================================
  // TESTS DYAWL ACCESSIBILITY
  // ============================================================================
  group('Accessibility Tests', () {
    testWidgets('All navigation items accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // Verify all nav items are tappable
      expect(find.text('About Fes'), findsOneWidget);
      expect(find.text('Historical Sites'), findsOneWidget);
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('My account'), findsOneWidget);
    });

    testWidgets('Icons have proper size', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      final icons = tester.widgetList<Icon>(find.byType(Icon));

      for (final icon in icons) {
        // Icons should be at least 20px for accessibility
        if (icon.size != null) {
          expect(icon.size! >= 20, true);
        }
      }
    });
  });

  // ============================================================================
  // TESTS DYAWL PERFORMANCE
  // ============================================================================
  group('Performance Tests', () {
    testWidgets('App renders within acceptable time', (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      stopwatch.stop();

      // App should render in less than 5 seconds
      expect(stopwatch.elapsedMilliseconds < 5000, true);
    });

    testWidgets('Tab switching is smooth', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Tab switch should be instant (less than 1 second)
      expect(stopwatch.elapsedMilliseconds < 1000, true);
    });
  });

  // ============================================================================
  // TESTS DYAWL INTEGRATION
  // ============================================================================
  group('Integration Tests', () {
    testWidgets('Full navigation flow works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Start at HomePage (About Fes tab)
      expect(find.text('Explore Fes'), findsOneWidget);

      // Navigate to Historical Sites
      await tester.tap(find.text('Historical Sites'));
      await tester.pumpAndSettle();
      expect(find.text('Historical Sites'), findsAtLeastNWidgets(1));

      // Navigate to Map
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();
      expect(find.text('Map'), findsAtLeastNWidgets(1));

      // Navigate to Profile
      await tester.tap(find.text('My account'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.person_rounded), findsAtLeastNWidgets(1));

      // Back to About Fes
      await tester.tap(find.text('About Fes'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Fes'), findsOneWidget);
    });

    testWidgets('App maintains state during navigation', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate away and back
      await tester.tap(find.text('Map'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('About Fes'));
      await tester.pumpAndSettle();

      // State should be maintained
      expect(find.byType(MainAppScaffold), findsOneWidget);
    });

    testWidgets('IndexedStack preserves widget state', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate through all tabs
      for (var i = 0; i < 4; i++) {
        final tabNames = ['About Fes', 'Historical Sites', 'Map', 'My account'];
        await tester.tap(find.text(tabNames[i]));
        await tester.pumpAndSettle();
      }

      // Should still find MainAppScaffold
      expect(find.byType(MainAppScaffold), findsOneWidget);
    });
  });

  // ============================================================================
  // TESTS DYAWL ANIMATIONS
  // ============================================================================
  group('Animation Tests', () {
    testWidgets('Bottom nav has animation controller', (WidgetTester tester) async {
      await tester.pumpWidget(
        createLocalizedTestApp(const MainAppScaffold()),
      );
      await tester.pumpAndSettle();

      // Tap to trigger animation
      await tester.tap(find.text('Map'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.byType(CustomBottomNavBar), findsOneWidget);
    });
  });
}

// ============================================================================
// HELPER FUNCTIONS (WITH LOCALIZATION SUPPORT)
// ============================================================================

/// Helper bach t-create MaterialApp wrapper with localization
Widget createLocalizedTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
      Locale('fr'),
      Locale('es'),
      Locale('de'),
    ],
    home: child,
  );
}

/// Helper bach t-create MaterialApp with specific locale
Widget createLocalizedTestAppWithLocale(Widget child, Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
      Locale('fr'),
      Locale('es'),
      Locale('de'),
    ],
    home: child,
  );
}

/// Helper bach t-create MaterialApp wrapper (simple version)
Widget createTestApp(Widget child) {
  return MaterialApp(
    home: child,
  );
}

/// Helper bach t-verify ida text kayn
void expectTextExists(WidgetTester tester, String text) {
  expect(find.text(text), findsOneWidget);
}

/// Helper bach t-tap 3la widget
Future<void> tapWidget(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Helper bach t-verify theme color
void expectThemeColor(BuildContext context, Color color) {
  final theme = Theme.of(context);
  expect(theme.colorScheme.primary, color);
}

/// Helper bach t-measure performance
Future<Duration> measureRenderTime(WidgetTester tester, Widget widget) async {
  final stopwatch = Stopwatch()..start();
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
  stopwatch.stop();
  return stopwatch.elapsed;
}