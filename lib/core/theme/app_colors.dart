import 'package:flutter/material.dart';

/// Centralised color tokens for the cinematic dark design language.
///
/// Every colour used throughout the app should reference this class
/// to ensure visual consistency and allow painless theme tweaks.
abstract final class AppColors {
  // ── Backgrounds ──────────────────────────────────────────
  /// Main scaffold background — near‑black with a hint of blue.
  static const Color background = Color(0xFF0D0D12);

  /// Slightly lighter surface for cards, bottom sheets, etc.
  static const Color surface = Color(0xFF16161E);

  /// Glass‑tinted surface used behind [BackdropFilter] widgets.
  static const Color glass = Color(0x33FFFFFF);

  /// Subtle card/container border colour.
  static const Color border = Color(0x1AFFFFFF);

  // ── Brand / Accent ───────────────────────────────────────
  /// Primary brand accent (electric indigo).
  static const Color primary = Color(0xFF6C63FF);

  /// Secondary accent (soft cyan).
  static const Color secondary = Color(0xFF00D9FF);

  /// Gradient start → end for CTA buttons / highlights.
  static const LinearGradient accentGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Text ─────────────────────────────────────────────────
  /// High‑emphasis body text.
  static const Color textPrimary = Color(0xFFF0F0F5);

  /// Medium‑emphasis secondary text / subtitles.
  static const Color textSecondary = Color(0xFF8E8E9A);

  /// Low‑emphasis / disabled text.
  static const Color textTertiary = Color(0xFF5A5A66);

  // ── Semantic ─────────────────────────────────────────────
  /// Rating stars, IMDB-style badges.
  static const Color rating = Color(0xFFFFD700);

  /// Error / destructive actions.
  static const Color error = Color(0xFFFF4D6A);

  /// Success feedback.
  static const Color success = Color(0xFF00E676);
}
