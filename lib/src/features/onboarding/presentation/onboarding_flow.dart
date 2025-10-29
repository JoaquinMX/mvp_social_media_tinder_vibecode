import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../categories/presentation/category_selection_page.dart';
import '../../matches/presentation/match_summary_page.dart';
import '../../swipe/presentation/swipe_experience_page.dart';
import 'group_setup_page.dart';

class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appFlowControllerProvider);
    switch (appState.stage) {
      case AppStage.onboardingGroup:
        return const GroupSetupPage();
      case AppStage.categorySelection:
        return const CategorySelectionPage();
      case AppStage.swipe:
        return const SwipeExperiencePage();
      case AppStage.matches:
        return const MatchSummaryPage();
    }
  }
}
