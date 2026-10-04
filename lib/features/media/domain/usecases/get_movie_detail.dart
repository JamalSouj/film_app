import '../entities/movie_detail.dart';
import '../repositories/media_repository.dart';

class GetMovieDetail {
  final MediaRepository repository;

  GetMovieDetail(this.repository);

  Future<MovieDetail> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
