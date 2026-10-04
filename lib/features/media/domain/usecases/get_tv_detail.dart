import '../entities/tv_detail.dart';
import '../repositories/media_repository.dart';

class GetTvDetail {
  final MediaRepository repository;

  GetTvDetail(this.repository);

  Future<TvDetail> execute(int id) {
    return repository.getTvDetail(id);
  }
}
