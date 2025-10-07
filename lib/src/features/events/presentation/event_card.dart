import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';

import '../domain/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.imageUrl != null)
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                event.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => Container(
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            )
          else
            Container(
              height: 220,
              width: double.infinity,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Icon(Icons.image),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(event.description),
                if (event.location != null) ...[
                  const SizedBox(height: 16),
                  _MapPreview(location: event.location!),
                ],
                if (event.priceLevel != null) ...[
                  const SizedBox(height: 8),
                  Text('Price level: ${'\$' * (event.priceLevel ?? 0)}'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.location});

  final EventLocation location;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: MaplibreMap(
              compassEnabled: false,
              myLocationEnabled: false,
              styleString: 'https://demotiles.maplibre.org/style.json',
              initialCameraPosition: CameraPosition(
                target: LatLng(location.latitude, location.longitude),
                zoom: 13,
              ),
              onMapCreated: (controller) {
                controller.addSymbol(
                  SymbolOptions(
                    geometry: LatLng(location.latitude, location.longitude),
                    iconImage: 'marker-15',
                  ),
                );
              },
            ),
          ),
        ),
        if (location.address != null) ...[
          const SizedBox(height: 8),
          Text(
            location.address!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
