import '../../../../core/constants/app_constants.dart';

class CastMember {
  const CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  String get profileUrl => AppConstants.profileUrl(profilePath);
}
