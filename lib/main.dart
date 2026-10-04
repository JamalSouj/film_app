import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';

/// Application entry point.
///
/// Initialises:
///  1. Flutter engine bindings
///  2. Environment variables from `.env`
///  3. Hive local storage
///  4. Forces portrait orientation on startup
///  5. Wraps the widget tree in a [ProviderScope] for Riverpod
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables.
  await dotenv.load(fileName: '.env');

  // Initialise Hive for local caching (favorites, watch history).
  await Hive.initFlutter();

  // Lock orientation to portrait by default; the player screen
  // will temporarily switch to landscape when active.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Apply a dark system UI overlay style.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0D12),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: FilmApp(),
    ),
  );
}
