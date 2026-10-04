import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../features/media/domain/entities/media.dart';
import 'media_card.dart';

/// A horizontal scrolling section consisting of a title header
/// and a list of [MediaCard] widgets.
///
/// Accepts an [AsyncValue<List<Media>>] so it can display shimmer
/// loading, error, and data states autonomously.
class MediaSection extends ConsumerWidget {
  const MediaSection({
    super.key,
    required this.title,
    required this.asyncMedia,
  });

  /// Section heading displayed above the list.
  final String title;

  /// The async state of the media list, typically provided by
  /// a Riverpod [FutureProvider].
  final AsyncValue<List<Media>> asyncMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.md, AppDimens.lg, AppDimens.md, AppDimens.sm,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),

        // ── Content area ───────────────────────────────────
        SizedBox(
          height: AppDimens.posterListHeight + 44, // poster + title lines
          child: asyncMedia.when(
            data: (media) => _buildList(media),
            loading: _buildShimmer,
            error: (e, _) => _buildError(e),
          ),
        ),
      ],
    );
  }

  // ── List view ────────────────────────────────────────────

  Widget _buildList(List<Media> media) {
    if (media.isEmpty) {
      return const Center(
        child: Text(
          'Nothing to show',
          style: TextStyle(color: AppColors.textTertiary),
        ),
      );
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
      itemCount: media.length,
      separatorBuilder: (_, __) => const SizedBox(width: AppDimens.sm),
      itemBuilder: (_, i) => MediaCard(media: media[i]),
    );
  }

  // ── Shimmer skeleton ─────────────────────────────────────

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surface.withValues(alpha: 0.7),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimens.sm),
        itemBuilder: (_, __) => Container(
          width: AppDimens.posterListWidth,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
    );
  }

  // ── Error fallback ───────────────────────────────────────

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.lg),
        child: Text(
          error.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error, fontSize: 13),
        ),
      ),
    );
  }
}
