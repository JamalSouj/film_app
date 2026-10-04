import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../media/domain/entities/media.dart';
import '../providers/search_providers.dart';
import '../../../../shared/widgets/media_card.dart';

/// Real‑time search screen with debounced API calls.
///
/// Layout:
///  • Frosted‑glass search bar pinned at the top
///  • Responsive grid of results (adapts columns to screen width)
///  • Shimmer skeleton while loading, empty states for no query / no results
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.md, AppDimens.md, AppDimens.md, AppDimens.sm,
              ),
              child: _GlassSearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                onClear: () {
                  _controller.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
            ),

            // ── Results area ───────────────────────────────
            Expanded(
              child: query.trim().length < 2
                  ? _buildEmptyState()
                  : results.when(
                      data: (media) => media.isEmpty
                          ? _buildNoResults()
                          : _buildGrid(media),
                      loading: () => _buildShimmerGrid(),
                      error: (e, _) => _buildError(e),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── States ───────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded,
              size: 64, color: AppColors.textTertiary.withValues(alpha: 0.5)),
          const SizedBox(height: AppDimens.md),
          const Text(
            'Search movies & TV shows',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return const Center(
      child: Text(
        'No results found',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.lg),
        child: Text(
          error.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error, fontSize: 14),
        ),
      ),
    );
  }

  // ── Grid ─────────────────────────────────────────────────

  Widget _buildGrid(List<Media> media) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        AppDimens.md,
        AppDimens.sm,
        AppDimens.md,
        AppDimens.navBarHeight +
            MediaQuery.of(context).padding.bottom +
            AppDimens.md,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180,
        childAspectRatio: AppDimens.posterAspectRatio,
        crossAxisSpacing: AppDimens.sm,
        mainAxisSpacing: AppDimens.md,
      ),
      itemCount: media.length,
      itemBuilder: (_, i) => MediaCard(
        media: media[i],
        showTitle: true,
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surface.withValues(alpha: 0.7),
      child: GridView.builder(
        padding: const EdgeInsets.all(AppDimens.md),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          childAspectRatio: AppDimens.posterAspectRatio,
          crossAxisSpacing: AppDimens.sm,
          mainAxisSpacing: AppDimens.md,
        ),
        itemCount: 12,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Glass Search Bar
// ═══════════════════════════════════════════════════════════

class _GlassSearchBar extends StatelessWidget {
  const _GlassSearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.glass,
            borderRadius: BorderRadius.circular(AppDimens.radiusLg),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: 'Search movies & shows…',
              hintStyle: const TextStyle(
                  color: AppColors.textTertiary, fontSize: 15),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.textSecondary, size: 22),
              suffixIcon: controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textSecondary, size: 20),
                      onPressed: onClear,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            ),
          ),
        ),
      ),
    );
  }
}
