import '../../events/domain/event.dart';
import '../../onboarding/domain/group_models.dart';
import '../domain/swipe_models.dart';

class GroupPreferenceSimulator {
  const GroupPreferenceSimulator();

  List<SwipeDecision> simulate(Event event, List<GroupMember> members) {
    return members
        .map(
          (member) => _decisionForMember(event, member),
        )
        .toList();
  }

  SwipeDecision _decisionForMember(Event event, GroupMember member) {
    final hash = event.id.hashCode + member.id.hashCode;
    final isYes = hash % 3 != 0; // deterministic yet varied.
    if (isYes) {
      return SwipeDecision(
        event: event,
        memberId: member.id,
        type: SwipeDecisionType.yes,
      );
    }
    final reasons = DecisionReason.values;
    final reasonIndex = hash.abs() % reasons.length;
    return SwipeDecision(
      event: event,
      memberId: member.id,
      type: SwipeDecisionType.no,
      reason: reasons[reasonIndex],
    );
  }
}
