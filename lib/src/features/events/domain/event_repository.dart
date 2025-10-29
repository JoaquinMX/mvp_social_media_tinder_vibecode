import '../../categories/domain/category.dart';
import 'event.dart';
import 'event_filters.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents({
    required Set<Category> categories,
    EventFilters filters = const EventFilters(),
  });
}
