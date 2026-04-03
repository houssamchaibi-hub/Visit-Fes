// lib/presentation/home/config/home_constants.dart

import 'package:flutter/material.dart';

/// Constants for home page
class HomeConstants {
  // Animation durations
  static const Duration fabAnimationDuration = Duration(milliseconds: 300);
  static const Duration filterAnimationDuration = Duration(milliseconds: 400);
  static const Duration snackBarDuration = Duration(seconds: 2);

  // UI constants
  static const double maxPlaceCardHeight = 240.0;
  static const double minPlaceCardHeight = 180.0;

  // Private constructor to prevent instantiation
  HomeConstants._();
}

/// Home tab enum
enum HomeTab {
  home,
  search,
  destinations,
  account;

  static HomeTab fromIndex(int idx) {
    return HomeTab.values[idx];
  }

  int get tabIndex => this.index;
}