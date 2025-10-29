import '../../categories/domain/category.dart';
import '../domain/event.dart';

Event mapEventFromJson(Map<String, dynamic> json) {
  final category = Category.values.firstWhere((value) => value.name == json['category']);
  final locationJson = json['location'] as Map<String, dynamic>?;
  return Event(
    id: json['id'] as String,
    category: category,
    title: json['title'] as String,
    description: json['description'] as String,
    imageUrl: json['imageUrl'] as String?,
    location: locationJson == null
        ? null
        : EventLocation(
            latitude: (locationJson['latitude'] as num).toDouble(),
            longitude: (locationJson['longitude'] as num).toDouble(),
            address: locationJson['address'] as String?,
          ),
    priceLevel: (json['priceLevel'] as num?)?.toInt(),
    metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
  );
}
