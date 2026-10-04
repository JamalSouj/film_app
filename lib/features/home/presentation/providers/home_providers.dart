import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../media/domain/entities/media.dart';
import '../../../media/presentation/providers/media_providers.dart';

final trendingProvider = FutureProvider<List<Media>>((ref) {
  return ref.watch(getTrendingMediaUseCaseProvider).execute();
});

final topRatedProvider = FutureProvider<List<Media>>((ref) {
  return ref.watch(getTopRatedMediaUseCaseProvider).execute();
});

final actionMoviesProvider = FutureProvider<List<Media>>((ref) {
  return ref.watch(discoverMediaByGenreUseCaseProvider).execute(28);
});

final sciFiMoviesProvider = FutureProvider<List<Media>>((ref) {
  return ref.watch(discoverMediaByGenreUseCaseProvider).execute(878);
});
