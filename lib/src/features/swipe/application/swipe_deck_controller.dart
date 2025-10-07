import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../events/data/event_repository_provider.dart';
import '../../events/domain/event.dart';
import '../../onboarding/domain/group_models.dart';
import '../domain/swipe_models.dart';
import 'group_preference_simulator.dart';

class SwipeDeckController extends StateNotifier<SwipeDeckState> {
  SwipeDeckController(this.ref)
      : _simulator = const GroupPreferenceSimulator(),
        super(SwipeDeckState.loading()) {
    _initialise();
  }

  final Ref ref;
  final GroupPreferenceSimulator _simulator;
  Completer<void>? _loadingCompleter;

  Future<void> _initialise() async {
    if (_loadingCompleter != null) {
      return _loadingCompleter!.future;
    }
    final completer = Completer<void>();
    _loadingCompleter = completer;
    final settings = ref.read(appFlowControllerProvider).settings;
    if (settings == null) {
      state = SwipeDeckState.loading();
      completer.complete();
      _loadingCompleter = null;
      return;
    }
    state = SwipeDeckState.loading();
    final repository = ref.read(eventRepositoryProvider);
    final events = await repository.fetchEvents(categories: settings.selectedCategories);
    final baseDecisions = {
      for (final member in settings.members) member.id: <SwipeDecision>[],
    };
    state = SwipeDeckState(events: events, index: 0, decisions: baseDecisions, isLoading: false);
    completer.complete();
    _loadingCompleter = null;
  }

  Future<void> refreshDeck() async {
    await _initialise();
  }

  void recordLocalDecision({required SwipeDecisionType type, DecisionReason? reason}) {
    final currentEvent = state.currentEvent;
    if (currentEvent == null) {
      ref.read(appFlowControllerProvider.notifier).showMatches();
      return;
    }
    final settings = ref.read(appFlowControllerProvider).settings;
    if (settings == null) {
      return;
    }
    final localMember = settings.members.firstWhere((member) => member.isLocal);
    final updatedDecisions = Map<String, List<SwipeDecision>>.from(state.decisions);
    final localDecisions = List<SwipeDecision>.from(updatedDecisions[localMember.id] ?? []);
    localDecisions.removeWhere((decision) => decision.event.id == currentEvent.id);
    localDecisions.add(
      SwipeDecision(
        event: currentEvent,
        memberId: localMember.id,
        type: type,
        reason: reason,
      ),
    );
    updatedDecisions[localMember.id] = localDecisions;

    final remoteMembers = settings.members.where((member) => !member.isLocal).toList();
    for (final decision in _simulator.simulate(currentEvent, remoteMembers)) {
      final remoteDecisions = List<SwipeDecision>.from(updatedDecisions[decision.memberId] ?? []);
      remoteDecisions.removeWhere((item) => item.event.id == currentEvent.id);
      remoteDecisions.add(decision);
      updatedDecisions[decision.memberId] = remoteDecisions;
    }

    state = state.copyWith(decisions: updatedDecisions);
    _advanceDeck();
  }

  void _advanceDeck() {
    final nextIndex = state.index + 1;
    if (nextIndex >= state.events.length) {
      ref.read(appFlowControllerProvider.notifier).showMatches();
    } else {
      state = state.copyWith(index: nextIndex);
    }
  }

  void reconsiderDecision(String memberId, Event event) {
    final updatedDecisions = Map<String, List<SwipeDecision>>.from(state.decisions);
    final memberDecisions = List<SwipeDecision>.from(updatedDecisions[memberId] ?? []);
    final index = memberDecisions.indexWhere((decision) => decision.event.id == event.id);
    if (index == -1) {
      return;
    }
    final current = memberDecisions[index];
    memberDecisions[index] = current.copyWith(type: SwipeDecisionType.yes, reason: null);
    updatedDecisions[memberId] = memberDecisions;
    state = state.copyWith(decisions: updatedDecisions);
  }
}

final swipeDeckControllerProvider = StateNotifierProvider<SwipeDeckController, SwipeDeckState>((ref) {
  return SwipeDeckController(ref);
});
