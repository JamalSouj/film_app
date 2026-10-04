import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Compile‑time / environment‑driven constants for the application.
///
/// All values that might change between environments (dev / staging / prod)
/// are read from `.env` via [flutter_dotenv] so that no secrets are
/// hard‑coded into the repository.
abstract final class AppConstants {
  // ── TMDB ─────────────────────────────────────────────────
  /// The Movie Database v3 API key.
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  /// TMDB REST base URL.
  static String get tmdbBaseUrl =>
      dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';

  /// Base URL for TMDB images (append size + path).
  static String get tmdbImageBaseUrl =>
      dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p';

  // ── Image size helpers ───────────────────────────────────
  /// Poster thumbnail (list views).
  static String posterUrl(String? path) =>
      path != null ? '$tmdbImageBaseUrl/w342$path' : '';

  /// High‑resolution poster (detail screen).
  static String posterHdUrl(String? path) =>
      path != null ? '$tmdbImageBaseUrl/w780$path' : '';

  /// Backdrop image (detail headers / banners).
  static String backdropUrl(String? path) =>
      path != null ? '$tmdbImageBaseUrl/w1280$path' : '';

  /// Small profile image for cast avatars.
  static String profileUrl(String? path) =>
      path != null ? '$tmdbImageBaseUrl/w185$path' : '';

  // ── Vidking Streaming ────────────────────────────────────
  /// Base URL for Vidking embeds.
  static String get vidkingBaseUrl =>
      dotenv.env['VIDKING_BASE_URL'] ?? 'https://www.vidking.net/embed';

  /// Constructs the movie embed URL.
  static String movieStreamUrl(int tmdbId) => '$vidkingBaseUrl/movie/$tmdbId';

  /// Constructs the TV show embed URL.
  static String tvStreamUrl(int tmdbId, int season, int episode) =>
      '$vidkingBaseUrl/tv/$tmdbId/$season/$episode';

  // ── Miscellaneous ────────────────────────────────────────
  /// Default debounce duration for the search input.
  static const Duration searchDebounce = Duration(milliseconds: 500);
}
