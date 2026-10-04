import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetTopRatedMedia {
  final MediaRepository repository;

  GetTopRatedMedia(this.repository);

  Future<List<Media>> execute() {
    return repository.getTopRated();
  }
}
