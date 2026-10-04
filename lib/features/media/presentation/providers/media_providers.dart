import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/tmdb_remote_data_source.dart';
import '../../data/repositories/media_repository_impl.dart';
import '../../domain/repositories/media_repository.dart';
import '../../domain/usecases/discover_media_by_genre.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_season_episodes.dart';
import '../../domain/usecases/get_top_rated_media.dart';
import '../../domain/usecases/get_trending_media.dart';
import '../../domain/usecases/get_tv_detail.dart';
import '../../domain/usecases/search_media.dart';

final tmdbRemoteDataSourceProvider = Provider<TmdbRemoteDataSource>((ref) {
  return TmdbRemoteDataSource(DioClient.create());
});

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  return MediaRepositoryImpl(ref.watch(tmdbRemoteDataSourceProvider));
});

// Use Cases
final getTrendingMediaUseCaseProvider = Provider<GetTrendingMedia>((ref) {
  return GetTrendingMedia(ref.watch(mediaRepositoryProvider));
});

final getTopRatedMediaUseCaseProvider = Provider<GetTopRatedMedia>((ref) {
  return GetTopRatedMedia(ref.watch(mediaRepositoryProvider));
});

final discoverMediaByGenreUseCaseProvider = Provider<DiscoverMediaByGenre>((ref) {
  return DiscoverMediaByGenre(ref.watch(mediaRepositoryProvider));
});

final searchMediaUseCaseProvider = Provider<SearchMedia>((ref) {
  return SearchMedia(ref.watch(mediaRepositoryProvider));
});

final getMovieDetailUseCaseProvider = Provider<GetMovieDetail>((ref) {
  return GetMovieDetail(ref.watch(mediaRepositoryProvider));
});

final getTvDetailUseCaseProvider = Provider<GetTvDetail>((ref) {
  return GetTvDetail(ref.watch(mediaRepositoryProvider));
});

final getSeasonEpisodesUseCaseProvider = Provider<GetSeasonEpisodes>((ref) {
  return GetSeasonEpisodes(ref.watch(mediaRepositoryProvider));
});
