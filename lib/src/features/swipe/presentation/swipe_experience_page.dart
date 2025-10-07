import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../events/presentation/event_card.dart';
import '../../onboarding/domain/group_models.dart';
import '../application/swipe_deck_controller.dart';
import '../domain/swipe_models.dart';

class SwipeExperiencePage extends ConsumerWidget {
  const SwipeExperiencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deckState = ref.watch(swipeDeckControllerProvider);
    final controller = ref.read(swipeDeckControllerProvider.notifier);

    if (deckState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentEvent = deckState.currentEvent;
    if (currentEvent == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('You have reached the end of the deck!'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.read(appFlowControllerProvider.notifier).showMatches(),
                child: const Text('View matches'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshDeck,
            tooltip: 'Refresh events',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: EventCard(event: currentEvent),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectReason(context, controller),
                      icon: const Icon(Icons.close),
                      label: const Text('Not now'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => controller.recordLocalDecision(type: SwipeDecisionType.yes),
                      icon: const Icon(Icons.favorite),
                      label: const Text('Yes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectReason(BuildContext context, SwipeDeckController controller) async {
    final reason = await showModalBottomSheet<DecisionReason>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Why is this a no?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...DecisionReason.values.map(
                (reason) => ListTile(
                  title: Text(reason.label),
                  onTap: () => Navigator.of(context).pop(reason),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (reason != null) {
      controller.recordLocalDecision(type: SwipeDecisionType.no, reason: reason);
    }
  }
}
