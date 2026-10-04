import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';

/// Root widget of the Film application.
///
/// Sets up [MaterialApp.router] with the custom dark theme
/// and go_router configuration.
class FilmApp extends StatelessWidget {
  const FilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Film',
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),
      routerConfig: appRouter,
    );
  }

  /// Constructs a deeply cinematic dark [ThemeData].
  ThemeData _buildDarkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        surface: AppColors.background,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
