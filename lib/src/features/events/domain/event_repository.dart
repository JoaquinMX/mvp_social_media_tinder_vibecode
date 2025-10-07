import '../../categories/domain/category.dart';
import 'event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents({required Set<Category> categories});
}
