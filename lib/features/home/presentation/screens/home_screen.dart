import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../media/domain/entities/media.dart';
import '../providers/home_providers.dart';
import '../../../../shared/widgets/media_section.dart';

/// The main landing screen.
///
/// Layout (inside a [CustomScrollView]):
///  1. Featured hero banner (first trending item)
///  2. Horizontal carousels: Trending · Top Rated · Action · Sci‑Fi
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(trendingProvider);
          ref.invalidate(topRatedProvider);
          ref.invalidate(actionMoviesProvider);
          ref.invalidate(sciFiMoviesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // ── Featured banner ────────────────────────────
            SliverToBoxAdapter(
              child: trending.when(
                data: (list) =>
                    list.isNotEmpty ? _FeaturedBanner(media: list.first) : const SizedBox.shrink(),
                loading: () => const _FeaturedBannerShimmer(),
                error: (_, __) => const SizedBox(height: 200),
              ),
            ),

            // ── Trending ───────────────────────────────────
            SliverToBoxAdapter(
              child: MediaSection(
                title: '🔥 Trending This Week',
                asyncMedia: trending,
              ),
            ),

            // ── Top Rated ──────────────────────────────────
            SliverToBoxAdapter(
              child: MediaSection(
                title: '⭐ Top Rated',
                asyncMedia: ref.watch(topRatedProvider),
              ),
            ),

            // ── Action ─────────────────────────────────────
            SliverToBoxAdapter(
              child: MediaSection(
                title: '💥 Action',
                asyncMedia: ref.watch(actionMoviesProvider),
              ),
            ),

            // ── Sci‑Fi ─────────────────────────────────────
            SliverToBoxAdapter(
              child: MediaSection(
                title: '🚀 Sci‑Fi',
                asyncMedia: ref.watch(sciFiMoviesProvider),
              ),
            ),

            // ── Bottom padding for the glass nav bar ───────
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppDimens.navBarHeight +
                    MediaQuery.of(context).padding.bottom +
                    AppDimens.lg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Featured Banner
// ═══════════════════════════════════════════════════════════

/// A large cinematic banner showcasing the first trending item.
///
/// Uses a stacked layout:
///  • Full‑bleed backdrop image
///  • Bottom gradient fade into the background colour
///  • Title, overview excerpt, and a "Watch Now" pill button
class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({required this.media});
  final Media media;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/details/${media.resolvedMediaType}/${media.id}',
      ),
      child: SizedBox(
        height: 480,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop
            if (media.backdropUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: media.backdropUrl,
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
                    AppColors.background.withValues(alpha: 0.3),
                    AppColors.background.withValues(alpha: 0.85),
                    AppColors.background,
                  ],
                  stops: const [0.15, 0.45, 0.75, 1.0],
                ),
              ),
            ),

            // Content
            Positioned(
              left: AppDimens.md,
              right: AppDimens.md,
              bottom: AppDimens.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    media.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppDimens.sm),
                  // Overview
                  if (media.overview != null && media.overview!.isNotEmpty)
                    Text(
                      media.overview!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: AppDimens.md),
                  // CTA button
                  _WatchNowPill(media: media),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Gradient‑filled "Watch Now" pill button.
class _WatchNowPill extends StatelessWidget {
  const _WatchNowPill({required this.media});
  final Media media;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(AppDimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
          SizedBox(width: 6),
          Text(
            'Watch Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder while the featured banner loads.
class _FeaturedBannerShimmer extends StatelessWidget {
  const _FeaturedBannerShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 480,
      color: AppColors.surface,
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
