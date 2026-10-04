import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../media/domain/entities/cast_member.dart';

/// Horizontal scrolling list of cast member avatars and names.
///
/// Each entry shows a circular profile image (or a placeholder icon),
/// the actor's name, and optionally their character name.
class CastList extends StatelessWidget {
  const CastList({super.key, required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.md, AppDimens.lg, AppDimens.md, AppDimens.sm,
          ),
          child: Text(
            'Cast',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.md),
            itemCount: cast.length.clamp(0, 20), // cap at 20
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppDimens.md),
            itemBuilder: (_, i) => _CastAvatar(member: cast[i]),
          ),
        ),
      ],
    );
  }
}

class _CastAvatar extends StatelessWidget {
  const _CastAvatar({required this.member});
  final CastMember member;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.surface,
            child: ClipOval(
              child: member.profileUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: member.profileUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Icon(
                        Icons.person_rounded,
                        color: AppColors.textTertiary,
                        size: 28,
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.person_rounded,
                        color: AppColors.textTertiary,
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.person_rounded,
                      color: AppColors.textTertiary,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(height: AppDimens.xs),
          // Name
          Text(
            member.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Character
          if (member.character != null && member.character!.isNotEmpty)
            Text(
              member.character!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}
