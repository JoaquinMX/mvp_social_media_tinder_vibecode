import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../categories/domain/category.dart';
import '../domain/event.dart';
import '../domain/event_repository.dart';
import '../presentation/event_mapper.dart';

class MockEventRepository implements EventRepository {
  const MockEventRepository();

  @override
  Future<List<Event>> fetchEvents({required Set<Category> categories}) async {
    final raw = await rootBundle.loadString('assets/data/events.json');
    final parsed = jsonDecode(raw) as List<dynamic>;
    final events = parsed
        .map((dynamic item) => mapEventFromJson(item as Map<String, dynamic>))
        .where((event) => categories.contains(event.category))
        .toList();
    events.shuffle();
    return events;
  }
}
