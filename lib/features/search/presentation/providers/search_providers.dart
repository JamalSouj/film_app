import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../media/domain/entities/media.dart';
import '../../../media/presentation/providers/media_providers.dart';

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<Media>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  bool cancelled = false;
  ref.onDispose(() => cancelled = true);
  await Future.delayed(AppConstants.searchDebounce);
  if (cancelled) return [];

  return ref.watch(searchMediaUseCaseProvider).execute(query);
});
