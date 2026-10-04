import '../entities/media.dart';
import '../repositories/media_repository.dart';

class DiscoverMediaByGenre {
  final MediaRepository repository;

  DiscoverMediaByGenre(this.repository);

  Future<List<Media>> execute(int genreId) {
    return repository.discoverByGenre(genreId);
  }
}
