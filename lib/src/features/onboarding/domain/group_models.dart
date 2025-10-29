import 'package:equatable/equatable.dart';

import '../../categories/domain/category.dart';

enum DecisionThresholdType { unanimous, custom }

enum DecisionReason {
  expensive,
  tooFar,
  notInterested,
  other,
}

extension DecisionReasonLabel on DecisionReason {
  String get label {
    switch (this) {
      case DecisionReason.expensive:
        return 'Expensive';
      case DecisionReason.tooFar:
        return 'Too far';
      case DecisionReason.notInterested:
        return 'Not interested';
      case DecisionReason.other:
        return 'Other';
    }
  }
}

class GroupMember extends Equatable {
  const GroupMember({
    required this.id,
    required this.displayName,
    this.isLocal = false,
  });

  final String id;
  final String displayName;
  final bool isLocal;

  @override
  List<Object?> get props => [id, displayName, isLocal];
}

class GroupSettings extends Equatable {
  const GroupSettings({
    required this.groupName,
    required this.members,
    required this.matchThreshold,
    required this.selectedCategories,
  });

  final String groupName;
  final List<GroupMember> members;
  final int matchThreshold;
  final Set<Category> selectedCategories;

  GroupSettings copyWith({
    String? groupName,
    List<GroupMember>? members,
    int? matchThreshold,
    Set<Category>? selectedCategories,
  }) {
    return GroupSettings(
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      matchThreshold: matchThreshold ?? this.matchThreshold,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [groupName, members, matchThreshold, selectedCategories];
}
