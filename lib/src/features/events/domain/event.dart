import 'package:equatable/equatable.dart';

import '../../categories/domain/category.dart';

class Event extends Equatable {
  const Event({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.imageUrl,
    this.location,
    this.priceLevel,
    this.metadata = const {},
  });

  final String id;
  final Category category;
  final String title;
  final String description;
  final String? imageUrl;
  final EventLocation? location;
  final int? priceLevel;
  final Map<String, Object?> metadata;

  @override
  List<Object?> get props => [id, category, title, description, imageUrl, location, priceLevel, metadata];
}

class EventLocation extends Equatable {
  const EventLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? address;

  @override
  List<Object?> get props => [latitude, longitude, address];
}
