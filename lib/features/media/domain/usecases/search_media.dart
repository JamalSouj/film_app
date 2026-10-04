import '../entities/media.dart';
import '../repositories/media_repository.dart';

class SearchMedia {
  final MediaRepository repository;

  SearchMedia(this.repository);

  Future<List<Media>> execute(String query) {
    return repository.search(query);
  }
}
