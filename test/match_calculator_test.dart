import 'package:flutter_test/flutter_test.dart';

import 'package:group_swipe/src/features/categories/domain/category.dart';
import 'package:group_swipe/src/features/events/domain/event.dart';
import 'package:group_swipe/src/features/matches/application/match_calculator.dart';
import 'package:group_swipe/src/features/matches/domain/match_models.dart';
import 'package:group_swipe/src/features/onboarding/domain/group_models.dart';
import 'package:group_swipe/src/features/swipe/domain/swipe_models.dart';

void main() {
  group('MatchCalculator', () {
    final calculator = const MatchCalculator();
    final members = [
      const GroupMember(id: 'member-1', displayName: 'A', isLocal: true),
      const GroupMember(id: 'member-2', displayName: 'B'),
      const GroupMember(id: 'member-3', displayName: 'C'),
    ];
    final settings = GroupSettings(
      groupName: 'Crew',
      members: members,
      matchThreshold: 2,
      selectedCategories: {Category.movies},
    );
    final event = Event(
      id: 'event-1',
      category: Category.movies,
      title: 'Movie night',
      description: 'Test movie',
    );

    test('creates full match when all vote yes', () {
      final decisions = {
        for (final member in members)
          member.id: [
            SwipeDecision(
              event: event,
              memberId: member.id,
              type: SwipeDecisionType.yes,
            ),
          ],
      };

      final results = calculator.calculate(settings: settings, decisions: decisions);
      expect(results, hasLength(1));
      expect(results.first.type, MatchType.full);
      expect(results.first.yesVoters, hasLength(3));
    });

    test('creates partial match when threshold met but not unanimous', () {
      final decisions = {
        members[0].id: [
          SwipeDecision(
            event: event,
            memberId: members[0].id,
            type: SwipeDecisionType.yes,
          ),
        ],
        members[1].id: [
          SwipeDecision(
            event: event,
            memberId: members[1].id,
            type: SwipeDecisionType.yes,
          ),
        ],
        members[2].id: [
          SwipeDecision(
            event: event,
            memberId: members[2].id,
            type: SwipeDecisionType.no,
            reason: DecisionReason.notInterested,
          ),
        ],
      };

      final results = calculator.calculate(settings: settings, decisions: decisions);
      expect(results, hasLength(1));
      expect(results.first.type, MatchType.partial);
      expect(results.first.noVoters.first.reason, DecisionReason.notInterested);
    });
  });
}
