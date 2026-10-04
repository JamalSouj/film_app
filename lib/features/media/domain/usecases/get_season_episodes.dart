import '../entities/episode.dart';
import '../repositories/media_repository.dart';

class GetSeasonEpisodes {
  final MediaRepository repository;

  GetSeasonEpisodes(this.repository);

  Future<List<Episode>> execute(int tvId, int seasonNumber) {
    return repository.getSeasonEpisodes(tvId, seasonNumber);
  }
}
