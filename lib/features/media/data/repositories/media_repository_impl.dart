import 'package:dio/dio.dart';

import '../../domain/entities/episode.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/tmdb_remote_data_source.dart';

class MediaRepositoryImpl implements MediaRepository {
  MediaRepositoryImpl(this._api);

  final TmdbRemoteDataSource _api;

  @override
  Future<List<Media>> getTrending() => _safeCall(
        () async => (await _api.getTrending()).results,
        fallback: 'Failed to load trending titles.',
      );

  @override
  Future<List<Media>> getTopRated() => _safeCall(
        () async => (await _api.getTopRated()).results,
        fallback: 'Failed to load top‑rated movies.',
      );

  @override
  Future<List<Media>> discoverByGenre(int genreId) => _safeCall(
        () async => (await _api.discoverByGenre(genreId)).results,
        fallback: 'Failed to discover movies.',
      );

  @override
  Future<List<Media>> search(String query) => _safeCall(
        () async {
          final response = await _api.search(query);
          return response.results
              .where((m) => m.mediaType != 'person')
              .toList();
        },
        fallback: 'Search failed.',
      );

  @override
  Future<MovieDetail> getMovieDetail(int id) => _safeCall(
        () async => (await _api.getMovieDetail(id)).toEntity(),
        fallback: 'Failed to load movie details.',
      );

  @override
  Future<TvDetail> getTvDetail(int id) => _safeCall(
        () async => (await _api.getTvDetail(id)).toEntity(),
        fallback: 'Failed to load show details.',
      );

  @override
  Future<List<Episode>> getSeasonEpisodes(int tvId, int seasonNumber) =>
      _safeCall(
        () async => (await _api.getSeasonDetail(tvId, seasonNumber)).episodes,
        fallback: 'Failed to load episodes.',
      );

  Future<T> _safeCall<T>(
    Future<T> Function() action, {
    required String fallback,
  }) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw Exception(e.error?.toString() ?? fallback);
    } catch (e) {
      throw Exception(fallback);
    }
  }
}
