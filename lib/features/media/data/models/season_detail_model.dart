import 'episode_model.dart';
import '../../domain/entities/episode.dart';

class SeasonDetailModel {
  const SeasonDetailModel({this.episodes = const []});

  final List<Episode> episodes;

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) => SeasonDetailModel(
        episodes: (json['episodes'] as List<dynamic>?)
                ?.map((e) => EpisodeModel.fromJson(e as Map<String, dynamic>).toEntity())
                .toList() ??
            const [],
      );
}
