import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/event_filters_controller.dart';
import '../domain/event_filters.dart';

class EventFiltersSheet extends ConsumerStatefulWidget {
  const EventFiltersSheet({super.key});

  @override
  ConsumerState<EventFiltersSheet> createState() => _EventFiltersSheetState();
}

class _EventFiltersSheetState extends ConsumerState<EventFiltersSheet> {
  late EventFilters _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(eventFiltersProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.of(context).viewInsets;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: padding.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Refine recommendations',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Reset filters',
                      onPressed: () {
                        setState(() {
                          _draft = const EventFilters();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Price level',
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Any'),
                        selected: _draft.maxPriceLevel == null,
                        onSelected: (_) {
                          setState(() {
                            _draft = _draft.copyWith(removeMaxPriceLevel: true);
                          });
                        },
                      ),
                      ...EventFilterOptions.priceLevels.map(
                        (level) => ChoiceChip(
                          label: Text('\$' * level),
                          selected: _draft.maxPriceLevel == level,
                          onSelected: (_) {
                            setState(() {
                              _draft = _draft.copyWith(maxPriceLevel: level);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Max runtime (movies)',
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Any'),
                        selected: _draft.maxRuntimeMinutes == null,
                        onSelected: (_) {
                          setState(() {
                            _draft = _draft.copyWith(removeMaxRuntimeMinutes: true);
                          });
                        },
                      ),
                      ...EventFilterOptions.runtimeMinutes.map(
                        (minutes) => ChoiceChip(
                          label: Text('≤ ${minutes}m'),
                          selected: _draft.maxRuntimeMinutes == minutes,
                          onSelected: (_) {
                            setState(() {
                              _draft = _draft.copyWith(maxRuntimeMinutes: minutes);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: 'Supported platforms (videogames)',
                  child: Wrap(
                    spacing: 8,
                    children: [
                      ...EventFilterOptions.gamePlatforms.map(
                        (platform) {
                          final selected = _draft.preferredPlatforms.contains(platform);
                          return FilterChip(
                            label: Text(platform),
                            selected: selected,
                            onSelected: (_) {
                              setState(() {
                                final updated = Set<String>.from(_draft.preferredPlatforms);
                                if (selected) {
                                  updated.remove(platform);
                                } else {
                                  updated.add(platform);
                                }
                                _draft = _draft.copyWith(preferredPlatforms: updated);
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _draft = const EventFilters();
                          });
                          ref.read(eventFiltersProvider.notifier).reset();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Clear filters'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          ref.read(eventFiltersProvider.notifier).update(_draft);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Apply'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
