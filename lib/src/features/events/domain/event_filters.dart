import 'package:equatable/equatable.dart';

class EventFilters extends Equatable {
  const EventFilters({
    this.maxPriceLevel,
    this.maxRuntimeMinutes,
    this.preferredPlatforms = const <String>{},
  });

  final int? maxPriceLevel;
  final int? maxRuntimeMinutes;
  final Set<String> preferredPlatforms;

  bool get hasActiveFilters =>
      maxPriceLevel != null || maxRuntimeMinutes != null || preferredPlatforms.isNotEmpty;

  EventFilters copyWith({
    int? maxPriceLevel,
    bool removeMaxPriceLevel = false,
    int? maxRuntimeMinutes,
    bool removeMaxRuntimeMinutes = false,
    Set<String>? preferredPlatforms,
  }) {
    return EventFilters(
      maxPriceLevel: removeMaxPriceLevel ? null : (maxPriceLevel ?? this.maxPriceLevel),
      maxRuntimeMinutes:
          removeMaxRuntimeMinutes ? null : (maxRuntimeMinutes ?? this.maxRuntimeMinutes),
      preferredPlatforms: preferredPlatforms ?? this.preferredPlatforms,
    );
  }

  EventFilters reset() => const EventFilters();

  @override
  List<Object?> get props => [maxPriceLevel, maxRuntimeMinutes, preferredPlatforms];
}

class EventFilterOptions {
  const EventFilterOptions();

  static const List<int> priceLevels = [1, 2, 3, 4];
  static const List<int> runtimeMinutes = [60, 90, 120, 150];
  static const List<String> gamePlatforms = ['PC', 'Switch', 'PS5', 'Xbox', 'Mobile'];
}
