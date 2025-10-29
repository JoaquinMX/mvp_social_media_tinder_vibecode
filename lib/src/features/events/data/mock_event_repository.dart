import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../categories/domain/category.dart';
import '../domain/event.dart';
import '../domain/event_filters.dart';
import '../domain/event_repository.dart';
import '../presentation/event_mapper.dart';

class MockEventRepository implements EventRepository {
  const MockEventRepository();

  @override
  Future<List<Event>> fetchEvents({
    required Set<Category> categories,
    EventFilters filters = const EventFilters(),
  }) async {
    final raw = await rootBundle.loadString('assets/data/events.json');
    final parsed = jsonDecode(raw) as List<dynamic>;
    final events = parsed
        .map((dynamic item) => mapEventFromJson(item as Map<String, dynamic>))
        .where((event) => categories.contains(event.category))
        .where((event) => _matchesFilters(event, filters))
        .toList();
    events.shuffle();
    return events;
  }

  bool _matchesFilters(Event event, EventFilters filters) {
    if (filters.maxPriceLevel != null && event.priceLevel != null) {
      if (event.priceLevel! > filters.maxPriceLevel!) {
        return false;
      }
    }

    switch (event.category) {
      case Category.movies:
        if (filters.maxRuntimeMinutes != null) {
          final runtime = event.metadata['runtimeMinutes'];
          if (runtime is num && runtime > filters.maxRuntimeMinutes!) {
            return false;
          }
        }
        break;
      case Category.videogames:
        if (filters.preferredPlatforms.isNotEmpty) {
          final platforms = event.metadata['platforms'];
          final platformList =
              platforms is List ? platforms.map((platform) => platform.toString()).toList() : <String>[];
          final matches = platformList.any(filters.preferredPlatforms.contains);
          if (!matches) {
            return false;
          }
        }
        break;
      case Category.places:
        break;
    }

    return true;
  }
}
