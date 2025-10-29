import 'package:equatable/equatable.dart';

import '../../events/domain/event.dart';
import '../../onboarding/domain/group_models.dart';

enum SwipeDirection { left, right }

enum SwipeDecisionType { yes, no }

class SwipeDecision extends Equatable {
  const SwipeDecision({
    required this.event,
    required this.memberId,
    required this.type,
    this.reason,
  });

  final Event event;
  final String memberId;
  final SwipeDecisionType type;
  final DecisionReason? reason;

  SwipeDecision copyWith({
    SwipeDecisionType? type,
    DecisionReason? reason,
  }) {
    return SwipeDecision(
      event: event,
      memberId: memberId,
      type: type ?? this.type,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [event, memberId, type, reason];
}

class SwipeDeckState extends Equatable {
  const SwipeDeckState({
    required this.events,
    required this.index,
    required this.decisions,
    this.isLoading = false,
  });

  factory SwipeDeckState.loading() => const SwipeDeckState(events: [], index: 0, decisions: {}, isLoading: true);

  final List<Event> events;
  final int index;
  final Map<String, List<SwipeDecision>> decisions;
  final bool isLoading;

  Event? get currentEvent => index < events.length ? events[index] : null;

  SwipeDeckState copyWith({
    List<Event>? events,
    int? index,
    Map<String, List<SwipeDecision>>? decisions,
    bool? isLoading,
  }) {
    return SwipeDeckState(
      events: events ?? this.events,
      index: index ?? this.index,
      decisions: decisions ?? this.decisions,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [events, index, decisions, isLoading];
}
