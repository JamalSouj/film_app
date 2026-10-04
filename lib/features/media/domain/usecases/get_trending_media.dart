import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetTrendingMedia {
  final MediaRepository repository;

  GetTrendingMedia(this.repository);

  Future<List<Media>> execute() {
    return repository.getTrending();
  }
}
