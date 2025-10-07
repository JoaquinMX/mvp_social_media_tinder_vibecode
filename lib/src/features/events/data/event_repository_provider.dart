import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mock_event_repository.dart';
import '../domain/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return const MockEventRepository();
});
