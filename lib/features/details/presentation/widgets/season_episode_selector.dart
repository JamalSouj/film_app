import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../media/domain/entities/episode.dart';
import '../../../media/domain/entities/season.dart';
import '../providers/details_providers.dart';

/// Combined Season dropdown + Episode list for TV show detail pages.
///
/// Watches [selectedSeasonProvider] and [seasonEpisodesProvider]
/// to dynamically load episodes when the user picks a season.
class SeasonEpisodeSelector extends ConsumerWidget {
  const SeasonEpisodeSelector({
    super.key,
    required this.tvId,
    required this.seasons,
  });

  final int tvId;
  final List<Season> seasons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (seasons.isEmpty) return const SizedBox.shrink();

    final selectedSeason = ref.watch(selectedSeasonProvider);
    final episodesAsync = ref.watch(
      seasonEpisodesProvider((tvId: tvId, seasonNumber: selectedSeason)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header + Dropdown ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.md, AppDimens.lg, AppDimens.md, AppDimens.sm,
          ),
          child: Row(
            children: [
              const Text(
                'Episodes',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              // Season picker
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: selectedSeason,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary, size: 20),
                    isDense: true,
                    items: seasons.map((s) {
                      return DropdownMenuItem<int>(
                        value: s.seasonNumber,
                        child: Text(s.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(selectedSeasonProvider.notifier).state = value;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Episode list ───────────────────────────────────
        episodesAsync.when(
          data: (episodes) => _EpisodeListView(
            tvId: tvId,
            season: selectedSeason,
            episodes: episodes,
          ),
          loading: () => _buildShimmer(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(AppDimens.md),
            child: Text(
              e.toString(),
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surface.withValues(alpha: 0.7),
      child: Column(
        children: List.generate(
          4,
          (_) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.md, vertical: AppDimens.xs),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Episode List
// ═══════════════════════════════════════════════════════════

class _EpisodeListView extends StatelessWidget {
  const _EpisodeListView({
    required this.tvId,
    required this.season,
    required this.episodes,
  });

  final int tvId;
  final int season;
  final List<Episode> episodes;

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppDimens.lg),
        child: Center(
          child: Text(
            'No episodes available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final ep = episodes[index];
        return _EpisodeTile(tvId: tvId, season: season, episode: ep);
      },
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({
    required this.tvId,
    required this.season,
    required this.episode,
  });

  final int tvId;
  final int season;
  final Episode episode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.sm),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          onTap: () => context.push(
            '/player/tv/$tvId?season=$season&episode=${episode.episodeNumber}',
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.sm),
            child: Row(
              children: [
                // Still image
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 120,
                    height: 68,
                    child: episode.stillUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: episode.stillUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: AppColors.background),
                            errorWidget: (_, __, ___) =>
                                Container(color: AppColors.background),
                          )
                        : Container(
                            color: AppColors.background,
                            child: const Icon(Icons.play_circle_outline,
                                color: AppColors.textTertiary),
                          ),
                  ),
                ),
                const SizedBox(width: AppDimens.sm),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${episode.shortLabel} · ${episode.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (episode.overview != null &&
                          episode.overview!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          episode.overview!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Play icon
                const Icon(Icons.play_arrow_rounded,
                    color: AppColors.primary, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
