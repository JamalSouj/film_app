import 'package:flutter/material.dart';

/// Re‑usable spacing & sizing constants.
///
/// Having a single source for spacing avoids "magic numbers"
/// scattered across widget trees and keeps the layout rhythm consistent.
abstract final class AppDimens {
  // ── Spacing scale ────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ── Border radii ─────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // ── Poster / card aspect ratios ──────────────────────────
  /// Standard movie poster aspect ratio (2:3).
  static const double posterAspectRatio = 2 / 3;

  /// Backdrop / banner aspect ratio (16:9).
  static const double backdropAspectRatio = 16 / 9;

  // ── Poster grid defaults ─────────────────────────────────
  /// Minimum poster width used to calculate crossAxisCount in
  /// responsive grid layouts.
  static const double posterMinWidth = 120.0;

  // ── Horizontal list heights ──────────────────────────────
  static const double posterListHeight = 220.0;
  static const double posterListWidth = 140.0;

  // ── App bar / navigation ─────────────────────────────────
  static const double navBarHeight = 72.0;
  static const double appBarExpandedHeight = 400.0;

  // ── Standard padding helpers ─────────────────────────────
  static const EdgeInsets pagePadding =
      EdgeInsets.symmetric(horizontal: md, vertical: sm);

  static const EdgeInsets cardPadding = EdgeInsets.all(md);
}
