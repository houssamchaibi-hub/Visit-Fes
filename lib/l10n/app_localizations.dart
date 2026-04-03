import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
    Locale('es'),
    Locale('de')
  ];

  /// No description provided for @fes.
  ///
  /// In en, this message translates to:
  /// **'Fes'**
  String get fes;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @leaveReview.
  ///
  /// In en, this message translates to:
  /// **'Leave a Review'**
  String get leaveReview;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @shareTravelApp.
  ///
  /// In en, this message translates to:
  /// **'Share Travel App'**
  String get shareTravelApp;

  /// No description provided for @scanToDownload.
  ///
  /// In en, this message translates to:
  /// **'Scan to download the app'**
  String get scanToDownload;

  /// No description provided for @shareLink.
  ///
  /// In en, this message translates to:
  /// **'Share Link'**
  String get shareLink;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get linkCopied;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @babBouJeloud.
  ///
  /// In en, this message translates to:
  /// **'Bab Bou Jeloud'**
  String get babBouJeloud;

  /// No description provided for @fesLocation.
  ///
  /// In en, this message translates to:
  /// **'Fes, Morocco'**
  String get fesLocation;

  /// No description provided for @historicalGate.
  ///
  /// In en, this message translates to:
  /// **'Historical Gate'**
  String get historicalGate;

  /// No description provided for @alQarawiyyin.
  ///
  /// In en, this message translates to:
  /// **'Al-Qarawiyyin'**
  String get alQarawiyyin;

  /// No description provided for @mosqueUniversity.
  ///
  /// In en, this message translates to:
  /// **'Mosque & University'**
  String get mosqueUniversity;

  /// No description provided for @fesMedina.
  ///
  /// In en, this message translates to:
  /// **'Fes Medina'**
  String get fesMedina;

  /// No description provided for @unescoHeritage.
  ///
  /// In en, this message translates to:
  /// **'UNESCO Heritage'**
  String get unescoHeritage;

  /// No description provided for @chouaraTannery.
  ///
  /// In en, this message translates to:
  /// **'Chouara Tannery'**
  String get chouaraTannery;

  /// No description provided for @traditionalCraft.
  ///
  /// In en, this message translates to:
  /// **'Traditional Craft'**
  String get traditionalCraft;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get noFavoritesYet;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start exploring to add favorites'**
  String get startExploring;

  /// No description provided for @howWasExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasExperience;

  /// No description provided for @star.
  ///
  /// In en, this message translates to:
  /// **'star'**
  String get star;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'stars'**
  String get stars;

  /// No description provided for @yourReview.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get yourReview;

  /// No description provided for @tellUsExperience.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience...'**
  String get tellUsExperience;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @pleaseSelectRating.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating'**
  String get pleaseSelectRating;

  /// No description provided for @thankYouReview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get thankYouReview;

  /// No description provided for @historicalSites.
  ///
  /// In en, this message translates to:
  /// **'Historical Sites'**
  String get historicalSites;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'FILTER'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'SORT'**
  String get sort;

  /// No description provided for @filterSites.
  ///
  /// In en, this message translates to:
  /// **'Filter Sites'**
  String get filterSites;

  /// No description provided for @allSites.
  ///
  /// In en, this message translates to:
  /// **'All Sites'**
  String get allSites;

  /// No description provided for @mosques.
  ///
  /// In en, this message translates to:
  /// **'Mosques'**
  String get mosques;

  /// No description provided for @madrasas.
  ///
  /// In en, this message translates to:
  /// **'Madrasas'**
  String get madrasas;

  /// No description provided for @museums.
  ///
  /// In en, this message translates to:
  /// **'Museums'**
  String get museums;

  /// No description provided for @gatesWalls.
  ///
  /// In en, this message translates to:
  /// **'Gates & Walls'**
  String get gatesWalls;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @highestRated.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get highestRated;

  /// No description provided for @mostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get mostPopular;

  /// No description provided for @applySort.
  ///
  /// In en, this message translates to:
  /// **'Apply Sort'**
  String get applySort;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @visit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get visit;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @visitFes.
  ///
  /// In en, this message translates to:
  /// **'Visit Fes'**
  String get visitFes;

  /// No description provided for @culturalCapital.
  ///
  /// In en, this message translates to:
  /// **'Cultural Capital'**
  String get culturalCapital;

  /// No description provided for @generalInformation.
  ///
  /// In en, this message translates to:
  /// **'General\nInformation'**
  String get generalInformation;

  /// No description provided for @topAttractions.
  ///
  /// In en, this message translates to:
  /// **'Top Attractions'**
  String get topAttractions;

  /// No description provided for @gettingToFes.
  ///
  /// In en, this message translates to:
  /// **'Getting to\nFes'**
  String get gettingToFes;

  /// No description provided for @localTransport.
  ///
  /// In en, this message translates to:
  /// **'Local Transport'**
  String get localTransport;

  /// No description provided for @tasteOfFes.
  ///
  /// In en, this message translates to:
  /// **'Taste of Fes'**
  String get tasteOfFes;

  /// No description provided for @whatToBuy.
  ///
  /// In en, this message translates to:
  /// **'What to Buy in Fes'**
  String get whatToBuy;

  /// No description provided for @discoverFes.
  ///
  /// In en, this message translates to:
  /// **'Discover Fes'**
  String get discoverFes;

  /// No description provided for @videoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video unavailable'**
  String get videoUnavailable;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @era.
  ///
  /// In en, this message translates to:
  /// **'Era'**
  String get era;

  /// No description provided for @historyDescription.
  ///
  /// In en, this message translates to:
  /// **'History & Description'**
  String get historyDescription;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included'**
  String get whatsIncluded;

  /// No description provided for @importantInformation.
  ///
  /// In en, this message translates to:
  /// **'Important Information'**
  String get importantInformation;

  /// No description provided for @meetingPoint.
  ///
  /// In en, this message translates to:
  /// **'Meeting Point'**
  String get meetingPoint;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'Entrance'**
  String get entrance;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @bookingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Booking in progress...'**
  String get bookingInProgress;

  /// No description provided for @alQarawiyyinFull.
  ///
  /// In en, this message translates to:
  /// **'Al-Qarawiyyin Mosque & University'**
  String get alQarawiyyinFull;

  /// No description provided for @babBoujloudFull.
  ///
  /// In en, this message translates to:
  /// **'Bab Boujloud - Blue Gate'**
  String get babBoujloudFull;

  /// No description provided for @bouInaniaMadrasa.
  ///
  /// In en, this message translates to:
  /// **'Bou Inania Madrasa'**
  String get bouInaniaMadrasa;

  /// No description provided for @attarineMadrasa.
  ///
  /// In en, this message translates to:
  /// **'Attarine Madrasa'**
  String get attarineMadrasa;

  /// No description provided for @chouaraTanneryFull.
  ///
  /// In en, this message translates to:
  /// **'Chouara Tannery'**
  String get chouaraTanneryFull;

  /// No description provided for @nejjarineMuseum.
  ///
  /// In en, this message translates to:
  /// **'Nejjarine Museum of Wooden Arts'**
  String get nejjarineMuseum;

  /// No description provided for @darBathaMuseum.
  ///
  /// In en, this message translates to:
  /// **'Dar Batha Museum'**
  String get darBathaMuseum;

  /// No description provided for @merenidTombs.
  ///
  /// In en, this message translates to:
  /// **'Merenid Tombs'**
  String get merenidTombs;

  /// No description provided for @jnanSbilGarden.
  ///
  /// In en, this message translates to:
  /// **'Jnan Sbil Garden'**
  String get jnanSbilGarden;

  /// No description provided for @zawiyaMoulayIdriss.
  ///
  /// In en, this message translates to:
  /// **'Zawiya Moulay Idriss II'**
  String get zawiyaMoulayIdriss;

  /// No description provided for @zawiyaTijania.
  ///
  /// In en, this message translates to:
  /// **'Zawiya Tijania'**
  String get zawiyaTijania;

  /// No description provided for @royalPalace.
  ///
  /// In en, this message translates to:
  /// **'Royal Palace - Dar el-Makhzen'**
  String get royalPalace;

  /// No description provided for @andalusianMosque.
  ///
  /// In en, this message translates to:
  /// **'Andalusian Mosque'**
  String get andalusianMosque;

  /// No description provided for @alQarawiyyinDesc.
  ///
  /// In en, this message translates to:
  /// **'Fatima al-Fihri founded the world\'s oldest continuously operating university.'**
  String get alQarawiyyinDesc;

  /// No description provided for @babBoujloudDesc.
  ///
  /// In en, this message translates to:
  /// **'Built in 1913 under the French protectorate, Bab Boujloud has become the iconic entrance to the medina of Fes. With its stunning blue ceramics on the outside representing the color of Fes, and green on the inside symbolizing Islam, this monumental gate serves as the perfect introduction to the ancient city. The gate connects the modern ville nouvelle with the medieval medina, and is surrounded by cafes, restaurants, and the beginning of the main souks.'**
  String get babBoujloudDesc;

  /// No description provided for @bouInaniaDesc.
  ///
  /// In en, this message translates to:
  /// **'A masterpiece of Merinid architecture built between 1350 and 1357 by Sultan Abu Inan Faris. This madrasa is unique because it has a minaret and also served as a mosque. Its walls are adorned with colorful zellige tiles, finely carved stucco, and sculpted cedar wood. The building showcases the pinnacle of Islamic art and craftsmanship, with intricate geometric patterns and beautiful Arabic calligraphy covering every surface. Students once lived and studied here in small cells surrounding the central courtyard.'**
  String get bouInaniaDesc;

  /// No description provided for @attarineDesc.
  ///
  /// In en, this message translates to:
  /// **'Built in 1325 by the Merinid Sultan Uthman II Abu Said, the Attarine Madrasa is considered one of the finest examples of Moroccan Islamic architecture. Named after the Attarine souk (spice market) nearby, this former Quranic school features exquisite zellige mosaic tilework, carved cedar wood, and intricately decorated stucco. The central courtyard with its marble fountain creates a peaceful atmosphere that was perfect for religious studies. The upper floor offers beautiful views of the surrounding medina.'**
  String get attarineDesc;

  /// No description provided for @chouaraDesc.
  ///
  /// In en, this message translates to:
  /// **'The Chouara Tanneries are the oldest and largest tanneries in Fes, dating back to the 11th century. They remain one of the city\'s most iconic sights, where traditional leather processing methods unchanged for centuries are still in use today. The tannery features hundreds of stone vessels filled with various natural dyes and pigeon excrement used to soften the leather. Workers continue to use traditional techniques to produce high-quality Moroccan leather goods, creating a fascinating visual spectacle of colorful vats.'**
  String get chouaraDesc;

  /// No description provided for @nejjarineDesc.
  ///
  /// In en, this message translates to:
  /// **'Housed in a beautifully restored 18th-century fondouk (caravanserai) dating from 1711, the Nejjarine Museum showcases the rich tradition of Moroccan woodworking. The museum features an impressive collection of wooden artifacts including furniture, musical instruments, doors, and architectural elements. The building itself is a masterpiece, with its ornate fountain in the courtyard and intricately carved cedar wood throughout. The rooftop terrace offers spectacular views of the medina and is perfect for sunset.'**
  String get nejjarineDesc;

  /// No description provided for @darBathaDesc.
  ///
  /// In en, this message translates to:
  /// **'Built in 1897 as a royal palace during the reign of Sultan Hassan I, Dar Batha was converted into a museum in 1915. It houses one of Morocco\'s finest collections of traditional arts and crafts from Fes and surrounding regions. The museum features extensive displays of ceramics, embroidery, woodwork, manuscripts, carpets, and the famous Fes blue pottery. The beautiful Andalusian garden with its central fountain provides a peaceful retreat from the bustling medina.'**
  String get darBathaDesc;

  /// No description provided for @merenidDesc.
  ///
  /// In en, this message translates to:
  /// **'Perched on a hill overlooking Fes, the Merenid Tombs date from the 14th century and offer the most spectacular panoramic view of the entire medina. These royal burial sites housed members of the Merinid dynasty that ruled Morocco from 1244 to 1465. Although the tombs are now in ruins, the site remains an essential visit for its breathtaking views, especially at sunrise and sunset. The hilltop location provides a unique perspective to understand the layout and scale of the ancient medina below.'**
  String get merenidDesc;

  /// No description provided for @jnanSbilDesc.
  ///
  /// In en, this message translates to:
  /// **'Originally created in the 18th century and renovated in 1913, Jnan Sbil is Fes\'s main botanical garden and a peaceful oasis in the heart of the city. This 7.5-hectare garden features over 3,000 plant species, including many exotic and rare varieties. The garden is beautifully landscaped with palm-lined walkways, colorful flower beds, fountains, and a small lake. It provides a refreshing escape from the crowded medina, with plenty of shaded areas perfect for relaxation and picnics.'**
  String get jnanSbilDesc;

  /// No description provided for @zawiyaMoulayIdrissDesc.
  ///
  /// In en, this message translates to:
  /// **'Built in 828 AD and rebuilt in the 18th century, this is one of the holiest sites in Morocco, housing the tomb of Moulay Idriss II, founder of Fes and great-grandson of Prophet Muhammad. The zawiya (shrine) is an important pilgrimage site for Moroccan Muslims. The building features beautiful green-tiled pyramidal roof, intricate zellige work, and carved wood. While non-Muslims cannot enter the main shrine, the exterior and surrounding area showcase magnificent Moroccan religious architecture.'**
  String get zawiyaMoulayIdrissDesc;

  /// No description provided for @zawiyaTijaniaDesc.
  ///
  /// In en, this message translates to:
  /// **'The Zawiya Tijania is the spiritual center of the Tijaniyya Sufi order, founded in the 18th century by Sheikh Ahmad al-Tijani. This zawiya features impressive architecture with beautiful zellige tilework, carved stucco, and painted cedar ceilings. As one of the most important Sufi centers in North Africa, it continues to attract followers from across West Africa. The building complex includes a mosque, library, and educational facilities, representing an important center of Islamic learning and spirituality.'**
  String get zawiyaTijaniaDesc;

  /// No description provided for @royalPalaceDesc.
  ///
  /// In en, this message translates to:
  /// **'The Royal Palace of Fes, known as Dar el-Makhzen, is an impressive 80-hectare complex dating back to the 13th century during the Marinid dynasty. Although the palace interior is not open to the public as it remains an official royal residence, the magnificent golden gates (Bab Dekakene) are among the most photographed landmarks in Morocco. The massive brass doors, adorned with intricate geometric patterns and colorful zellige tilework, showcase the finest examples of traditional Moroccan craftsmanship. The palace grounds include beautiful gardens, madrasas, and the Mechouar (assembly grounds).'**
  String get royalPalaceDesc;

  /// No description provided for @andalusianMosqueDesc.
  ///
  /// In en, this message translates to:
  /// **'Built in 859 AD by Mariam al-Fihri (sister of Fatima al-Fihri who founded Al-Qarawiyyin), the Andalusian Mosque is one of the oldest and most significant mosques in Fes. Located in the Andalusian Quarter, this mosque served the Muslim refugees from Andalusia (Spain) who settled in Fes. The mosque features a beautiful minaret, stunning carved cedar doors, and magnificent zellige tilework. Its architectural style represents a blend of Moroccan and Andalusian influences. The fountain in the courtyard is an exquisite example of Islamic water architecture.'**
  String get andalusianMosqueDesc;

  /// No description provided for @defaultDesc.
  ///
  /// In en, this message translates to:
  /// **'Discover one of the most beautiful historical sites in Fes, a city that embodies more than a thousand years of Moroccan history. This exceptional monument testifies to Islamic art and architecture at its peak.'**
  String get defaultDesc;

  /// No description provided for @alQarawiyyinIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Guided tour by expert historian'**
  String get alQarawiyyinIncluded1;

  /// No description provided for @alQarawiyyinIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Access to the inner courtyard'**
  String get alQarawiyyinIncluded2;

  /// No description provided for @alQarawiyyinIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Detailed history of the university'**
  String get alQarawiyyinIncluded3;

  /// No description provided for @alQarawiyyinIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Explanations about Merinid architecture'**
  String get alQarawiyyinIncluded4;

  /// No description provided for @alQarawiyyinIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Visit to the ancient library (exterior)'**
  String get alQarawiyyinIncluded5;

  /// No description provided for @babBoujloudIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Unlimited photo opportunities'**
  String get babBoujloudIncluded1;

  /// No description provided for @babBoujloudIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Historical context and stories'**
  String get babBoujloudIncluded2;

  /// No description provided for @babBoujloudIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Free access at all times'**
  String get babBoujloudIncluded3;

  /// No description provided for @babBoujloudIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Starting point for medina tours'**
  String get babBoujloudIncluded4;

  /// No description provided for @babBoujloudIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Nearby cafe recommendations'**
  String get babBoujloudIncluded5;

  /// No description provided for @defaultIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Professional guide'**
  String get defaultIncluded1;

  /// No description provided for @defaultIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Monument entrance'**
  String get defaultIncluded2;

  /// No description provided for @defaultIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Historical explanations'**
  String get defaultIncluded3;

  /// No description provided for @defaultIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Mint tea'**
  String get defaultIncluded4;

  /// No description provided for @alQarawiyyinInfo1.
  ///
  /// In en, this message translates to:
  /// **'Respectful dress code required'**
  String get alQarawiyyinInfo1;

  /// No description provided for @alQarawiyyinInfo2.
  ///
  /// In en, this message translates to:
  /// **'Non-Muslims cannot enter prayer hall'**
  String get alQarawiyyinInfo2;

  /// No description provided for @alQarawiyyinInfo3.
  ///
  /// In en, this message translates to:
  /// **'Photos limited to certain areas'**
  String get alQarawiyyinInfo3;

  /// No description provided for @alQarawiyyinInfo4.
  ///
  /// In en, this message translates to:
  /// **'Guided tour mandatory for non-Muslims'**
  String get alQarawiyyinInfo4;

  /// No description provided for @babBoujloudInfo1.
  ///
  /// In en, this message translates to:
  /// **'Very crowded tourist area'**
  String get babBoujloudInfo1;

  /// No description provided for @babBoujloudInfo2.
  ///
  /// In en, this message translates to:
  /// **'Beware of unofficial guides'**
  String get babBoujloudInfo2;

  /// No description provided for @babBoujloudInfo3.
  ///
  /// In en, this message translates to:
  /// **'Many restaurants and cafes nearby'**
  String get babBoujloudInfo3;

  /// No description provided for @babBoujloudInfo4.
  ///
  /// In en, this message translates to:
  /// **'Best photos in morning light'**
  String get babBoujloudInfo4;

  /// No description provided for @defaultInfo1.
  ///
  /// In en, this message translates to:
  /// **'Appropriate clothing recommended'**
  String get defaultInfo1;

  /// No description provided for @defaultInfo2.
  ///
  /// In en, this message translates to:
  /// **'Sun protection advised'**
  String get defaultInfo2;

  /// No description provided for @defaultInfo3.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation up to 24 hours'**
  String get defaultInfo3;

  /// No description provided for @alQarawiyyinMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Place Seffarine'**
  String get alQarawiyyinMeetingLocation;

  /// No description provided for @alQarawiyyinMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Next to the historic fountain'**
  String get alQarawiyyinMeetingDesc;

  /// No description provided for @babBoujloudMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'At Bab Boujloud Gate'**
  String get babBoujloudMeetingLocation;

  /// No description provided for @babBoujloudMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Exterior side (blue facade)'**
  String get babBoujloudMeetingDesc;

  /// No description provided for @defaultMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Bab Boujloud'**
  String get defaultMeetingLocation;

  /// No description provided for @defaultMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Main entrance to Fes el-Bali'**
  String get defaultMeetingDesc;

  /// No description provided for @authenticMoroccanDishes.
  ///
  /// In en, this message translates to:
  /// **'Authentic traditional Moroccan dishes'**
  String get authenticMoroccanDishes;

  /// No description provided for @searchDishes.
  ///
  /// In en, this message translates to:
  /// **'Search dishes...'**
  String get searchDishes;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @mainCourse.
  ///
  /// In en, this message translates to:
  /// **'Main Course'**
  String get mainCourse;

  /// No description provided for @soup.
  ///
  /// In en, this message translates to:
  /// **'Soup'**
  String get soup;

  /// No description provided for @dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get dessert;

  /// No description provided for @bread.
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get bread;

  /// No description provided for @appetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get appetizer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get found;

  /// No description provided for @dish.
  ///
  /// In en, this message translates to:
  /// **'dish'**
  String get dish;

  /// No description provided for @dishes.
  ///
  /// In en, this message translates to:
  /// **'dishes'**
  String get dishes;

  /// No description provided for @noDishesFound.
  ///
  /// In en, this message translates to:
  /// **'No dishes found'**
  String get noDishesFound;

  /// No description provided for @myCart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get myCart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// Product added to cart message
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String addedToCart(String name);

  /// No description provided for @startingFrom.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get startingFrom;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get order;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'CHECKOUT'**
  String get checkout;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @oopsSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsSomethingWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @tagineDesc.
  ///
  /// In en, this message translates to:
  /// **'A slow-cooked savory stew, braised at low temperatures in a traditional earthenware pot'**
  String get tagineDesc;

  /// No description provided for @couscousDesc.
  ///
  /// In en, this message translates to:
  /// **'Steamed semolina grains served with vegetables and meat, a Friday family tradition'**
  String get couscousDesc;

  /// No description provided for @pastillaDesc.
  ///
  /// In en, this message translates to:
  /// **'Delicate phyllo pastry filled with spiced pigeon or chicken, almonds, and dusted with cinnamon'**
  String get pastillaDesc;

  /// No description provided for @seffaDesc.
  ///
  /// In en, this message translates to:
  /// **'Sweet vermicelli or couscous topped with cinnamon, sugar, and toasted almonds'**
  String get seffaDesc;

  /// No description provided for @hariraDesc.
  ///
  /// In en, this message translates to:
  /// **'Hearty tomato-based soup with lentils, chickpeas, and meat, traditionally served during Ramadan'**
  String get hariraDesc;

  /// No description provided for @rfissaDesc.
  ///
  /// In en, this message translates to:
  /// **'Shredded msemen layered with tender chicken in a rich, spiced fenugreek sauce'**
  String get rfissaDesc;

  /// No description provided for @tagine.
  ///
  /// In en, this message translates to:
  /// **'Tagine'**
  String get tagine;

  /// No description provided for @tagineAr.
  ///
  /// In en, this message translates to:
  /// **'الطاجين'**
  String get tagineAr;

  /// No description provided for @couscous.
  ///
  /// In en, this message translates to:
  /// **'Couscous'**
  String get couscous;

  /// No description provided for @couscousAr.
  ///
  /// In en, this message translates to:
  /// **'الكسكس'**
  String get couscousAr;

  /// No description provided for @pastilla.
  ///
  /// In en, this message translates to:
  /// **'Pastilla'**
  String get pastilla;

  /// No description provided for @pastillaAr.
  ///
  /// In en, this message translates to:
  /// **'البسطيلة'**
  String get pastillaAr;

  /// No description provided for @seffa.
  ///
  /// In en, this message translates to:
  /// **'Seffa'**
  String get seffa;

  /// No description provided for @seffaAr.
  ///
  /// In en, this message translates to:
  /// **'السفة'**
  String get seffaAr;

  /// No description provided for @harira.
  ///
  /// In en, this message translates to:
  /// **'Harira'**
  String get harira;

  /// No description provided for @hariraAr.
  ///
  /// In en, this message translates to:
  /// **'الحريرة'**
  String get hariraAr;

  /// No description provided for @rfissa.
  ///
  /// In en, this message translates to:
  /// **'Rfissa'**
  String get rfissa;

  /// No description provided for @rfissaAr.
  ///
  /// In en, this message translates to:
  /// **'الرفيسة'**
  String get rfissaAr;

  /// No description provided for @tagineVariation1.
  ///
  /// In en, this message translates to:
  /// **'Lamb with Prunes'**
  String get tagineVariation1;

  /// No description provided for @tagineVariation2.
  ///
  /// In en, this message translates to:
  /// **'Chicken with Preserved Lemons'**
  String get tagineVariation2;

  /// No description provided for @tagineVariation3.
  ///
  /// In en, this message translates to:
  /// **'Beef with Vegetables'**
  String get tagineVariation3;

  /// No description provided for @tagineVariation4.
  ///
  /// In en, this message translates to:
  /// **'Kefta Tagine'**
  String get tagineVariation4;

  /// No description provided for @couscousVariation1.
  ///
  /// In en, this message translates to:
  /// **'Seven Vegetables'**
  String get couscousVariation1;

  /// No description provided for @couscousVariation2.
  ///
  /// In en, this message translates to:
  /// **'Tfaya (with caramelized onions)'**
  String get couscousVariation2;

  /// No description provided for @couscousVariation3.
  ///
  /// In en, this message translates to:
  /// **'Berber Couscous'**
  String get couscousVariation3;

  /// No description provided for @couscousVariation4.
  ///
  /// In en, this message translates to:
  /// **'Fish Couscous'**
  String get couscousVariation4;

  /// No description provided for @pastillaVariation1.
  ///
  /// In en, this message translates to:
  /// **'Pigeon Pastilla'**
  String get pastillaVariation1;

  /// No description provided for @pastillaVariation2.
  ///
  /// In en, this message translates to:
  /// **'Chicken Pastilla'**
  String get pastillaVariation2;

  /// No description provided for @pastillaVariation3.
  ///
  /// In en, this message translates to:
  /// **'Seafood Pastilla'**
  String get pastillaVariation3;

  /// No description provided for @pastillaVariation4.
  ///
  /// In en, this message translates to:
  /// **'Sweet Milk Pastilla'**
  String get pastillaVariation4;

  /// No description provided for @seffaVariation1.
  ///
  /// In en, this message translates to:
  /// **'Seffa Medfouna'**
  String get seffaVariation1;

  /// No description provided for @seffaVariation2.
  ///
  /// In en, this message translates to:
  /// **'Seffa with Raisins'**
  String get seffaVariation2;

  /// No description provided for @seffaVariation3.
  ///
  /// In en, this message translates to:
  /// **'Seffa with Dates'**
  String get seffaVariation3;

  /// No description provided for @seffaVariation4.
  ///
  /// In en, this message translates to:
  /// **'Couscous Seffa'**
  String get seffaVariation4;

  /// No description provided for @hariraVariation1.
  ///
  /// In en, this message translates to:
  /// **'Traditional Harira'**
  String get hariraVariation1;

  /// No description provided for @hariraVariation2.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian Harira'**
  String get hariraVariation2;

  /// No description provided for @hariraVariation3.
  ///
  /// In en, this message translates to:
  /// **'Fassi Harira'**
  String get hariraVariation3;

  /// No description provided for @hariraVariation4.
  ///
  /// In en, this message translates to:
  /// **'Harira with Tadouira'**
  String get hariraVariation4;

  /// No description provided for @rfissaVariation1.
  ///
  /// In en, this message translates to:
  /// **'Traditional Rfissa'**
  String get rfissaVariation1;

  /// No description provided for @rfissaVariation2.
  ///
  /// In en, this message translates to:
  /// **'Rfissa with Lentils'**
  String get rfissaVariation2;

  /// No description provided for @rfissaVariation3.
  ///
  /// In en, this message translates to:
  /// **'Berber Rfissa'**
  String get rfissaVariation3;

  /// No description provided for @rfissaVariation4.
  ///
  /// In en, this message translates to:
  /// **'Quick Rfissa'**
  String get rfissaVariation4;

  /// No description provided for @tagineIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Meat or chicken'**
  String get tagineIngredient1;

  /// No description provided for @tagineIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Onions'**
  String get tagineIngredient2;

  /// No description provided for @tagineIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Garlic'**
  String get tagineIngredient3;

  /// No description provided for @tagineIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Spices'**
  String get tagineIngredient4;

  /// No description provided for @tagineIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get tagineIngredient5;

  /// No description provided for @tagineIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get tagineIngredient6;

  /// No description provided for @tagineIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Preserved lemons'**
  String get tagineIngredient7;

  /// No description provided for @couscousIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Couscous grains'**
  String get couscousIngredient1;

  /// No description provided for @couscousIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Mixed vegetables'**
  String get couscousIngredient2;

  /// No description provided for @couscousIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Lamb or chicken'**
  String get couscousIngredient3;

  /// No description provided for @couscousIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
  String get couscousIngredient4;

  /// No description provided for @couscousIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Ras el hanout'**
  String get couscousIngredient5;

  /// No description provided for @couscousIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get couscousIngredient6;

  /// No description provided for @couscousIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get couscousIngredient7;

  /// No description provided for @pastillaIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Warqa pastry'**
  String get pastillaIngredient1;

  /// No description provided for @pastillaIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Pigeon/chicken'**
  String get pastillaIngredient2;

  /// No description provided for @pastillaIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Almonds'**
  String get pastillaIngredient3;

  /// No description provided for @pastillaIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get pastillaIngredient4;

  /// No description provided for @pastillaIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get pastillaIngredient5;

  /// No description provided for @pastillaIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get pastillaIngredient6;

  /// No description provided for @pastillaIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Orange blossom water'**
  String get pastillaIngredient7;

  /// No description provided for @pastillaIngredient8.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get pastillaIngredient8;

  /// No description provided for @seffaIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Vermicelli or couscous'**
  String get seffaIngredient1;

  /// No description provided for @seffaIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Butter'**
  String get seffaIngredient2;

  /// No description provided for @seffaIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get seffaIngredient3;

  /// No description provided for @seffaIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Powdered sugar'**
  String get seffaIngredient4;

  /// No description provided for @seffaIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Almonds'**
  String get seffaIngredient5;

  /// No description provided for @seffaIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Raisins'**
  String get seffaIngredient6;

  /// No description provided for @seffaIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Orange blossom water'**
  String get seffaIngredient7;

  /// No description provided for @hariraIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Lentils'**
  String get hariraIngredient1;

  /// No description provided for @hariraIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Chickpeas'**
  String get hariraIngredient2;

  /// No description provided for @hariraIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Tomatoes'**
  String get hariraIngredient3;

  /// No description provided for @hariraIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Lamb/beef'**
  String get hariraIngredient4;

  /// No description provided for @hariraIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Onions'**
  String get hariraIngredient5;

  /// No description provided for @hariraIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Celery'**
  String get hariraIngredient6;

  /// No description provided for @hariraIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Coriander'**
  String get hariraIngredient7;

  /// No description provided for @hariraIngredient8.
  ///
  /// In en, this message translates to:
  /// **'Flour'**
  String get hariraIngredient8;

  /// No description provided for @hariraIngredient9.
  ///
  /// In en, this message translates to:
  /// **'Spices'**
  String get hariraIngredient9;

  /// No description provided for @rfissaIngredient1.
  ///
  /// In en, this message translates to:
  /// **'Msemen or trid'**
  String get rfissaIngredient1;

  /// No description provided for @rfissaIngredient2.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get rfissaIngredient2;

  /// No description provided for @rfissaIngredient3.
  ///
  /// In en, this message translates to:
  /// **'Lentils'**
  String get rfissaIngredient3;

  /// No description provided for @rfissaIngredient4.
  ///
  /// In en, this message translates to:
  /// **'Fenugreek'**
  String get rfissaIngredient4;

  /// No description provided for @rfissaIngredient5.
  ///
  /// In en, this message translates to:
  /// **'Onions'**
  String get rfissaIngredient5;

  /// No description provided for @rfissaIngredient6.
  ///
  /// In en, this message translates to:
  /// **'Ras el hanout'**
  String get rfissaIngredient6;

  /// No description provided for @rfissaIngredient7.
  ///
  /// In en, this message translates to:
  /// **'Saffron'**
  String get rfissaIngredient7;

  /// No description provided for @rfissaIngredient8.
  ///
  /// In en, this message translates to:
  /// **'Olive oil'**
  String get rfissaIngredient8;

  /// No description provided for @prepTime.
  ///
  /// In en, this message translates to:
  /// **'Prep Time'**
  String get prepTime;

  /// No description provided for @cookTime.
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get cookTime;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @cuisine.
  ///
  /// In en, this message translates to:
  /// **'Cuisine'**
  String get cuisine;

  /// No description provided for @moroccan.
  ///
  /// In en, this message translates to:
  /// **'Moroccan'**
  String get moroccan;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @variations.
  ///
  /// In en, this message translates to:
  /// **'Variations'**
  String get variations;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyEasyMedium.
  ///
  /// In en, this message translates to:
  /// **'Easy-Medium'**
  String get difficultyEasyMedium;

  /// No description provided for @difficultyMediumHard.
  ///
  /// In en, this message translates to:
  /// **'Medium-Hard'**
  String get difficultyMediumHard;

  /// No description provided for @aboutFes.
  ///
  /// In en, this message translates to:
  /// **'About Fes'**
  String get aboutFes;

  /// No description provided for @discoverFesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Fes'**
  String get discoverFesTitle;

  /// No description provided for @moroccoSpiritualCapital.
  ///
  /// In en, this message translates to:
  /// **'Morocco\'s Spiritual Capital'**
  String get moroccoSpiritualCapital;

  /// No description provided for @aboutFesIntro.
  ///
  /// In en, this message translates to:
  /// **'Founded in 789 AD by Idris I, Fes stands as one of the world\'s oldest continuously inhabited medieval cities. Home to the prestigious University of Al Qaraouiyine—the oldest existing educational institution globally—Fes remains the beating heart of Moroccan tradition and Islamic scholarship.'**
  String get aboutFesIntro;

  /// No description provided for @unescoWorldHeritageSite.
  ///
  /// In en, this message translates to:
  /// **'UNESCO World Heritage Site'**
  String get unescoWorldHeritageSite;

  /// No description provided for @medinaOfFesBali.
  ///
  /// In en, this message translates to:
  /// **'Medina of Fes el-Bali'**
  String get medinaOfFesBali;

  /// No description provided for @historicalTimeline.
  ///
  /// In en, this message translates to:
  /// **'Historical Timeline'**
  String get historicalTimeline;

  /// No description provided for @foundationOfFes.
  ///
  /// In en, this message translates to:
  /// **'Foundation of Fes'**
  String get foundationOfFes;

  /// No description provided for @foundationDesc.
  ///
  /// In en, this message translates to:
  /// **'Founded by Idris I, establishing the first Islamic dynasty in Morocco.'**
  String get foundationDesc;

  /// No description provided for @alQarawiyyinUniversity.
  ///
  /// In en, this message translates to:
  /// **'Al-Qarawiyyin University'**
  String get alQarawiyyinUniversity;

  /// No description provided for @fesElJdid.
  ///
  /// In en, this message translates to:
  /// **'Fes el-Jdid'**
  String get fesElJdid;

  /// No description provided for @fesElJdidDesc.
  ///
  /// In en, this message translates to:
  /// **'The Marinid dynasty built the \"New Fes\" including the Royal Palace.'**
  String get fesElJdidDesc;

  /// No description provided for @unescoRecognition.
  ///
  /// In en, this message translates to:
  /// **'UNESCO Recognition'**
  String get unescoRecognition;

  /// No description provided for @unescoRecognitionDesc.
  ///
  /// In en, this message translates to:
  /// **'Medina of Fes designated as a UNESCO World Heritage Site.'**
  String get unescoRecognitionDesc;

  /// No description provided for @presentDay.
  ///
  /// In en, this message translates to:
  /// **'Present Day'**
  String get presentDay;

  /// No description provided for @culturalCapitalDesc.
  ///
  /// In en, this message translates to:
  /// **'Fes continues to be Morocco\'s spiritual and artisanal center with over 1.1 million inhabitants.'**
  String get culturalCapitalDesc;

  /// No description provided for @factsAndFigures.
  ///
  /// In en, this message translates to:
  /// **'Facts & Figures'**
  String get factsAndFigures;

  /// No description provided for @yearFounded.
  ///
  /// In en, this message translates to:
  /// **'Year Founded'**
  String get yearFounded;

  /// No description provided for @population.
  ///
  /// In en, this message translates to:
  /// **'Population'**
  String get population;

  /// No description provided for @streets.
  ///
  /// In en, this message translates to:
  /// **'Streets'**
  String get streets;

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'Years Old'**
  String get yearsOld;

  /// No description provided for @mustVisitPlaces.
  ///
  /// In en, this message translates to:
  /// **'Must-Visit Places'**
  String get mustVisitPlaces;

  /// No description provided for @babBoujloudShort.
  ///
  /// In en, this message translates to:
  /// **'Bab Boujloud'**
  String get babBoujloudShort;

  /// No description provided for @babBoujloudShortDesc.
  ///
  /// In en, this message translates to:
  /// **'The iconic blue gate and main entrance to the old medina.'**
  String get babBoujloudShortDesc;

  /// No description provided for @chouaraTanneryShort.
  ///
  /// In en, this message translates to:
  /// **'Chouara Tannery'**
  String get chouaraTanneryShort;

  /// No description provided for @chouaraTanneryShortDesc.
  ///
  /// In en, this message translates to:
  /// **'Ancient leather tanneries with traditional dyeing methods.'**
  String get chouaraTanneryShortDesc;

  /// No description provided for @alQarawiyyinMosqueShort.
  ///
  /// In en, this message translates to:
  /// **'Al-Qarawiyyin Mosque'**
  String get alQarawiyyinMosqueShort;

  /// No description provided for @alQarawiyyinMosqueShortDesc.
  ///
  /// In en, this message translates to:
  /// **'One of the largest mosques in Africa and oldest university.'**
  String get alQarawiyyinMosqueShortDesc;

  /// No description provided for @bouInaniaMadrasaShort.
  ///
  /// In en, this message translates to:
  /// **'Bou Inania Madrasa'**
  String get bouInaniaMadrasaShort;

  /// No description provided for @bouInaniaMadrasaShortDesc.
  ///
  /// In en, this message translates to:
  /// **'Stunning 14th-century Islamic school with intricate architecture.'**
  String get bouInaniaMadrasaShortDesc;

  /// No description provided for @royalPalaceShort.
  ///
  /// In en, this message translates to:
  /// **'Royal Palace'**
  String get royalPalaceShort;

  /// No description provided for @royalPalaceShortDesc.
  ///
  /// In en, this message translates to:
  /// **'Beautiful golden gates and impressive Moroccan architecture.'**
  String get royalPalaceShortDesc;

  /// No description provided for @culturalSignificance.
  ///
  /// In en, this message translates to:
  /// **'Cultural Significance'**
  String get culturalSignificance;

  /// No description provided for @whyFesMatters.
  ///
  /// In en, this message translates to:
  /// **'Why Fes Matters'**
  String get whyFesMatters;

  /// No description provided for @educationalHeritage.
  ///
  /// In en, this message translates to:
  /// **'Educational Heritage'**
  String get educationalHeritage;

  /// No description provided for @educationalHeritageDesc.
  ///
  /// In en, this message translates to:
  /// **'Home to the world\'s oldest university, established in 859 AD.'**
  String get educationalHeritageDesc;

  /// No description provided for @artisanExcellence.
  ///
  /// In en, this message translates to:
  /// **'Artisan Excellence'**
  String get artisanExcellence;

  /// No description provided for @artisanExcellenceDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional crafts passed down through generations for centuries.'**
  String get artisanExcellenceDesc;

  /// No description provided for @spiritualCenter.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Center'**
  String get spiritualCenter;

  /// No description provided for @spiritualCenterDesc.
  ///
  /// In en, this message translates to:
  /// **'A major pilgrimage site and center of Islamic learning in North Africa.'**
  String get spiritualCenterDesc;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {userName}!'**
  String hiUser(Object userName);

  /// No description provided for @discoverBeauty.
  ///
  /// In en, this message translates to:
  /// **'Discover the beauty of Morocco\'s\ncultural capital'**
  String get discoverBeauty;

  /// No description provided for @transportByPlane.
  ///
  /// In en, this message translates to:
  /// **'By Plane'**
  String get transportByPlane;

  /// No description provided for @transportByPlaneAr.
  ///
  /// In en, this message translates to:
  /// **'بالطائرة'**
  String get transportByPlaneAr;

  /// No description provided for @transportByTrain.
  ///
  /// In en, this message translates to:
  /// **'By Train'**
  String get transportByTrain;

  /// No description provided for @transportByTrainAr.
  ///
  /// In en, this message translates to:
  /// **'بالقطار'**
  String get transportByTrainAr;

  /// No description provided for @transportByBus.
  ///
  /// In en, this message translates to:
  /// **'By Bus'**
  String get transportByBus;

  /// No description provided for @transportByBusAr.
  ///
  /// In en, this message translates to:
  /// **'بالحافلة'**
  String get transportByBusAr;

  /// No description provided for @transportByCar.
  ///
  /// In en, this message translates to:
  /// **'By Car (Rental)'**
  String get transportByCar;

  /// No description provided for @transportByCarAr.
  ///
  /// In en, this message translates to:
  /// **'بالسيارة (مستأجرة)'**
  String get transportByCarAr;

  /// No description provided for @transportByTaxi.
  ///
  /// In en, this message translates to:
  /// **'Grand Taxi'**
  String get transportByTaxi;

  /// No description provided for @transportByTaxiAr.
  ///
  /// In en, this message translates to:
  /// **'طاكسي كبير'**
  String get transportByTaxiAr;

  /// No description provided for @transportPlaneDesc.
  ///
  /// In en, this message translates to:
  /// **'Fastest way to reach Fes. Fes-Saiss Airport (FEZ) receives regular domestic and international flights.'**
  String get transportPlaneDesc;

  /// No description provided for @transportTrainDesc.
  ///
  /// In en, this message translates to:
  /// **'ONCF operates modern, comfortable trains connecting Fes to major Moroccan cities with scenic routes.'**
  String get transportTrainDesc;

  /// No description provided for @transportBusDesc.
  ///
  /// In en, this message translates to:
  /// **'Budget-friendly option with extensive network. CTM and Supratours offer comfortable intercity services.'**
  String get transportBusDesc;

  /// No description provided for @transportCarDesc.
  ///
  /// In en, this message translates to:
  /// **'Drive yourself and explore at your own pace. Major rental companies available at airports and cities.'**
  String get transportCarDesc;

  /// No description provided for @transportTaxiDesc.
  ///
  /// In en, this message translates to:
  /// **'Shared grand taxis for shorter routes. Wait until full (6 passengers) before departing.'**
  String get transportTaxiDesc;

  /// No description provided for @variesByOrigin.
  ///
  /// In en, this message translates to:
  /// **'Varies by origin'**
  String get variesByOrigin;

  /// No description provided for @fastestOption.
  ///
  /// In en, this message translates to:
  /// **'Fastest travel option'**
  String get fastestOption;

  /// No description provided for @directFlights.
  ///
  /// In en, this message translates to:
  /// **'Direct flights available'**
  String get directFlights;

  /// No description provided for @comfortableReliable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable and reliable'**
  String get comfortableReliable;

  /// No description provided for @airportCloseToCity.
  ///
  /// In en, this message translates to:
  /// **'Airport close to city center'**
  String get airportCloseToCity;

  /// No description provided for @moreExpensive.
  ///
  /// In en, this message translates to:
  /// **'More expensive than other options'**
  String get moreExpensive;

  /// No description provided for @limitedFlightFrequency.
  ///
  /// In en, this message translates to:
  /// **'Limited flight frequency'**
  String get limitedFlightFrequency;

  /// No description provided for @requiresAdvanceBooking.
  ///
  /// In en, this message translates to:
  /// **'Requires advance booking'**
  String get requiresAdvanceBooking;

  /// No description provided for @additionalTransferCosts.
  ///
  /// In en, this message translates to:
  /// **'Additional transfer costs from airport'**
  String get additionalTransferCosts;

  /// No description provided for @comfortableSpacious.
  ///
  /// In en, this message translates to:
  /// **'Comfortable and spacious'**
  String get comfortableSpacious;

  /// No description provided for @scenicRoutes.
  ///
  /// In en, this message translates to:
  /// **'Scenic routes through countryside'**
  String get scenicRoutes;

  /// No description provided for @reliableSchedule.
  ///
  /// In en, this message translates to:
  /// **'Reliable schedule'**
  String get reliableSchedule;

  /// No description provided for @affordablePricing.
  ///
  /// In en, this message translates to:
  /// **'Affordable pricing'**
  String get affordablePricing;

  /// No description provided for @centralStationLocation.
  ///
  /// In en, this message translates to:
  /// **'Central station location'**
  String get centralStationLocation;

  /// No description provided for @airConditionedCarriages.
  ///
  /// In en, this message translates to:
  /// **'Air-conditioned carriages'**
  String get airConditionedCarriages;

  /// No description provided for @slowerThanFlying.
  ///
  /// In en, this message translates to:
  /// **'Slower than flying'**
  String get slowerThanFlying;

  /// No description provided for @limitedRoutes.
  ///
  /// In en, this message translates to:
  /// **'Limited routes'**
  String get limitedRoutes;

  /// No description provided for @crowdedDuringHolidays.
  ///
  /// In en, this message translates to:
  /// **'Can be crowded during holidays'**
  String get crowdedDuringHolidays;

  /// No description provided for @firstClassFillsQuickly.
  ///
  /// In en, this message translates to:
  /// **'First class fills quickly'**
  String get firstClassFillsQuickly;

  /// No description provided for @mostEconomical.
  ///
  /// In en, this message translates to:
  /// **'Most economical option'**
  String get mostEconomical;

  /// No description provided for @extensiveNetwork.
  ///
  /// In en, this message translates to:
  /// **'Extensive network'**
  String get extensiveNetwork;

  /// No description provided for @frequentDepartures.
  ///
  /// In en, this message translates to:
  /// **'Frequent departures'**
  String get frequentDepartures;

  /// No description provided for @directRoutesToManyCities.
  ///
  /// In en, this message translates to:
  /// **'Direct routes to many cities'**
  String get directRoutesToManyCities;

  /// No description provided for @goodForBudget.
  ///
  /// In en, this message translates to:
  /// **'Good for budget travelers'**
  String get goodForBudget;

  /// No description provided for @longerTravelTime.
  ///
  /// In en, this message translates to:
  /// **'Longer travel time'**
  String get longerTravelTime;

  /// No description provided for @lessComfortableThanTrain.
  ///
  /// In en, this message translates to:
  /// **'Less comfortable than train'**
  String get lessComfortableThanTrain;

  /// No description provided for @canBeCrowded.
  ///
  /// In en, this message translates to:
  /// **'Can be crowded'**
  String get canBeCrowded;

  /// No description provided for @limitedLegroom.
  ///
  /// In en, this message translates to:
  /// **'Limited legroom'**
  String get limitedLegroom;

  /// No description provided for @stopsAlongWay.
  ///
  /// In en, this message translates to:
  /// **'Stops along the way'**
  String get stopsAlongWay;

  /// No description provided for @completeFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Complete flexibility'**
  String get completeFlexibility;

  /// No description provided for @stopAtAttractions.
  ///
  /// In en, this message translates to:
  /// **'Stop at attractions en route'**
  String get stopAtAttractions;

  /// No description provided for @goodForGroups.
  ///
  /// In en, this message translates to:
  /// **'Good for groups/families'**
  String get goodForGroups;

  /// No description provided for @exploreSurroundingAreas.
  ///
  /// In en, this message translates to:
  /// **'Explore surrounding areas'**
  String get exploreSurroundingAreas;

  /// No description provided for @carryMoreLuggage.
  ///
  /// In en, this message translates to:
  /// **'Carry more luggage'**
  String get carryMoreLuggage;

  /// No description provided for @drivingCanBeChallenging.
  ///
  /// In en, this message translates to:
  /// **'Driving can be challenging'**
  String get drivingCanBeChallenging;

  /// No description provided for @parkingDifficult.
  ///
  /// In en, this message translates to:
  /// **'Parking difficult in medina'**
  String get parkingDifficult;

  /// No description provided for @tollRoadsAddCost.
  ///
  /// In en, this message translates to:
  /// **'Toll roads add to cost'**
  String get tollRoadsAddCost;

  /// No description provided for @fuelCosts.
  ///
  /// In en, this message translates to:
  /// **'Fuel costs'**
  String get fuelCosts;

  /// No description provided for @needInternationalLicense.
  ///
  /// In en, this message translates to:
  /// **'Need international license'**
  String get needInternationalLicense;

  /// No description provided for @veryEconomicalShared.
  ///
  /// In en, this message translates to:
  /// **'Very economical (shared)'**
  String get veryEconomicalShared;

  /// No description provided for @fasterThanBus.
  ///
  /// In en, this message translates to:
  /// **'Faster than bus'**
  String get fasterThanBus;

  /// No description provided for @frequentWhenFull.
  ///
  /// In en, this message translates to:
  /// **'Frequent (when full)'**
  String get frequentWhenFull;

  /// No description provided for @directRoutesShort.
  ///
  /// In en, this message translates to:
  /// **'Direct routes for short distances'**
  String get directRoutesShort;

  /// No description provided for @localExperience.
  ///
  /// In en, this message translates to:
  /// **'Authentic local experience'**
  String get localExperience;

  /// No description provided for @waitUntilFull.
  ///
  /// In en, this message translates to:
  /// **'Wait until full to depart'**
  String get waitUntilFull;

  /// No description provided for @canBeCramped.
  ///
  /// In en, this message translates to:
  /// **'Can be cramped'**
  String get canBeCramped;

  /// No description provided for @noFixedSchedule.
  ///
  /// In en, this message translates to:
  /// **'No fixed schedule'**
  String get noFixedSchedule;

  /// No description provided for @limitedLuggageSpace.
  ///
  /// In en, this message translates to:
  /// **'Limited luggage space'**
  String get limitedLuggageSpace;

  /// No description provided for @notComfortableLongDistances.
  ///
  /// In en, this message translates to:
  /// **'Not comfortable for long distances'**
  String get notComfortableLongDistances;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hoursShort;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @multipleDaily.
  ///
  /// In en, this message translates to:
  /// **'Multiple daily'**
  String get multipleDaily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get weekly;

  /// No description provided for @perDay.
  ///
  /// In en, this message translates to:
  /// **'/day'**
  String get perDay;

  /// No description provided for @anytime.
  ///
  /// In en, this message translates to:
  /// **'Anytime'**
  String get anytime;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @perSeat.
  ///
  /// In en, this message translates to:
  /// **'/seat'**
  String get perSeat;

  /// No description provided for @continuous.
  ///
  /// In en, this message translates to:
  /// **'Continuous'**
  String get continuous;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @everyHours.
  ///
  /// In en, this message translates to:
  /// **'Every {time}'**
  String everyHours(Object time);

  /// No description provided for @bookingInfoPlane.
  ///
  /// In en, this message translates to:
  /// **'Book flights through Royal Air Maroc, Ryanair, Air Arabia, or travel agencies. Compare prices on Skyscanner, Google Flights, or Kayak. Book 2-3 months in advance for best prices.'**
  String get bookingInfoPlane;

  /// No description provided for @bookingInfoTrain.
  ///
  /// In en, this message translates to:
  /// **'Book online at www.oncf.ma or at station ticket offices. Book 1-2 weeks ahead for busy periods. First class recommended for long journeys.'**
  String get bookingInfoTrain;

  /// No description provided for @bookingInfoBus.
  ///
  /// In en, this message translates to:
  /// **'Book with CTM (www.ctm.ma) or Supratours online or at stations. Advance booking recommended during holidays and summer.'**
  String get bookingInfoBus;

  /// No description provided for @bookingInfoCar.
  ///
  /// In en, this message translates to:
  /// **'Major companies: Hertz, Avis, Europcar, Budget. Book online for better rates. Check insurance coverage carefully.'**
  String get bookingInfoCar;

  /// No description provided for @bookingInfoTaxi.
  ///
  /// In en, this message translates to:
  /// **'No booking needed. Go to grand taxi stands. Negotiate price or pay per seat. Depart when all 6 seats filled.'**
  String get bookingInfoTaxi;

  /// No description provided for @tipsPlane.
  ///
  /// In en, this message translates to:
  /// **'Arrive 2 hours early for international flights. Pre-arrange airport transfer. Download boarding pass. Keep passport and tickets accessible.'**
  String get tipsPlane;

  /// No description provided for @tipsTrain.
  ///
  /// In en, this message translates to:
  /// **'Arrive 30 minutes before departure. Validate tickets before boarding. First class offers more space. Bring snacks and water for long journeys.'**
  String get tipsTrain;

  /// No description provided for @tipsBus.
  ///
  /// In en, this message translates to:
  /// **'Arrive 15-20 minutes early. Keep ticket until arrival. Luggage stored underneath. Bring layers for AC. Download offline maps.'**
  String get tipsBus;

  /// No description provided for @tipsCar.
  ///
  /// In en, this message translates to:
  /// **'GPS recommended for navigation. Avoid driving in medina. Park in secured lots. Carry cash for tolls. Check car before leaving.'**
  String get tipsCar;

  /// No description provided for @tipsTaxi.
  ///
  /// In en, this message translates to:
  /// **'Agree on price before departure. Bring small change. Share with locals for authentic experience. Front seat more spacious.'**
  String get tipsTaxi;

  /// No description provided for @fesSaissAirport.
  ///
  /// In en, this message translates to:
  /// **'Fes-Saiss Airport'**
  String get fesSaissAirport;

  /// No description provided for @fesSaissAirportAr.
  ///
  /// In en, this message translates to:
  /// **'مطار فاس سايس'**
  String get fesSaissAirportAr;

  /// No description provided for @airportCode.
  ///
  /// In en, this message translates to:
  /// **'FEZ'**
  String get airportCode;

  /// No description provided for @airportLocation.
  ///
  /// In en, this message translates to:
  /// **'Saïss, 15km from city center'**
  String get airportLocation;

  /// No description provided for @distanceToMedina.
  ///
  /// In en, this message translates to:
  /// **'15km from the medina'**
  String get distanceToMedina;

  /// No description provided for @freeWifi.
  ///
  /// In en, this message translates to:
  /// **'Free WiFi'**
  String get freeWifi;

  /// No description provided for @cafesRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Cafes & Restaurants'**
  String get cafesRestaurants;

  /// No description provided for @carRentalDesks.
  ///
  /// In en, this message translates to:
  /// **'Car Rental Desks'**
  String get carRentalDesks;

  /// No description provided for @atmsExchange.
  ///
  /// In en, this message translates to:
  /// **'ATMs & Currency Exchange'**
  String get atmsExchange;

  /// No description provided for @dutyFreeShops.
  ///
  /// In en, this message translates to:
  /// **'Duty-Free Shops'**
  String get dutyFreeShops;

  /// No description provided for @prayerRoom.
  ///
  /// In en, this message translates to:
  /// **'Prayer Room'**
  String get prayerRoom;

  /// No description provided for @royalAirMaroc.
  ///
  /// In en, this message translates to:
  /// **'Royal Air Maroc'**
  String get royalAirMaroc;

  /// No description provided for @ryanair.
  ///
  /// In en, this message translates to:
  /// **'Ryanair'**
  String get ryanair;

  /// No description provided for @airArabia.
  ///
  /// In en, this message translates to:
  /// **'Air Arabia'**
  String get airArabia;

  /// No description provided for @transavia.
  ///
  /// In en, this message translates to:
  /// **'Transavia'**
  String get transavia;

  /// No description provided for @vueling.
  ///
  /// In en, this message translates to:
  /// **'Vueling'**
  String get vueling;

  /// No description provided for @transferInfo.
  ///
  /// In en, this message translates to:
  /// **'Taxis available 24/7 (150-200 MAD to medina, 20-30 min). Airport bus #16 to city center (4 MAD, 45 min). Pre-book private transfer for convenience.'**
  String get transferInfo;

  /// No description provided for @bestTimeToTravel.
  ///
  /// In en, this message translates to:
  /// **'Best Time to Travel'**
  String get bestTimeToTravel;

  /// No description provided for @bestTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Spring (March-May) and Fall (September-November) offer pleasant weather. Avoid extreme summer heat (June-August) and winter cold (December-February).'**
  String get bestTimeDesc;

  /// No description provided for @bookInAdvance.
  ///
  /// In en, this message translates to:
  /// **'Book in Advance'**
  String get bookInAdvance;

  /// No description provided for @bookInAdvanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Reserve trains and flights 2-3 weeks ahead, especially for holidays, Ramadan, and summer. Accommodation in medina fills quickly during peak season.'**
  String get bookInAdvanceDesc;

  /// No description provided for @travelDocuments.
  ///
  /// In en, this message translates to:
  /// **'Travel Documents'**
  String get travelDocuments;

  /// No description provided for @travelDocumentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Passport valid 6 months. Visa requirements vary by nationality. Keep copies of documents. Travel insurance recommended.'**
  String get travelDocumentsDesc;

  /// No description provided for @luggageTips.
  ///
  /// In en, this message translates to:
  /// **'Luggage Tips'**
  String get luggageTips;

  /// No description provided for @luggageTipsDesc.
  ///
  /// In en, this message translates to:
  /// **'Pack light for navigating narrow medina streets. Bring comfortable walking shoes. Modest clothing for religious sites. Small daypack for essentials.'**
  String get luggageTipsDesc;

  /// No description provided for @localCurrency.
  ///
  /// In en, this message translates to:
  /// **'Local Currency'**
  String get localCurrency;

  /// No description provided for @localCurrencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Moroccan Dirham (MAD). ATMs widely available. Exchange at banks for best rates. Small bills useful for souks and taxis. Credit cards accepted in hotels.'**
  String get localCurrencyDesc;

  /// No description provided for @stayConnected.
  ///
  /// In en, this message translates to:
  /// **'Stay Connected'**
  String get stayConnected;

  /// No description provided for @stayConnectedDesc.
  ///
  /// In en, this message translates to:
  /// **'Local SIM cards from Maroc Telecom, Orange, or Inwi (50-100 MAD). WiFi in most hotels and cafes. Download offline maps before arrival.'**
  String get stayConnectedDesc;

  /// No description provided for @loadingTravelOptions.
  ///
  /// In en, this message translates to:
  /// **'Loading travel options...'**
  String get loadingTravelOptions;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get failedToLoadData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @showFavorites.
  ///
  /// In en, this message translates to:
  /// **'Show Favorites'**
  String get showFavorites;

  /// No description provided for @comparePrices.
  ///
  /// In en, this message translates to:
  /// **'Compare Prices'**
  String get comparePrices;

  /// No description provided for @sortOptions.
  ///
  /// In en, this message translates to:
  /// **'Sort Options'**
  String get sortOptions;

  /// No description provided for @gettingToFesTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting to Fes'**
  String get gettingToFesTitle;

  /// No description provided for @gettingToFesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Journey'**
  String get gettingToFesSubtitle;

  /// No description provided for @searchRoutesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search routes, cities...'**
  String get searchRoutesPlaceholder;

  /// No description provided for @fromMedina.
  ///
  /// In en, this message translates to:
  /// **'from medina'**
  String get fromMedina;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get tapForDetails;

  /// No description provided for @allTransport.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allTransport;

  /// No description provided for @plane.
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get plane;

  /// No description provided for @train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get taxi;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String resultsFound(Object count);

  /// No description provided for @noFavoritesYetTravel.
  ///
  /// In en, this message translates to:
  /// **'No favorite routes yet'**
  String get noFavoritesYetTravel;

  /// No description provided for @addFavoritesByTapping.
  ///
  /// In en, this message translates to:
  /// **'Add favorites by tapping the heart icon'**
  String get addFavoritesByTapping;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters'**
  String get tryAdjustingSearch;

  /// No description provided for @travelTips.
  ///
  /// In en, this message translates to:
  /// **'Travel Tips'**
  String get travelTips;

  /// No description provided for @needMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need More Help?'**
  String get needMoreHelp;

  /// No description provided for @contactTouristInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact tourist information at +212 535-62-34-60'**
  String get contactTouristInfo;

  /// No description provided for @sortPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowToHigh;

  /// No description provided for @sortPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighToLow;

  /// No description provided for @sortDurationShortest.
  ///
  /// In en, this message translates to:
  /// **'Duration: Shortest First'**
  String get sortDurationShortest;

  /// No description provided for @sortMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get sortMostPopular;

  /// No description provided for @priceComparison.
  ///
  /// In en, this message translates to:
  /// **'Price Comparison'**
  String get priceComparison;

  /// No description provided for @comparingAllTransportOptions.
  ///
  /// In en, this message translates to:
  /// **'Comparing all transport options'**
  String get comparingAllTransportOptions;

  /// No description provided for @avgPrice.
  ///
  /// In en, this message translates to:
  /// **'Avg Price'**
  String get avgPrice;

  /// No description provided for @avgDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg Duration'**
  String get avgDuration;

  /// No description provided for @routeDetails.
  ///
  /// In en, this message translates to:
  /// **'Route Details'**
  String get routeDetails;

  /// No description provided for @routesAndSchedules.
  ///
  /// In en, this message translates to:
  /// **'Routes & Schedules'**
  String get routesAndSchedules;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @bookingInformation.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInformation;

  /// No description provided for @travelTipsForOption.
  ///
  /// In en, this message translates to:
  /// **'Travel Tips'**
  String get travelTipsForOption;

  /// No description provided for @prosAndCons.
  ///
  /// In en, this message translates to:
  /// **'Pros & Cons'**
  String get prosAndCons;

  /// No description provided for @pros.
  ///
  /// In en, this message translates to:
  /// **'Pros'**
  String get pros;

  /// No description provided for @cons.
  ///
  /// In en, this message translates to:
  /// **'Cons'**
  String get cons;

  /// No description provided for @airportInformation.
  ///
  /// In en, this message translates to:
  /// **'Airport Information'**
  String get airportInformation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @airlines.
  ///
  /// In en, this message translates to:
  /// **'Airlines'**
  String get airlines;

  /// No description provided for @groundTransportation.
  ///
  /// In en, this message translates to:
  /// **'Ground Transportation'**
  String get groundTransportation;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @localTransportPetitTaxi.
  ///
  /// In en, this message translates to:
  /// **'Petit Taxi'**
  String get localTransportPetitTaxi;

  /// No description provided for @localTransportPetitTaxiAr.
  ///
  /// In en, this message translates to:
  /// **'الطاكسي الصغير'**
  String get localTransportPetitTaxiAr;

  /// No description provided for @localTransportGrandTaxi.
  ///
  /// In en, this message translates to:
  /// **'Grand Taxi'**
  String get localTransportGrandTaxi;

  /// No description provided for @localTransportGrandTaxiAr.
  ///
  /// In en, this message translates to:
  /// **'الطاكسي الكبير'**
  String get localTransportGrandTaxiAr;

  /// No description provided for @localTransportCityBus.
  ///
  /// In en, this message translates to:
  /// **'City Bus'**
  String get localTransportCityBus;

  /// No description provided for @localTransportCityBusAr.
  ///
  /// In en, this message translates to:
  /// **'الحافلة'**
  String get localTransportCityBusAr;

  /// No description provided for @localTransportWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get localTransportWalking;

  /// No description provided for @localTransportWalkingAr.
  ///
  /// In en, this message translates to:
  /// **'المشي'**
  String get localTransportWalkingAr;

  /// No description provided for @localTransportBikeRental.
  ///
  /// In en, this message translates to:
  /// **'Bike Rental'**
  String get localTransportBikeRental;

  /// No description provided for @localTransportBikeRentalAr.
  ///
  /// In en, this message translates to:
  /// **'كراء الدراجات'**
  String get localTransportBikeRentalAr;

  /// No description provided for @localTransportPrivateDriver.
  ///
  /// In en, this message translates to:
  /// **'Private Driver'**
  String get localTransportPrivateDriver;

  /// No description provided for @localTransportPrivateDriverAr.
  ///
  /// In en, this message translates to:
  /// **'سائق خاص'**
  String get localTransportPrivateDriverAr;

  /// No description provided for @localTransportPetitTaxiDesc.
  ///
  /// In en, this message translates to:
  /// **'Small blue taxis for city travel. Metered rides.'**
  String get localTransportPetitTaxiDesc;

  /// No description provided for @localTransportGrandTaxiDesc.
  ///
  /// In en, this message translates to:
  /// **'Large beige taxis for airport & intercity travel.'**
  String get localTransportGrandTaxiDesc;

  /// No description provided for @localTransportCityBusDesc.
  ///
  /// In en, this message translates to:
  /// **'Public buses by Alsa. Very cheap but crowded.'**
  String get localTransportCityBusDesc;

  /// No description provided for @localTransportWalkingDesc.
  ///
  /// In en, this message translates to:
  /// **'Best way to explore the car-free Medina.'**
  String get localTransportWalkingDesc;

  /// No description provided for @localTransportBikeRentalDesc.
  ///
  /// In en, this message translates to:
  /// **'Bikes for Ville Nouvelle. Not allowed in Medina.'**
  String get localTransportBikeRentalDesc;

  /// No description provided for @localTransportPrivateDriverDesc.
  ///
  /// In en, this message translates to:
  /// **'Hire a driver with car. Most comfortable option.'**
  String get localTransportPrivateDriverDesc;

  /// No description provided for @localTransportPetitTaxiPrice.
  ///
  /// In en, this message translates to:
  /// **'7-30 MAD'**
  String get localTransportPetitTaxiPrice;

  /// No description provided for @localTransportGrandTaxiPrice.
  ///
  /// In en, this message translates to:
  /// **'150-300 MAD'**
  String get localTransportGrandTaxiPrice;

  /// No description provided for @localTransportCityBusPrice.
  ///
  /// In en, this message translates to:
  /// **'4-7 MAD'**
  String get localTransportCityBusPrice;

  /// No description provided for @localTransportBikeRentalPrice.
  ///
  /// In en, this message translates to:
  /// **'50-100 MAD/day'**
  String get localTransportBikeRentalPrice;

  /// No description provided for @localTransportPrivateDriverPrice.
  ///
  /// In en, this message translates to:
  /// **'400-800 MAD/day'**
  String get localTransportPrivateDriverPrice;

  /// No description provided for @localTransportPetitTaxiDetails.
  ///
  /// In en, this message translates to:
  /// **'Available 24/7. Always insist on meter. Keep small bills.'**
  String get localTransportPetitTaxiDetails;

  /// No description provided for @localTransportGrandTaxiDetails.
  ///
  /// In en, this message translates to:
  /// **'Airport transfers. Negotiate price before getting in.'**
  String get localTransportGrandTaxiDetails;

  /// No description provided for @localTransportCityBusDetails.
  ///
  /// In en, this message translates to:
  /// **'Line 16 to airport. Pay driver directly. Watch belongings.'**
  String get localTransportCityBusDetails;

  /// No description provided for @localTransportWalkingDetails.
  ///
  /// In en, this message translates to:
  /// **'Wear comfortable shoes. Download offline maps. Bring water.'**
  String get localTransportWalkingDetails;

  /// No description provided for @localTransportBikeRentalDetails.
  ///
  /// In en, this message translates to:
  /// **'Available at hotels and sports shops. Check bike condition.'**
  String get localTransportBikeRentalDetails;

  /// No description provided for @localTransportPrivateDriverDetails.
  ///
  /// In en, this message translates to:
  /// **'Book through hotel. Agree on price and itinerary first.'**
  String get localTransportPrivateDriverDetails;

  /// No description provided for @searchTransport.
  ///
  /// In en, this message translates to:
  /// **'Search transport...'**
  String get searchTransport;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @importantInfo.
  ///
  /// In en, this message translates to:
  /// **'Important Info'**
  String get importantInfo;

  /// No description provided for @needHelpTransport.
  ///
  /// In en, this message translates to:
  /// **'Need help with transport?'**
  String get needHelpTransport;

  /// No description provided for @askHotelRiad.
  ///
  /// In en, this message translates to:
  /// **'Ask your hotel/riad - they know best!'**
  String get askHotelRiad;

  /// No description provided for @exploreFes.
  ///
  /// In en, this message translates to:
  /// **'Explore Fes'**
  String get exploreFes;

  /// No description provided for @searchPlaces.
  ///
  /// In en, this message translates to:
  /// **'Search places...'**
  String get searchPlaces;

  /// Number of places found
  ///
  /// In en, this message translates to:
  /// **'{count} places'**
  String placesCount(String count);

  /// No description provided for @sortDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get sortDefault;

  /// No description provided for @sortDistance.
  ///
  /// In en, this message translates to:
  /// **'By Distance'**
  String get sortDistance;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'By Rating'**
  String get sortRating;

  /// No description provided for @filterLandmarks.
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get filterLandmarks;

  /// No description provided for @filterReligious.
  ///
  /// In en, this message translates to:
  /// **'Religious Sites'**
  String get filterReligious;

  /// No description provided for @filterParks.
  ///
  /// In en, this message translates to:
  /// **'Parks'**
  String get filterParks;

  /// No description provided for @filterAttractions.
  ///
  /// In en, this message translates to:
  /// **'Attractions'**
  String get filterAttractions;

  /// No description provided for @duration30min.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get duration30min;

  /// No description provided for @duration45min.
  ///
  /// In en, this message translates to:
  /// **'45 min'**
  String get duration45min;

  /// No description provided for @duration1h.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get duration1h;

  /// No description provided for @duration1h30.
  ///
  /// In en, this message translates to:
  /// **'1.5 hours'**
  String get duration1h30;

  /// No description provided for @duration2h.
  ///
  /// In en, this message translates to:
  /// **'2 hours'**
  String get duration2h;

  /// No description provided for @price10Mad.
  ///
  /// In en, this message translates to:
  /// **'10 MAD'**
  String get price10Mad;

  /// No description provided for @price20Mad.
  ///
  /// In en, this message translates to:
  /// **'20 MAD'**
  String get price20Mad;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get yourLocation;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Please enable in settings.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get errorGettingLocation;

  /// No description provided for @pleaseEnableLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get pleaseEnableLocation;

  /// No description provided for @errorCalculatingRoute.
  ///
  /// In en, this message translates to:
  /// **'Error calculating route'**
  String get errorCalculatingRoute;

  /// No description provided for @calculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @travelMode.
  ///
  /// In en, this message translates to:
  /// **'Travel Mode'**
  String get travelMode;

  /// No description provided for @travelWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get travelWalk;

  /// No description provided for @travelDrive.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get travelDrive;

  /// No description provided for @travelBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get travelBike;

  /// Route summary with duration and steps
  ///
  /// In en, this message translates to:
  /// **'{duration} min • {steps} steps'**
  String routeSummary(String duration, String steps);

  /// No description provided for @viewDirections.
  ///
  /// In en, this message translates to:
  /// **'View Directions'**
  String get viewDirections;

  /// Directions to a place
  ///
  /// In en, this message translates to:
  /// **'to {name}'**
  String directionTo(String name);

  /// No description provided for @statDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get statDistance;

  /// No description provided for @statSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get statSteps;

  /// Share message template for social sharing
  ///
  /// In en, this message translates to:
  /// **'{badge} {name}\n⭐ {rating}/10\n\nDiscover this amazing place in Fes!\n{url}'**
  String shareMessage(String badge, String name, String rating, String url);

  /// Share subject line
  ///
  /// In en, this message translates to:
  /// **'Check out {name} in Fes'**
  String shareSubject(String name);

  /// Number of reviews
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(String count);

  /// No description provided for @whatToBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'What to Buy in Fes'**
  String get whatToBuyTitle;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// Number of products found
  ///
  /// In en, this message translates to:
  /// **'{count} Products'**
  String productsCount(int count);

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryLeather.
  ///
  /// In en, this message translates to:
  /// **'Leather'**
  String get categoryLeather;

  /// No description provided for @categoryCeramics.
  ///
  /// In en, this message translates to:
  /// **'Ceramics'**
  String get categoryCeramics;

  /// No description provided for @categoryTextiles.
  ///
  /// In en, this message translates to:
  /// **'Textiles'**
  String get categoryTextiles;

  /// No description provided for @categoryMetalwork.
  ///
  /// In en, this message translates to:
  /// **'Metalwork'**
  String get categoryMetalwork;

  /// No description provided for @categorySpices.
  ///
  /// In en, this message translates to:
  /// **'Spices'**
  String get categorySpices;

  /// No description provided for @categoryCosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get categoryCosmetics;

  /// No description provided for @sortPriceLowHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get sortPriceLowHigh;

  /// No description provided for @sortPriceHighLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get sortPriceHighLow;

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name: A to Z'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name: Z to A'**
  String get sortNameZA;

  /// No description provided for @handmade.
  ///
  /// In en, this message translates to:
  /// **'Handmade'**
  String get handmade;

  /// No description provided for @handmadeOnly.
  ///
  /// In en, this message translates to:
  /// **'Handmade Only'**
  String get handmadeOnly;

  /// No description provided for @showHandmadeProducts.
  ///
  /// In en, this message translates to:
  /// **'Show only handcrafted products'**
  String get showHandmadeProducts;

  /// No description provided for @priceRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRangeLabel;

  /// No description provided for @productType.
  ///
  /// In en, this message translates to:
  /// **'Product Type'**
  String get productType;

  /// No description provided for @quality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// No description provided for @qualityPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get qualityPremium;

  /// No description provided for @qualityAuthentic.
  ///
  /// In en, this message translates to:
  /// **'Authentic'**
  String get qualityAuthentic;

  /// No description provided for @qualityLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get qualityLuxury;

  /// No description provided for @characteristics.
  ///
  /// In en, this message translates to:
  /// **'Characteristics'**
  String get characteristics;

  /// No description provided for @whereToFind.
  ///
  /// In en, this message translates to:
  /// **'Where to Find'**
  String get whereToFind;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Multiple items added to cart message
  ///
  /// In en, this message translates to:
  /// **'{quantity} x {name} added'**
  String addedToCartMultiple(int quantity, String name);

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items:'**
  String get totalItems;

  /// No description provided for @estimatedTotal.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total:'**
  String get estimatedTotal;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @checkoutComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Checkout coming soon!'**
  String get checkoutComingSoon;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @shopAuthenticCrafts.
  ///
  /// In en, this message translates to:
  /// **'Shop authentic Moroccan crafts'**
  String get shopAuthenticCrafts;

  /// No description provided for @supportLocalArtisans.
  ///
  /// In en, this message translates to:
  /// **'Support local artisans in Fes'**
  String get supportLocalArtisans;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get add;

  /// No description provided for @leatherBabouchesName.
  ///
  /// In en, this message translates to:
  /// **'Leather Babouches'**
  String get leatherBabouchesName;

  /// No description provided for @leatherBabouchesNameAr.
  ///
  /// In en, this message translates to:
  /// **'بلغة جلدية'**
  String get leatherBabouchesNameAr;

  /// No description provided for @leatherBabouchesDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional Moroccan slippers, handcrafted from genuine leather in the famous tanneries of Fes'**
  String get leatherBabouchesDesc;

  /// No description provided for @leatherBabouchesPrice.
  ///
  /// In en, this message translates to:
  /// **'150-400 MAD'**
  String get leatherBabouchesPrice;

  /// No description provided for @leatherBabouchesChar1.
  ///
  /// In en, this message translates to:
  /// **'Genuine leather'**
  String get leatherBabouchesChar1;

  /// No description provided for @leatherBabouchesChar2.
  ///
  /// In en, this message translates to:
  /// **'Traditional craftsmanship'**
  String get leatherBabouchesChar2;

  /// No description provided for @leatherBabouchesChar3.
  ///
  /// In en, this message translates to:
  /// **'Comfortable fit'**
  String get leatherBabouchesChar3;

  /// No description provided for @leatherBabouchesChar4.
  ///
  /// In en, this message translates to:
  /// **'Various colors available'**
  String get leatherBabouchesChar4;

  /// No description provided for @leatherBabouchesWhere.
  ///
  /// In en, this message translates to:
  /// **'Chouara Tannery, Medina souks'**
  String get leatherBabouchesWhere;

  /// No description provided for @leatherBagsName.
  ///
  /// In en, this message translates to:
  /// **'Leather Bags'**
  String get leatherBagsName;

  /// No description provided for @leatherBagsNameAr.
  ///
  /// In en, this message translates to:
  /// **'حقائب جلدية'**
  String get leatherBagsNameAr;

  /// No description provided for @leatherBagsDesc.
  ///
  /// In en, this message translates to:
  /// **'Handcrafted leather bags and pouches, perfect for everyday use or as unique gifts'**
  String get leatherBagsDesc;

  /// No description provided for @leatherBagsPrice.
  ///
  /// In en, this message translates to:
  /// **'200-800 MAD'**
  String get leatherBagsPrice;

  /// No description provided for @leatherBagsChar1.
  ///
  /// In en, this message translates to:
  /// **'Durable leather'**
  String get leatherBagsChar1;

  /// No description provided for @leatherBagsChar2.
  ///
  /// In en, this message translates to:
  /// **'Multiple compartments'**
  String get leatherBagsChar2;

  /// No description provided for @leatherBagsChar3.
  ///
  /// In en, this message translates to:
  /// **'Traditional designs'**
  String get leatherBagsChar3;

  /// No description provided for @leatherBagsChar4.
  ///
  /// In en, this message translates to:
  /// **'Long-lasting quality'**
  String get leatherBagsChar4;

  /// No description provided for @leatherBagsWhere.
  ///
  /// In en, this message translates to:
  /// **'Leather souk, Ain Azliten'**
  String get leatherBagsWhere;

  /// No description provided for @fesBluePotteryName.
  ///
  /// In en, this message translates to:
  /// **'Fes Blue Pottery'**
  String get fesBluePotteryName;

  /// No description provided for @fesBluePotteryNameAr.
  ///
  /// In en, this message translates to:
  /// **'فخار فاس الأزرق'**
  String get fesBluePotteryNameAr;

  /// No description provided for @fesBluePotteryDesc.
  ///
  /// In en, this message translates to:
  /// **'Famous blue and white ceramics unique to Fes, featuring intricate geometric patterns'**
  String get fesBluePotteryDesc;

  /// No description provided for @fesBluePotteryPrice.
  ///
  /// In en, this message translates to:
  /// **'50-500 MAD'**
  String get fesBluePotteryPrice;

  /// No description provided for @fesBluePotteryChar1.
  ///
  /// In en, this message translates to:
  /// **'Traditional Fassi blue'**
  String get fesBluePotteryChar1;

  /// No description provided for @fesBluePotteryChar2.
  ///
  /// In en, this message translates to:
  /// **'Hand-painted designs'**
  String get fesBluePotteryChar2;

  /// No description provided for @fesBluePotteryChar3.
  ///
  /// In en, this message translates to:
  /// **'Food-safe glaze'**
  String get fesBluePotteryChar3;

  /// No description provided for @fesBluePotteryChar4.
  ///
  /// In en, this message translates to:
  /// **'Various sizes'**
  String get fesBluePotteryChar4;

  /// No description provided for @fesBluePotteryWhere.
  ///
  /// In en, this message translates to:
  /// **'Pottery workshops, Ain Nokbi'**
  String get fesBluePotteryWhere;

  /// No description provided for @ceramicTajineName.
  ///
  /// In en, this message translates to:
  /// **'Ceramic Tajine'**
  String get ceramicTajineName;

  /// No description provided for @ceramicTajineNameAr.
  ///
  /// In en, this message translates to:
  /// **'طاجين فخاري'**
  String get ceramicTajineNameAr;

  /// No description provided for @ceramicTajineDesc.
  ///
  /// In en, this message translates to:
  /// **'Decorative or cooking tajines with beautiful traditional patterns'**
  String get ceramicTajineDesc;

  /// No description provided for @ceramicTajinePrice.
  ///
  /// In en, this message translates to:
  /// **'100-600 MAD'**
  String get ceramicTajinePrice;

  /// No description provided for @ceramicTajineChar1.
  ///
  /// In en, this message translates to:
  /// **'Cooking & decorative'**
  String get ceramicTajineChar1;

  /// No description provided for @ceramicTajineChar2.
  ///
  /// In en, this message translates to:
  /// **'Traditional designs'**
  String get ceramicTajineChar2;

  /// No description provided for @ceramicTajineChar3.
  ///
  /// In en, this message translates to:
  /// **'Handcrafted pottery'**
  String get ceramicTajineChar3;

  /// No description provided for @ceramicTajineChar4.
  ///
  /// In en, this message translates to:
  /// **'Various sizes'**
  String get ceramicTajineChar4;

  /// No description provided for @ceramicTajineWhere.
  ///
  /// In en, this message translates to:
  /// **'Pottery souk, Bab Ftouh'**
  String get ceramicTajineWhere;

  /// No description provided for @moroccanCarpetsName.
  ///
  /// In en, this message translates to:
  /// **'Moroccan Carpets'**
  String get moroccanCarpetsName;

  /// No description provided for @moroccanCarpetsNameAr.
  ///
  /// In en, this message translates to:
  /// **'زرابي مغربية'**
  String get moroccanCarpetsNameAr;

  /// No description provided for @moroccanCarpetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Hand-woven carpets and rugs with traditional Berber and Fassi designs'**
  String get moroccanCarpetsDesc;

  /// No description provided for @moroccanCarpetsPrice.
  ///
  /// In en, this message translates to:
  /// **'500-5000 MAD'**
  String get moroccanCarpetsPrice;

  /// No description provided for @moroccanCarpetsChar1.
  ///
  /// In en, this message translates to:
  /// **'Hand-woven wool'**
  String get moroccanCarpetsChar1;

  /// No description provided for @moroccanCarpetsChar2.
  ///
  /// In en, this message translates to:
  /// **'Traditional patterns'**
  String get moroccanCarpetsChar2;

  /// No description provided for @moroccanCarpetsChar3.
  ///
  /// In en, this message translates to:
  /// **'Natural dyes'**
  String get moroccanCarpetsChar3;

  /// No description provided for @moroccanCarpetsChar4.
  ///
  /// In en, this message translates to:
  /// **'Various sizes'**
  String get moroccanCarpetsChar4;

  /// No description provided for @moroccanCarpetsWhere.
  ///
  /// In en, this message translates to:
  /// **'Carpet souk, Medina shops'**
  String get moroccanCarpetsWhere;

  /// No description provided for @embroideredKaftansName.
  ///
  /// In en, this message translates to:
  /// **'Embroidered Kaftans'**
  String get embroideredKaftansName;

  /// No description provided for @embroideredKaftansNameAr.
  ///
  /// In en, this message translates to:
  /// **'قفاطين مطرزة'**
  String get embroideredKaftansNameAr;

  /// No description provided for @embroideredKaftansDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional Moroccan kaftans with intricate embroidery and sfifa'**
  String get embroideredKaftansDesc;

  /// No description provided for @embroideredKaftansPrice.
  ///
  /// In en, this message translates to:
  /// **'800-3000 MAD'**
  String get embroideredKaftansPrice;

  /// No description provided for @embroideredKaftansChar1.
  ///
  /// In en, this message translates to:
  /// **'Hand-embroidered'**
  String get embroideredKaftansChar1;

  /// No description provided for @embroideredKaftansChar2.
  ///
  /// In en, this message translates to:
  /// **'Silk or cotton'**
  String get embroideredKaftansChar2;

  /// No description provided for @embroideredKaftansChar3.
  ///
  /// In en, this message translates to:
  /// **'Traditional sfifa'**
  String get embroideredKaftansChar3;

  /// No description provided for @embroideredKaftansChar4.
  ///
  /// In en, this message translates to:
  /// **'Custom sizes'**
  String get embroideredKaftansChar4;

  /// No description provided for @embroideredKaftansWhere.
  ///
  /// In en, this message translates to:
  /// **'Attarine souk, Boutiques'**
  String get embroideredKaftansWhere;

  /// No description provided for @brassLanternsName.
  ///
  /// In en, this message translates to:
  /// **'Brass Lanterns'**
  String get brassLanternsName;

  /// No description provided for @brassLanternsNameAr.
  ///
  /// In en, this message translates to:
  /// **'فوانيس نحاسية'**
  String get brassLanternsNameAr;

  /// No description provided for @brassLanternsDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional Moroccan lanterns with intricate metalwork and colored glass'**
  String get brassLanternsDesc;

  /// No description provided for @brassLanternsPrice.
  ///
  /// In en, this message translates to:
  /// **'150-800 MAD'**
  String get brassLanternsPrice;

  /// No description provided for @brassLanternsChar1.
  ///
  /// In en, this message translates to:
  /// **'Hand-forged brass'**
  String get brassLanternsChar1;

  /// No description provided for @brassLanternsChar2.
  ///
  /// In en, this message translates to:
  /// **'Colored glass inserts'**
  String get brassLanternsChar2;

  /// No description provided for @brassLanternsChar3.
  ///
  /// In en, this message translates to:
  /// **'Traditional designs'**
  String get brassLanternsChar3;

  /// No description provided for @brassLanternsChar4.
  ///
  /// In en, this message translates to:
  /// **'Various sizes'**
  String get brassLanternsChar4;

  /// No description provided for @brassLanternsWhere.
  ///
  /// In en, this message translates to:
  /// **'Metalwork souk, Seffarine'**
  String get brassLanternsWhere;

  /// No description provided for @copperTeapotsName.
  ///
  /// In en, this message translates to:
  /// **'Copper Teapots'**
  String get copperTeapotsName;

  /// No description provided for @copperTeapotsNameAr.
  ///
  /// In en, this message translates to:
  /// **'براريد نحاسية'**
  String get copperTeapotsNameAr;

  /// No description provided for @copperTeapotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional Moroccan teapots and tea sets in polished copper or brass'**
  String get copperTeapotsDesc;

  /// No description provided for @copperTeapotsPrice.
  ///
  /// In en, this message translates to:
  /// **'200-1000 MAD'**
  String get copperTeapotsPrice;

  /// No description provided for @copperTeapotsChar1.
  ///
  /// In en, this message translates to:
  /// **'Polished copper/brass'**
  String get copperTeapotsChar1;

  /// No description provided for @copperTeapotsChar2.
  ///
  /// In en, this message translates to:
  /// **'Traditional design'**
  String get copperTeapotsChar2;

  /// No description provided for @copperTeapotsChar3.
  ///
  /// In en, this message translates to:
  /// **'Functional art'**
  String get copperTeapotsChar3;

  /// No description provided for @copperTeapotsChar4.
  ///
  /// In en, this message translates to:
  /// **'Various sizes'**
  String get copperTeapotsChar4;

  /// No description provided for @copperTeapotsWhere.
  ///
  /// In en, this message translates to:
  /// **'Seffarine square'**
  String get copperTeapotsWhere;

  /// No description provided for @rasElHanoutName.
  ///
  /// In en, this message translates to:
  /// **'Ras El Hanout'**
  String get rasElHanoutName;

  /// No description provided for @rasElHanoutNameAr.
  ///
  /// In en, this message translates to:
  /// **'رأس الحانوت'**
  String get rasElHanoutNameAr;

  /// No description provided for @rasElHanoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Premium spice blend with up to 30 different spices, signature of Moroccan cuisine'**
  String get rasElHanoutDesc;

  /// No description provided for @rasElHanoutPrice.
  ///
  /// In en, this message translates to:
  /// **'50-200 MAD/kg'**
  String get rasElHanoutPrice;

  /// No description provided for @rasElHanoutChar1.
  ///
  /// In en, this message translates to:
  /// **'20-30 spice blend'**
  String get rasElHanoutChar1;

  /// No description provided for @rasElHanoutChar2.
  ///
  /// In en, this message translates to:
  /// **'Freshly ground'**
  String get rasElHanoutChar2;

  /// No description provided for @rasElHanoutChar3.
  ///
  /// In en, this message translates to:
  /// **'Aromatic & flavorful'**
  String get rasElHanoutChar3;

  /// No description provided for @rasElHanoutChar4.
  ///
  /// In en, this message translates to:
  /// **'Traditional recipe'**
  String get rasElHanoutChar4;

  /// No description provided for @rasElHanoutWhere.
  ///
  /// In en, this message translates to:
  /// **'Spice souk, Attarine'**
  String get rasElHanoutWhere;

  /// No description provided for @saffronName.
  ///
  /// In en, this message translates to:
  /// **'Saffron'**
  String get saffronName;

  /// No description provided for @saffronNameAr.
  ///
  /// In en, this message translates to:
  /// **'زعفران'**
  String get saffronNameAr;

  /// No description provided for @saffronDesc.
  ///
  /// In en, this message translates to:
  /// **'Precious Moroccan saffron from Taliouine, the red gold of cooking'**
  String get saffronDesc;

  /// No description provided for @saffronPrice.
  ///
  /// In en, this message translates to:
  /// **'80-300 MAD/gram'**
  String get saffronPrice;

  /// No description provided for @saffronChar1.
  ///
  /// In en, this message translates to:
  /// **'Premium quality'**
  String get saffronChar1;

  /// No description provided for @saffronChar2.
  ///
  /// In en, this message translates to:
  /// **'Intense aroma'**
  String get saffronChar2;

  /// No description provided for @saffronChar3.
  ///
  /// In en, this message translates to:
  /// **'Natural coloring'**
  String get saffronChar3;

  /// No description provided for @saffronChar4.
  ///
  /// In en, this message translates to:
  /// **'Moroccan origin'**
  String get saffronChar4;

  /// No description provided for @saffronWhere.
  ///
  /// In en, this message translates to:
  /// **'Spice merchants, Attarine'**
  String get saffronWhere;

  /// No description provided for @arganOilName.
  ///
  /// In en, this message translates to:
  /// **'Argan Oil'**
  String get arganOilName;

  /// No description provided for @arganOilNameAr.
  ///
  /// In en, this message translates to:
  /// **'زيت الأركان'**
  String get arganOilNameAr;

  /// No description provided for @arganOilDesc.
  ///
  /// In en, this message translates to:
  /// **'Pure Moroccan argan oil for cosmetic and culinary use, liquid gold of Morocco'**
  String get arganOilDesc;

  /// No description provided for @arganOilPrice.
  ///
  /// In en, this message translates to:
  /// **'150-400 MAD/bottle'**
  String get arganOilPrice;

  /// No description provided for @arganOilChar1.
  ///
  /// In en, this message translates to:
  /// **'100% pure argan'**
  String get arganOilChar1;

  /// No description provided for @arganOilChar2.
  ///
  /// In en, this message translates to:
  /// **'Cold-pressed'**
  String get arganOilChar2;

  /// No description provided for @arganOilChar3.
  ///
  /// In en, this message translates to:
  /// **'Organic certified'**
  String get arganOilChar3;

  /// No description provided for @arganOilChar4.
  ///
  /// In en, this message translates to:
  /// **'Multi-purpose'**
  String get arganOilChar4;

  /// No description provided for @arganOilWhere.
  ///
  /// In en, this message translates to:
  /// **'Cooperatives, Pharmacies'**
  String get arganOilWhere;

  /// No description provided for @blackSoapName.
  ///
  /// In en, this message translates to:
  /// **'Black Soap (Savon Beldi)'**
  String get blackSoapName;

  /// No description provided for @blackSoapNameAr.
  ///
  /// In en, this message translates to:
  /// **'صابون بلدي'**
  String get blackSoapNameAr;

  /// No description provided for @blackSoapDesc.
  ///
  /// In en, this message translates to:
  /// **'Traditional Moroccan black soap made from olive oil, essential for hammam'**
  String get blackSoapDesc;

  /// No description provided for @blackSoapPrice.
  ///
  /// In en, this message translates to:
  /// **'30-100 MAD'**
  String get blackSoapPrice;

  /// No description provided for @blackSoapChar1.
  ///
  /// In en, this message translates to:
  /// **'Natural olive oil'**
  String get blackSoapChar1;

  /// No description provided for @blackSoapChar2.
  ///
  /// In en, this message translates to:
  /// **'Exfoliating properties'**
  String get blackSoapChar2;

  /// No description provided for @blackSoapChar3.
  ///
  /// In en, this message translates to:
  /// **'Traditional recipe'**
  String get blackSoapChar3;

  /// No description provided for @blackSoapChar4.
  ///
  /// In en, this message translates to:
  /// **'Hammam essential'**
  String get blackSoapChar4;

  /// No description provided for @blackSoapWhere.
  ///
  /// In en, this message translates to:
  /// **'Herbalist shops, Souks'**
  String get blackSoapWhere;

  /// No description provided for @bouInaniaIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Full access to the central courtyard and student quarters'**
  String get bouInaniaIncluded1;

  /// No description provided for @bouInaniaIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Guided explanation of Marinid architectural techniques'**
  String get bouInaniaIncluded2;

  /// No description provided for @bouInaniaIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Observation of the ornate mihrab and minbar'**
  String get bouInaniaIncluded3;

  /// No description provided for @bouInaniaIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Visit to the rooftop terrace with panoramic medina views'**
  String get bouInaniaIncluded4;

  /// No description provided for @bouInaniaIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Historical context of Islamic education in medieval Morocco'**
  String get bouInaniaIncluded5;

  /// No description provided for @bouInaniaInfo1.
  ///
  /// In en, this message translates to:
  /// **'Entrance fee required — approximately 70 MAD per person'**
  String get bouInaniaInfo1;

  /// No description provided for @bouInaniaInfo2.
  ///
  /// In en, this message translates to:
  /// **'Remove shoes before entering the prayer hall area'**
  String get bouInaniaInfo2;

  /// No description provided for @bouInaniaInfo3.
  ///
  /// In en, this message translates to:
  /// **'Photography is allowed throughout the madrasa'**
  String get bouInaniaInfo3;

  /// No description provided for @bouInaniaInfo4.
  ///
  /// In en, this message translates to:
  /// **'Guided tours available in English, French, Arabic, and Spanish'**
  String get bouInaniaInfo4;

  /// No description provided for @bouInaniaMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Bou Inania Madrasa Main Entrance'**
  String get bouInaniaMeetingLocation;

  /// No description provided for @bouInaniaMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Located on Talaa Kebira street, look for the ornate wooden door'**
  String get bouInaniaMeetingDesc;

  /// No description provided for @attarineIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Access to the ornate central courtyard and upper gallery'**
  String get attarineIncluded1;

  /// No description provided for @attarineIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Guided tour highlighting the zellige and stucco artistry'**
  String get attarineIncluded2;

  /// No description provided for @attarineIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Visit to student living quarters on the upper floor'**
  String get attarineIncluded3;

  /// No description provided for @attarineIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Explanation of Marinid patronage of arts and education'**
  String get attarineIncluded4;

  /// No description provided for @attarineIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Connection to the adjacent Attarine souk for spice shopping'**
  String get attarineIncluded5;

  /// No description provided for @attarineInfo1.
  ///
  /// In en, this message translates to:
  /// **'Entrance fee approximately 20 MAD per person'**
  String get attarineInfo1;

  /// No description provided for @attarineInfo2.
  ///
  /// In en, this message translates to:
  /// **'The madrasa is closed on Fridays for religious observance'**
  String get attarineInfo2;

  /// No description provided for @attarineInfo3.
  ///
  /// In en, this message translates to:
  /// **'Best visited in the morning before tour groups arrive'**
  String get attarineInfo3;

  /// No description provided for @attarineInfo4.
  ///
  /// In en, this message translates to:
  /// **'The courtyard fountain is still functional and used for ablutions'**
  String get attarineInfo4;

  /// No description provided for @attarineMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Al-Qarawiyyin Library Gate'**
  String get attarineMeetingLocation;

  /// No description provided for @attarineMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Near Souk al-Attarine, 50m from the madrasa'**
  String get attarineMeetingDesc;

  /// No description provided for @chouaraIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Access to viewing terraces overlooking the tannery vats'**
  String get chouaraIncluded1;

  /// No description provided for @chouaraIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Sprig of fresh mint to counter the strong smell (provided)'**
  String get chouaraIncluded2;

  /// No description provided for @chouaraIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Explanation of the 11th-century dyeing and tanning process'**
  String get chouaraIncluded3;

  /// No description provided for @chouaraIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Guide to leather products — babouches, bags, belts'**
  String get chouaraIncluded4;

  /// No description provided for @chouaraIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Free time to browse leather goods at fair prices'**
  String get chouaraIncluded5;

  /// No description provided for @chouaraInfo1.
  ///
  /// In en, this message translates to:
  /// **'The smell is very strong — mint sprigs are provided and recommended'**
  String get chouaraInfo1;

  /// No description provided for @chouaraInfo2.
  ///
  /// In en, this message translates to:
  /// **'Best visited Monday to Thursday when workers are most active'**
  String get chouaraInfo2;

  /// No description provided for @chouaraInfo3.
  ///
  /// In en, this message translates to:
  /// **'Avoid visiting on Fridays as activity is reduced'**
  String get chouaraInfo3;

  /// No description provided for @chouaraInfo4.
  ///
  /// In en, this message translates to:
  /// **'Do not photograph workers without asking permission first'**
  String get chouaraInfo4;

  /// No description provided for @chouaraMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Chouara Leather Shop Terrace'**
  String get chouaraMeetingLocation;

  /// No description provided for @chouaraMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Look for shops with \'Free Terrace View\' signs near Rue Chouara'**
  String get chouaraMeetingDesc;

  /// No description provided for @nejjarineIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Full museum access across all three floors of galleries'**
  String get nejjarineIncluded1;

  /// No description provided for @nejjarineIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Exhibition of antique cedar wood carvings and furniture'**
  String get nejjarineIncluded2;

  /// No description provided for @nejjarineIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Display of traditional woodworking and marquetry tools'**
  String get nejjarineIncluded3;

  /// No description provided for @nejjarineIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Rooftop terrace access with panoramic medina views'**
  String get nejjarineIncluded4;

  /// No description provided for @nejjarineIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Introduction to the Nejjarine Square and its woodworking souk'**
  String get nejjarineIncluded5;

  /// No description provided for @nejjarineInfo1.
  ///
  /// In en, this message translates to:
  /// **'Entrance fee approximately 20 MAD per person'**
  String get nejjarineInfo1;

  /// No description provided for @nejjarineInfo2.
  ///
  /// In en, this message translates to:
  /// **'Photography is permitted throughout the museum'**
  String get nejjarineInfo2;

  /// No description provided for @nejjarineInfo3.
  ///
  /// In en, this message translates to:
  /// **'The rooftop café serves traditional Moroccan mint tea'**
  String get nejjarineInfo3;

  /// No description provided for @nejjarineInfo4.
  ///
  /// In en, this message translates to:
  /// **'Allow at least 1.5 hours for a thorough visit'**
  String get nejjarineInfo4;

  /// No description provided for @nejjarineMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Nejjarine Fountain Square'**
  String get nejjarineMeetingLocation;

  /// No description provided for @nejjarineMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at the ornate 18th-century fountain in Nejjarine Square'**
  String get nejjarineMeetingDesc;

  /// No description provided for @darBathaIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Full access to all museum galleries and the Andalusian garden'**
  String get darBathaIncluded1;

  /// No description provided for @darBathaIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Exhibition of medieval Fasi ceramics, textiles, and metalwork'**
  String get darBathaIncluded2;

  /// No description provided for @darBathaIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Collection of carved stucco panels and ornate wooden ceilings'**
  String get darBathaIncluded3;

  /// No description provided for @darBathaIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Collection of rare Quranic manuscripts and ancient astrolabes'**
  String get darBathaIncluded4;

  /// No description provided for @darBathaIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Guided walk through the garden with its original 19th-century fountains'**
  String get darBathaIncluded5;

  /// No description provided for @darBathaInfo1.
  ///
  /// In en, this message translates to:
  /// **'Entrance fee approximately 70 MAD per person'**
  String get darBathaInfo1;

  /// No description provided for @darBathaInfo2.
  ///
  /// In en, this message translates to:
  /// **'The museum is closed on Tuesdays'**
  String get darBathaInfo2;

  /// No description provided for @darBathaInfo3.
  ///
  /// In en, this message translates to:
  /// **'Photography permitted in garden; some interior rooms restrict flash'**
  String get darBathaInfo3;

  /// No description provided for @darBathaInfo4.
  ///
  /// In en, this message translates to:
  /// **'Audio guides available in French and Arabic'**
  String get darBathaInfo4;

  /// No description provided for @darBathaMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Dar Batha Museum Main Gate'**
  String get darBathaMeetingLocation;

  /// No description provided for @darBathaMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Located near Bab Boujloud on Place de l\'Istiqlal'**
  String get darBathaMeetingDesc;

  /// No description provided for @merenidIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Free access to the tombs and surrounding hilltop viewpoint'**
  String get merenidIncluded1;

  /// No description provided for @merenidIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Panoramic 360° views over Fes el-Bali and Fes el-Jdid'**
  String get merenidIncluded2;

  /// No description provided for @merenidIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Historical context of the Marinid dynasty (1244–1465 CE)'**
  String get merenidIncluded3;

  /// No description provided for @merenidIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Identification of key medina landmarks from above'**
  String get merenidIncluded4;

  /// No description provided for @merenidIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Perfect sunset and night photography vantage point'**
  String get merenidIncluded5;

  /// No description provided for @merenidInfo1.
  ///
  /// In en, this message translates to:
  /// **'Access road is steep — wear comfortable walking shoes'**
  String get merenidInfo1;

  /// No description provided for @merenidInfo2.
  ///
  /// In en, this message translates to:
  /// **'The site is unlit at night — bring a torch if visiting after dark'**
  String get merenidInfo2;

  /// No description provided for @merenidInfo3.
  ///
  /// In en, this message translates to:
  /// **'Local guides and vendors present; agree on prices beforehand'**
  String get merenidInfo3;

  /// No description provided for @merenidInfo4.
  ///
  /// In en, this message translates to:
  /// **'Best visited at sunset for the most spectacular light over the medina'**
  String get merenidInfo4;

  /// No description provided for @merenidMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'North Medina Wall — Bab Guissa Area'**
  String get merenidMeetingLocation;

  /// No description provided for @merenidMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Take the road uphill from Bab Guissa; tombs are visible from road'**
  String get merenidMeetingDesc;

  /// No description provided for @jnanSbilIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Free access to all garden paths and green spaces'**
  String get jnanSbilIncluded1;

  /// No description provided for @jnanSbilIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Exploration of the historic water channel system'**
  String get jnanSbilIncluded2;

  /// No description provided for @jnanSbilIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Views of the adjacent Bou Jeloud royal palace walls'**
  String get jnanSbilIncluded3;

  /// No description provided for @jnanSbilIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Relaxation among fragrant orange and lemon trees'**
  String get jnanSbilIncluded4;

  /// No description provided for @jnanSbilIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Birdwatching — the garden hosts numerous migratory bird species'**
  String get jnanSbilIncluded5;

  /// No description provided for @jnanSbilInfo1.
  ///
  /// In en, this message translates to:
  /// **'The garden is free and open to all visitors'**
  String get jnanSbilInfo1;

  /// No description provided for @jnanSbilInfo2.
  ///
  /// In en, this message translates to:
  /// **'Opening hours: sunrise to sunset daily'**
  String get jnanSbilInfo2;

  /// No description provided for @jnanSbilInfo3.
  ///
  /// In en, this message translates to:
  /// **'Dress modestly out of respect for local families'**
  String get jnanSbilInfo3;

  /// No description provided for @jnanSbilInfo4.
  ///
  /// In en, this message translates to:
  /// **'Ideal for a rest break during a long medina walking tour'**
  String get jnanSbilInfo4;

  /// No description provided for @jnanSbilMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Bab Boujloud — Garden Entrance Gate'**
  String get jnanSbilMeetingLocation;

  /// No description provided for @jnanSbilMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter through the garden gate directly opposite Bab Boujloud Square'**
  String get jnanSbilMeetingDesc;

  /// No description provided for @zawiyaMoulayIdrissIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Viewing of the zawiya exterior and ornate surrounding streets'**
  String get zawiyaMoulayIdrissIncluded1;

  /// No description provided for @zawiyaMoulayIdrissIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Explanation of the life of Idris II and the founding of Fes'**
  String get zawiyaMoulayIdrissIncluded2;

  /// No description provided for @zawiyaMoulayIdrissIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Visit to the surrounding souk of candles and religious goods'**
  String get zawiyaMoulayIdrissIncluded3;

  /// No description provided for @zawiyaMoulayIdrissIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Historical context of Moroccan pilgrimage traditions'**
  String get zawiyaMoulayIdrissIncluded4;

  /// No description provided for @zawiyaMoulayIdrissIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Walk through the sanctuary boundary zone and its significance'**
  String get zawiyaMoulayIdrissIncluded5;

  /// No description provided for @zawiyaMoulayIdrissInfo1.
  ///
  /// In en, this message translates to:
  /// **'Non-Muslims may not enter the shrine interior'**
  String get zawiyaMoulayIdrissInfo1;

  /// No description provided for @zawiyaMoulayIdrissInfo2.
  ///
  /// In en, this message translates to:
  /// **'The area is sacred — speak quietly and dress respectfully'**
  String get zawiyaMoulayIdrissInfo2;

  /// No description provided for @zawiyaMoulayIdrissInfo3.
  ///
  /// In en, this message translates to:
  /// **'Photography inside or near the entrance is not permitted'**
  String get zawiyaMoulayIdrissInfo3;

  /// No description provided for @zawiyaMoulayIdrissInfo4.
  ///
  /// In en, this message translates to:
  /// **'The annual Moussem pilgrimage draws thousands — plan accordingly'**
  String get zawiyaMoulayIdrissInfo4;

  /// No description provided for @zawiyaMoulayIdrissMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Souk al-Attarine Entrance'**
  String get zawiyaMoulayIdrissMeetingLocation;

  /// No description provided for @zawiyaMoulayIdrissMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at Souk al-Attarine start — the zawiya is a 3-min walk'**
  String get zawiyaMoulayIdrissMeetingDesc;

  /// No description provided for @zawiyaTijaniaIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Guided viewing of the zawiya exterior and surrounding quarter'**
  String get zawiyaTijaniaIncluded1;

  /// No description provided for @zawiyaTijaniaIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Introduction to Tijaniyya Sufi history and its global reach'**
  String get zawiyaTijaniaIncluded2;

  /// No description provided for @zawiyaTijaniaIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Observation of the West African pilgrimage culture and traditions'**
  String get zawiyaTijaniaIncluded3;

  /// No description provided for @zawiyaTijaniaIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Visit to the nearby Sufi manuscript library (exterior)'**
  String get zawiyaTijaniaIncluded4;

  /// No description provided for @zawiyaTijaniaIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Context of Fes as a major center of Sufi scholarship'**
  String get zawiyaTijaniaIncluded5;

  /// No description provided for @zawiyaTijaniaInfo1.
  ///
  /// In en, this message translates to:
  /// **'Non-Muslims are generally not permitted in the inner sanctuary'**
  String get zawiyaTijaniaInfo1;

  /// No description provided for @zawiyaTijaniaInfo2.
  ///
  /// In en, this message translates to:
  /// **'Respect ongoing prayers and pilgrimage activities at all times'**
  String get zawiyaTijaniaInfo2;

  /// No description provided for @zawiyaTijaniaInfo3.
  ///
  /// In en, this message translates to:
  /// **'Photography of worshippers without consent is inappropriate'**
  String get zawiyaTijaniaInfo3;

  /// No description provided for @zawiyaTijaniaInfo4.
  ///
  /// In en, this message translates to:
  /// **'The surrounding quarter is quieter than the main medina souk area'**
  String get zawiyaTijaniaInfo4;

  /// No description provided for @zawiyaTijaniaMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Talaa Kebira — Tijania Quarter Junction'**
  String get zawiyaTijaniaMeetingLocation;

  /// No description provided for @zawiyaTijaniaMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at the junction of Talaa Kebira and the Tijania quarter lane'**
  String get zawiyaTijaniaMeetingDesc;

  /// No description provided for @royalPalaceIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Photo opportunity at the famous seven brass-gilded golden doors'**
  String get royalPalaceIncluded1;

  /// No description provided for @royalPalaceIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Explanation of Marinid dynastic history and palace expansion'**
  String get royalPalaceIncluded2;

  /// No description provided for @royalPalaceIncluded3.
  ///
  /// In en, this message translates to:
  /// **'View of the surrounding Fes el-Jdid quarter and mellah'**
  String get royalPalaceIncluded3;

  /// No description provided for @royalPalaceIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Walk along the palace exterior walls through the district'**
  String get royalPalaceIncluded4;

  /// No description provided for @royalPalaceIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Visit to the adjacent Place des Alaouites ceremonial square'**
  String get royalPalaceIncluded5;

  /// No description provided for @royalPalaceInfo1.
  ///
  /// In en, this message translates to:
  /// **'The palace interior is strictly closed to all visitors — no exceptions'**
  String get royalPalaceInfo1;

  /// No description provided for @royalPalaceInfo2.
  ///
  /// In en, this message translates to:
  /// **'Photography of the exterior doors and square is freely permitted'**
  String get royalPalaceInfo2;

  /// No description provided for @royalPalaceInfo3.
  ///
  /// In en, this message translates to:
  /// **'Guards are present — maintain respectful distance from the gates'**
  String get royalPalaceInfo3;

  /// No description provided for @royalPalaceInfo4.
  ///
  /// In en, this message translates to:
  /// **'Best time to visit is morning when brass doors catch the sunlight'**
  String get royalPalaceInfo4;

  /// No description provided for @royalPalaceMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Place des Alaouites'**
  String get royalPalaceMeetingLocation;

  /// No description provided for @royalPalaceMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at the flagpoles in Place des Alaouites, facing the golden doors'**
  String get royalPalaceMeetingDesc;

  /// No description provided for @andalusianIncluded1.
  ///
  /// In en, this message translates to:
  /// **'Viewing of the celebrated 12th-century Almohad carved stone doorway'**
  String get andalusianIncluded1;

  /// No description provided for @andalusianIncluded2.
  ///
  /// In en, this message translates to:
  /// **'Explanation of the Andalusian refugee community history in Fes'**
  String get andalusianIncluded2;

  /// No description provided for @andalusianIncluded3.
  ///
  /// In en, this message translates to:
  /// **'Walk through the quieter eastern Andalusian quarter of the medina'**
  String get andalusianIncluded3;

  /// No description provided for @andalusianIncluded4.
  ///
  /// In en, this message translates to:
  /// **'Comparison of eastern vs western medina architecture and character'**
  String get andalusianIncluded4;

  /// No description provided for @andalusianIncluded5.
  ///
  /// In en, this message translates to:
  /// **'Visit to the Andalusian souk — less touristy than the western side'**
  String get andalusianIncluded5;

  /// No description provided for @andalusianInfo1.
  ///
  /// In en, this message translates to:
  /// **'Non-Muslims may not enter the mosque interior'**
  String get andalusianInfo1;

  /// No description provided for @andalusianInfo2.
  ///
  /// In en, this message translates to:
  /// **'The exterior doorway is freely visible from the public street'**
  String get andalusianInfo2;

  /// No description provided for @andalusianInfo3.
  ///
  /// In en, this message translates to:
  /// **'The eastern medina (Andalous quarter) is less crowded than the west'**
  String get andalusianInfo3;

  /// No description provided for @andalusianInfo4.
  ///
  /// In en, this message translates to:
  /// **'Best combined with a walk along the scenic Oued Fes river channel'**
  String get andalusianInfo4;

  /// No description provided for @andalusianMeetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Bab Ftuh — Eastern Medina Gate'**
  String get andalusianMeetingLocation;

  /// No description provided for @andalusianMeetingDesc.
  ///
  /// In en, this message translates to:
  /// **'Meet at Bab Ftuh gate; the mosque is a 10-min walk into Andalusian quarter'**
  String get andalusianMeetingDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
