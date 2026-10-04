import 'package:dio/dio.dart';

import '../models/media_response_model.dart';
import '../models/movie_detail_model.dart';
import '../models/season_detail_model.dart';
import '../models/tv_detail_model.dart';

class TmdbRemoteDataSource {
  TmdbRemoteDataSource(this._dio);

  final Dio _dio;

  Future<MediaResponseModel> getTrending({int page = 1}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/trending/all/week',
      queryParameters: {'page': page},
    );
    return MediaResponseModel.fromJson(r.data!);
  }

  Future<MediaResponseModel> getTopRated({int page = 1}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/movie/top_rated',
      queryParameters: {'page': page},
    );
    return _injectMediaType(r.data!, 'movie');
  }

  Future<MediaResponseModel> discoverByGenre(int genreId, {int page = 1}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'sort_by': 'popularity.desc',
        'page': page,
      },
    );
    return _injectMediaType(r.data!, 'movie');
  }

  Future<MediaResponseModel> search(String query, {int page = 1}) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/search/multi',
      queryParameters: {'query': query, 'page': page},
    );
    return MediaResponseModel.fromJson(r.data!);
  }

  Future<MovieDetailModel> getMovieDetail(int id) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/movie/$id',
      queryParameters: {'append_to_response': 'credits'},
    );
    return MovieDetailModel.fromJson(r.data!);
  }

  Future<TvDetailModel> getTvDetail(int id) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/tv/$id',
      queryParameters: {'append_to_response': 'credits'},
    );
    return TvDetailModel.fromJson(r.data!);
  }

  Future<SeasonDetailModel> getSeasonDetail(int tvId, int seasonNumber) async {
    final r = await _dio.get<Map<String, dynamic>>(
      '/tv/$tvId/season/$seasonNumber',
    );
    return SeasonDetailModel.fromJson(r.data!);
  }

  MediaResponseModel _injectMediaType(Map<String, dynamic> json, String type) {
    final results = (json['results'] as List<dynamic>).map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      map['media_type'] = type;
      return map;
    }).toList();
    json['results'] = results;
    return MediaResponseModel.fromJson(json);
  }
}
