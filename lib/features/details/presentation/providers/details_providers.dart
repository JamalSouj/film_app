import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../media/domain/entities/episode.dart';
import '../../../media/domain/entities/movie_detail.dart';
import '../../../media/domain/entities/tv_detail.dart';
import '../../../media/presentation/providers/media_providers.dart';

final movieDetailProvider = FutureProvider.family<MovieDetail, int>((ref, id) {
  return ref.watch(getMovieDetailUseCaseProvider).execute(id);
});

final tvDetailProvider = FutureProvider.family<TvDetail, int>((ref, id) {
  return ref.watch(getTvDetailUseCaseProvider).execute(id);
});

final seasonEpisodesProvider = FutureProvider.family<List<Episode>, ({int tvId, int seasonNumber})>((ref, params) {
  return ref.watch(getSeasonEpisodesUseCaseProvider).execute(params.tvId, params.seasonNumber);
});

final selectedSeasonProvider = StateProvider.autoDispose<int>((ref) => 1);
