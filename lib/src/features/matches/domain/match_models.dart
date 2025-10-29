import 'package:equatable/equatable.dart';

import '../../events/domain/event.dart';
import '../../onboarding/domain/group_models.dart';
import '../../swipe/domain/swipe_models.dart';

enum MatchType { full, partial }

class MatchResult extends Equatable {
  const MatchResult({
    required this.event,
    required this.type,
    required this.yesVoters,
    required this.noVoters,
  });

  final Event event;
  final MatchType type;
  final List<GroupMember> yesVoters;
  final List<NoVoter> noVoters;

  @override
  List<Object?> get props => [event, type, yesVoters, noVoters];
}

class NoVoter extends Equatable {
  const NoVoter({
    required this.member,
    required this.reason,
  });

  final GroupMember member;
  final DecisionReason? reason;

  @override
  List<Object?> get props => [member, reason];
}
