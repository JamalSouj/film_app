import '../../domain/entities/credits.dart';
import 'cast_member_model.dart';

class CreditsModel extends Credits {
  const CreditsModel({super.cast = const []});

  factory CreditsModel.fromJson(Map<String, dynamic> json) => CreditsModel(
        cast: (json['cast'] as List<dynamic>?)
                ?.map((e) => CastMemberModel.fromJson(e as Map<String, dynamic>).toEntity())
                .toList() ??
            const [],
      );

  Credits toEntity() => Credits(cast: cast);
}
