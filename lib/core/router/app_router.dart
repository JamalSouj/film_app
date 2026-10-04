import 'package:go_router/go_router.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/details/presentation/screens/details_screen.dart';
import '../../features/player/presentation/screens/player_screen.dart';
import '../../shared/widgets/main_shell.dart';

/// Declarative router configuration using [GoRouter].
///
/// Route tree:
/// ```
/// /                          → MainShell (bottom‑nav scaffold)
///   ├─ /home                 → HomeScreen
///   ├─ /search               → SearchScreen
/// /details/:mediaType/:id    → DetailsScreen
/// /player/:mediaType/:id     → PlayerScreen (optional season/episode query params)
/// ```
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // ── Shell with bottom navigation ──────────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
      ],
    ),

    // ── Detail screen (shared for movies & TV shows) ──────
    GoRoute(
      path: '/details/:mediaType/:id',
      name: 'details',
      builder: (context, state) {
        final mediaType = state.pathParameters['mediaType']!;
        final id = int.parse(state.pathParameters['id']!);
        return DetailsScreen(mediaType: mediaType, id: id);
      },
    ),

    // ── Player screen ─────────────────────────────────────
    GoRoute(
      path: '/player/:mediaType/:id',
      name: 'player',
      builder: (context, state) {
        final mediaType = state.pathParameters['mediaType']!;
        final id = int.parse(state.pathParameters['id']!);
        final season = int.tryParse(
          state.uri.queryParameters['season'] ?? '',
        );
        final episode = int.tryParse(
          state.uri.queryParameters['episode'] ?? '',
        );
        return PlayerScreen(
          mediaType: mediaType,
          id: id,
          season: season,
          episode: episode,
        );
      },
    ),
  ],
);
