import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/event_filters.dart';

class EventFiltersController extends StateNotifier<EventFilters> {
  EventFiltersController() : super(const EventFilters());

  void update(EventFilters filters) {
    state = filters;
  }

  void reset() {
    state = const EventFilters();
  }
}

final eventFiltersProvider = StateNotifierProvider<EventFiltersController, EventFilters>((ref) {
  return EventFiltersController();
});
