import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../media/domain/entities/movie_detail.dart';
import '../../../media/domain/entities/tv_detail.dart';
import '../providers/details_providers.dart';
import '../widgets/cast_list.dart';
import '../widgets/season_episode_selector.dart';

/// Unified detail screen for movies and TV shows.
///
/// Receives [mediaType] (`'movie'` or `'tv'`) and [id] from the
/// router to decide which provider to watch.
///
/// Layout:
///  • [SliverAppBar] with parallax backdrop and gradient fade
///  • Poster thumbnail with [Hero] transition
///  • Metadata row (year, runtime/seasons, rating)
///  • Genre chips
///  • Synopsis paragraph
///  • "Watch Now" CTA
///  • Cast horizontal list
///  • Season / Episode selector (TV only)
class DetailsScreen extends ConsumerWidget {
  const DetailsScreen({
    super.key,
    required this.mediaType,
    required this.id,
  });

  final String mediaType;
  final int id;

  bool get _isMovie => mediaType == 'movie';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_isMovie) {
      return ref.watch(movieDetailProvider(id)).when(
            data: (movie) => _MovieDetailBody(movie: movie),
            loading: () => _buildLoading(),
            error: (e, _) => _buildError(context, e),
          );
    } else {
      return ref.watch(tvDetailProvider(id)).when(
            data: (show) => _TvDetailBody(show: show),
            loading: () => _buildLoading(),
            error: (e, _) => _buildError(context, e),
          );
    }
  }

  Widget _buildLoading() {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.lg),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.error, fontSize: 14),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Movie Detail Body
// ═══════════════════════════════════════════════════════════

class _MovieDetailBody extends StatelessWidget {
  const _MovieDetailBody({required this.movie});
  final MovieDetail movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _DetailSliverAppBar(
            backdropUrl: movie.backdropUrl,
            posterUrl: movie.posterHdUrl,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.md),
                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppDimens.sm),

                  // Meta row
                  _MetaRow(items: [
                    if (movie.year.isNotEmpty) movie.year,
                    if (movie.runtimeLabel.isNotEmpty) movie.runtimeLabel,
                    '⭐ ${movie.ratingLabel}',
                  ]),
                  const SizedBox(height: AppDimens.sm),

                  // Genres
                  if (movie.genres.isNotEmpty) _GenreChips(
                    labels: movie.genres.map((g) => g.name).toList(),
                  ),
                  const SizedBox(height: AppDimens.md),

                  // Overview
                  if (movie.overview != null && movie.overview!.isNotEmpty)
                    Text(
                      movie.overview!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: AppDimens.lg),

                  // Watch Now button
                  _WatchButton(
                    onTap: () => context.push('/player/movie/${movie.id}'),
                  ),
                ],
              ),
            ),
          ),

          // Cast
          SliverToBoxAdapter(
            child: CastList(cast: movie.credits?.cast ?? []),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimens.xxl),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TV Detail Body
// ═══════════════════════════════════════════════════════════

class _TvDetailBody extends StatelessWidget {
  const _TvDetailBody({required this.show});
  final TvDetail show;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _DetailSliverAppBar(
            backdropUrl: show.backdropUrl,
            posterUrl: show.posterHdUrl,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.md),
                  // Title
                  Text(
                    show.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppDimens.sm),

                  // Meta row
                  _MetaRow(items: [
                    if (show.year.isNotEmpty) show.year,
                    '${show.numberOfSeasons} Season${show.numberOfSeasons != 1 ? 's' : ''}',
                    '⭐ ${show.ratingLabel}',
                  ]),
                  const SizedBox(height: AppDimens.sm),

                  // Genres
                  if (show.genres.isNotEmpty) _GenreChips(
                    labels: show.genres.map((g) => g.name).toList(),
                  ),
                  const SizedBox(height: AppDimens.md),

                  // Overview
                  if (show.overview != null && show.overview!.isNotEmpty)
                    Text(
                      show.overview!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: AppDimens.lg),

                  // Watch Now (Season 1 Episode 1 default)
                  _WatchButton(
                    onTap: () =>
                        context.push('/player/tv/${show.id}?season=1&episode=1'),
                  ),
                ],
              ),
            ),
          ),

          // Cast
          SliverToBoxAdapter(
            child: CastList(cast: show.credits?.cast ?? []),
          ),

          // Seasons & Episodes
          SliverToBoxAdapter(
            child: SeasonEpisodeSelector(
              tvId: show.id,
              seasons: show.regularSeasons,
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimens.xxl),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Shared Detail Widgets
// ═══════════════════════════════════════════════════════════

/// Collapsing app bar with a parallax backdrop, gradient fade,
/// and back button. Includes a [Hero]‑wrapped poster thumbnail.
class _DetailSliverAppBar extends StatelessWidget {
  const _DetailSliverAppBar({
    required this.backdropUrl,
    required this.posterUrl,
  });

  final String backdropUrl;
  final String posterUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppDimens.appBarExpandedHeight,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: _GlassBackButton(onTap: () => context.pop()),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop image
            if (backdropUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: backdropUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.surface),
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.surface),
              ),

            // Gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.5),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),

            // Poster thumbnail
            Positioned(
              left: AppDimens.md,
              bottom: AppDimens.md,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: posterUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.movie_rounded,
                              color: AppColors.textTertiary),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Frosted‑glass circular back button.
class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Row of metadata chips (year, runtime, rating, etc.).
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimens.sm,
      runSpacing: AppDimens.xs,
      children: items
          .expand((item) => [
                if (items.indexOf(item) > 0)
                  const Text(
                    '·',
                    style: TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ])
          .toList(),
    );
  }
}

/// Horizontal wrap of genre chips.
class _GenreChips extends StatelessWidget {
  const _GenreChips({required this.labels});
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.sm,
      runSpacing: AppDimens.xs,
      children: labels.map((label) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppDimens.radiusXl),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Gradient "Watch Now" CTA button.
class _WatchButton extends StatelessWidget {
  const _WatchButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Watch Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
