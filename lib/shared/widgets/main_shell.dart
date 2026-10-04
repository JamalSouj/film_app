import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// The root shell widget that provides a glassmorphic bottom navigation bar.
///
/// Used as the builder for [ShellRoute] so that the Home and Search
/// screens share a persistent navigation scaffold.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  /// The currently active route's widget.
  final Widget child;

  // Navigation destinations and their corresponding route paths.
  static const _destinations = [
    _NavItem(icon: Icons.home_rounded, label: 'Home', path: '/home'),
    _NavItem(icon: Icons.search_rounded, label: 'Search', path: '/search'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: _GlassNavBar(
        currentPath: GoRouterState.of(context).uri.toString(),
        destinations: _destinations,
      ),
    );
  }
}

// ── Private helper types ───────────────────────────────────

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
  });
  final IconData icon;
  final String label;
  final String path;
}

/// A frosted‑glass bottom navigation bar.
///
/// Applies a [BackdropFilter] blur over the content scrolling
/// beneath it, giving the cinematic "glassmorphism" effect.
class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.currentPath,
    required this.destinations,
  });

  final String currentPath;
  final List<_NavItem> destinations;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Clip the blur so it doesn't bleed outside rounded corners.
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimens.radiusLg),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: AppDimens.navBarHeight +
              MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.glass,
            border: const Border(
              top: BorderSide(color: AppColors.border, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: destinations.map((dest) {
              final isActive = currentPath.startsWith(dest.path);
              return _NavBarButton(
                icon: dest.icon,
                label: dest.label,
                isActive: isActive,
                onTap: () {
                  if (!isActive) context.go(dest.path);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimens.xs),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
