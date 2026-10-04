import '../../domain/entities/cast_member.dart';

class CastMemberModel extends CastMember {
  const CastMemberModel({
    required super.id,
    required super.name,
    super.character,
    super.profilePath,
  });

  factory CastMemberModel.fromJson(Map<String, dynamic> json) => CastMemberModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? 'Unknown',
        character: json['character'] as String?,
        profilePath: json['profile_path'] as String?,
      );

  CastMember toEntity() => CastMember(
        id: id,
        name: name,
        character: character,
        profilePath: profilePath,
      );
}
