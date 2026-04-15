# 🕌 Visit Fes – Mobile Travel Guide

> A Flutter tourism app to discover the historic city of Fes, Morocco.

---

## 📱 About the App

**Visit Fes** is a mobile travel guide built with Flutter & Dart, designed to help tourists explore the cultural and historical richness of Fes, Morocco. The app provides a complete digital experience — from discovering historic sites to navigating the city with an interactive map.

---

##  Features

-  **Interactive Map** — Explore all attractions with Google Maps integration and custom location markers
-  **Historic Sites** — Browse and filter historical landmarks with detailed information
- **Favorites** — Save and manage your favorite places, food, and hotels
-  **Multi-language Support** — Available in 🇩🇪 Deutsch, 🇬🇧 English, 🇸🇦 العربية, 🇫🇷 Français, 🇪🇸 Español
-  **Local Culture** — Discover the food, shopping, and transport of Fes
-  **Search** — Search favorites and places quickly
-  **My Account** — Manage settings, language, and share the app

---

##  App Screens

###  Start Screen
![Start](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/01_start.jpeg)

###  Home – Info & Attractions
![Home Info](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/02_home_info.jpeg)

###  Home – Transport & Culture
![Home Transport](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/03_home_transport.jpeg)

###  Historic Sites
![Historic Sites](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/04_historic.jpeg)

###  Al-Qarawiyyin – Detail
![Al-Qarawiyyin](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/05_qarawiyyin.jpeg)

###  Al-Qarawiyyin – More Info
![Al-Qarawiyyin Detail](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/06_qarawiyyin_detail.jpeg)

###  Favorites
![Favorites](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/07_favorites.jpeg)

###  Favorites – Search
![Favorites Search](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/08_favorites_search.jpeg)

###  Account
![Account](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/09_account.jpeg)

###  Language Selector
![Language](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/10_language.jpeg)

###  Map – Overview
![Map](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/11_map.jpeg)

###  Map – Search
![Map Search](https://raw.githubusercontent.com/houssamchaibi-hub/Visit-Fes/main/assets/screenshots/12_map_search.jpeg)

---

##  Tech Stack

| Technology | Usage |
|---|---|
| **Flutter** | Cross-platform mobile development |
| **Dart** | Programming language |
| **Google Maps API** | Interactive map & location markers |
| **Custom UI/UX** | Intuitive design with orange & dark theme |

---

##  Getting Started

```bash
# Clone the repository
git clone https://github.com/houssamchaibi-hub/Visit-Fes.git

# Navigate to the project
cd Visit-Fes

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

##  Project Structure

```
lib/
├── screens/         # All app screens (home, map, favorites, account...)
├── widgets/         # Reusable UI components
├── models/          # Data models
├── services/        # API & map services
└── main.dart        # Entry point
```

---

##  Architecture

The project follows a clean, feature-oriented architecture that separates responsibilities clearly across layers. This makes the codebase easy to maintain, extend, and understand.

```
lib/
├── main.dart              # App entry point, theme & routing setup
│
├── screens/               # Full-page UI screens
│   ├── home_screen.dart
│   ├── map_screen.dart
│   ├── favorites_screen.dart
│   ├── account_screen.dart
│   └── detail_screen.dart
│
├── widgets/               # Reusable UI components shared across screens
│   ├── place_card.dart
│   ├── category_chip.dart
│   ├── language_selector.dart
│   └── custom_marker.dart
│
├── models/                # Data models representing app entities
│   ├── place.dart
│   ├── category.dart
│   └── user_preferences.dart
│
└── services/              # Business logic & external integrations
    ├── map_service.dart
    ├── favorites_service.dart
    └── localization_service.dart
```

**Layer responsibilities:**

- **Screens** handle page-level layout and user interactions
- **Widgets** are small, stateless or stateful components reused across multiple screens
- **Models** define structured data classes (e.g., `Place`, `Category`)
- **Services** contain all logic related to APIs, local storage, and localization — keeping screens clean and focused

---

##  Technical Implementation

###  Navigation Structure
The app uses Flutter's built-in `Navigator` with named routes defined in `main.dart`. A `BottomNavigationBar` manages the four main sections: Home, Map, Favorites, and Account. Each section is a separate screen, ensuring a clear and intuitive user flow.

###  Reusable Widgets
Common UI elements such as place cards, category chips, and the language selector are extracted into standalone widget files under `widgets/`. This avoids code duplication, improves readability, and makes future updates easier to apply consistently across the app.

###  Separation of Concerns
Business logic is intentionally kept out of the UI layer. Screens only handle what the user sees and does. All data operations, favorites management, and language handling are delegated to dedicated service classes. This separation makes each part of the app independently testable and easier to maintain.

###  Google Maps API Integration
The app integrates the `google_maps_flutter` package to render an interactive map of Fes. Custom markers are placed for each attraction, and tapping a marker opens a detail view. The `MapService` handles marker generation and map camera positioning, keeping the map screen clean.

###  Multi-language System
The app supports five languages (German, English, Arabic, French, Spanish) using Flutter's localization system. Language preferences are stored locally and applied at runtime, including RTL layout support for Arabic. The `LocalizationService` manages language switching without requiring an app restart.

---

##  Challenges & Learning

Building **Visit Fes** from scratch as a self-taught developer was a significant learning experience. Here are the key areas I grew in:

###  Managing Multiple Screens
One of the first challenges was structuring navigation between several screens while maintaining a consistent state — for example, keeping the favorites list synchronized across the Favorites screen and individual detail pages. This taught me how to think about app-level state and when to lift state up.

###  Structuring a Flutter Project
At the start, all code lived in a few large files. Over time, I refactored the project into a layered structure (screens / widgets / services / models), which made the codebase significantly easier to navigate and extend. This experience gave me a solid understanding of why clean architecture matters in practice.

###  API Integration
Integrating the Google Maps API introduced me to working with third-party packages, handling API keys securely, and rendering dynamic map content. Debugging map marker rendering and camera behavior required patience and careful reading of the documentation.

###  UI/UX Design
Designing a consistent visual identity — an orange and dark color palette inspired by the warm tones of Fes — taught me about theming in Flutter, building responsive layouts, and making design decisions with the end user in mind. I learned that good UI is not just about looks, but about clarity and ease of use.

---

##  Supported Languages

- 🇩🇪 Deutsch
- 🇬🇧 English
- 🇸🇦 العربية
- 🇫🇷 Français
- 🇪🇸 Español

---

##  Developer

**Houssam Chaibi**
Self-taught Flutter Developer | Fes, Morocco

I am a passionate junior mobile developer focused on building clean, user-friendly Flutter applications. *Visit Fes* is one of my flagship personal projects, demonstrating my ability to independently design, develop, and ship a full-featured cross-platform app — from UI design and API integration to multi-language support and project architecture.

📧 houssamchaibi2006@gmail.com
 [github.com/houssamchaibi-hub](https://github.com/houssamchaibi-hub)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

> *Developed independently as a personal portfolio project — from initial concept and UI design to full implementation and deployment. Every line of code, every screen, and every feature was built and iterated upon through self-study, experimentation, and a genuine passion for mobile development.*
