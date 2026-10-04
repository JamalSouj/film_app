import '../entities/episode.dart';
import '../entities/media.dart';
import '../entities/movie_detail.dart';
import '../entities/tv_detail.dart';

abstract class MediaRepository {
  Future<List<Media>> getTrending();
  Future<List<Media>> getTopRated();
  Future<List<Media>> discoverByGenre(int genreId);
  Future<List<Media>> search(String query);
  Future<MovieDetail> getMovieDetail(int id);
  Future<TvDetail> getTvDetail(int id);
  Future<List<Episode>> getSeasonEpisodes(int tvId, int seasonNumber);
}
