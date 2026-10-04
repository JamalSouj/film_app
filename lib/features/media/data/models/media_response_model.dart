import '../../domain/entities/media.dart';
import 'media_model.dart';

class MediaResponseModel {
  const MediaResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<Media> results;
  final int totalPages;
  final int totalResults;

  factory MediaResponseModel.fromJson(Map<String, dynamic> json) => MediaResponseModel(
        page: json['page'] as int,
        results: (json['results'] as List<dynamic>)
            .map((e) => MediaModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList(),
        totalPages: json['total_pages'] as int,
        totalResults: json['total_results'] as int,
      );
}
