import '../../onboarding/domain/group_models.dart';
import '../../swipe/domain/swipe_models.dart';
import '../domain/match_models.dart';

class MatchCalculator {
  const MatchCalculator();

  List<MatchResult> calculate({
    required GroupSettings settings,
    required Map<String, List<SwipeDecision>> decisions,
  }) {
    final events = <String, List<SwipeDecision>>{};
    for (final entry in decisions.entries) {
      for (final decision in entry.value) {
        events.putIfAbsent(decision.event.id, () => []).add(decision);
      }
    }

    final results = <MatchResult>[];
    for (final eventDecisions in events.values) {
      final yesVotes = eventDecisions.where((decision) => decision.type == SwipeDecisionType.yes).toList();
      final noVotes = eventDecisions.where((decision) => decision.type == SwipeDecisionType.no).toList();
      final yesMembers = settings.members.where((member) => yesVotes.any((decision) => decision.memberId == member.id)).toList();
      final noMembers = settings.members
          .where((member) => noVotes.any((decision) => decision.memberId == member.id))
          .map(
            (member) => NoVoter(
              member: member,
              reason: noVotes.firstWhere((decision) => decision.memberId == member.id).reason,
            ),
          )
          .toList();
      final event = eventDecisions.first.event;
      final yesCount = yesVotes.length;
      final matchType = yesCount == settings.members.length
          ? MatchType.full
          : yesCount >= settings.matchThreshold
              ? MatchType.partial
              : null;
      if (matchType != null) {
        results.add(
          MatchResult(
            event: event,
            type: matchType,
            yesVoters: yesMembers,
            noVoters: noMembers,
          ),
        );
      }
    }

    results.sort((a, b) => a.type.index.compareTo(b.type.index));
    return results;
  }
}
