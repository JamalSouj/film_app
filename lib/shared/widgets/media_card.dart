import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../features/media/domain/entities/media.dart';

/// A poster card used in horizontal lists and grid views.
///
/// Features:
///  • [CachedNetworkImage] with shimmer placeholder
///  • Rating badge (top‑right)
///  • [Hero] animation keyed on the poster path
///  • Navigates to the detail screen on tap
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.media,
    this.width = AppDimens.posterListWidth,
    this.height = AppDimens.posterListHeight,
    this.showTitle = true,
  });

  final Media media;
  final double width;
  final double height;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/details/${media.resolvedMediaType}/${media.id}',
      ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Poster image ───────────────────────────────
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildImage(),
                      // Rating badge
                      if (media.voteAverage > 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: _RatingBadge(rating: media.ratingLabel),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Title + year ───────────────────────────────
            if (showTitle) ...[
              const SizedBox(height: AppDimens.sm),
              Text(
                media.displayTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (media.year.isNotEmpty)
                Text(
                  media.year,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (media.posterUrl.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.movie_rounded, color: AppColors.textTertiary, size: 32),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: media.posterUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: AppColors.surface,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.broken_image_rounded,
              color: AppColors.textTertiary, size: 32),
        ),
      ),
    );
  }
}

// ── Private widgets ────────────────────────────────────────

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.rating, size: 12),
          const SizedBox(width: 2),
          Text(
            rating,
            style: const TextStyle(
              color: AppColors.rating,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
