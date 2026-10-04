import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/streaming_server.dart';

final selectedServerProvider = StateProvider.autoDispose<StreamingServer>((ref) => StreamingServer.vidking);
