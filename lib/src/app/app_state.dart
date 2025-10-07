import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/categories/domain/category.dart';
import '../features/onboarding/domain/group_models.dart';

enum AppStage { onboardingGroup, categorySelection, swipe, matches }

class AppState extends Equatable {
  const AppState({
    this.stage = AppStage.onboardingGroup,
    this.settings,
    this.pendingCategories = const {},
  });

  final AppStage stage;
  final GroupSettings? settings;
  final Set<Category> pendingCategories;

  AppState copyWith({
    AppStage? stage,
    GroupSettings? settings,
    Set<Category>? pendingCategories,
  }) {
    return AppState(
      stage: stage ?? this.stage,
      settings: settings ?? this.settings,
      pendingCategories: pendingCategories ?? this.pendingCategories,
    );
  }

  @override
  List<Object?> get props => [stage, settings, pendingCategories];
}

class AppFlowController extends StateNotifier<AppState> {
  AppFlowController() : super(const AppState());

  void saveGroupSettings(GroupSettings settings) {
    state = state.copyWith(settings: settings, stage: AppStage.categorySelection);
  }

  void updateCategorySelection(Set<Category> categories) {
    final currentSettings = state.settings;
    if (currentSettings == null) {
      return;
    }
    final newSettings = currentSettings.copyWith(selectedCategories: categories);
    state = state.copyWith(settings: newSettings, stage: AppStage.swipe);
  }

  void showMatches() {
    state = state.copyWith(stage: AppStage.matches);
  }

  void resetToCategories() {
    state = state.copyWith(stage: AppStage.categorySelection);
  }
}

final appFlowControllerProvider = StateNotifierProvider<AppFlowController, AppState>((ref) {
  return AppFlowController();
});
