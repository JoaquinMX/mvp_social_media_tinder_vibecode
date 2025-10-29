import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../swipe/application/swipe_deck_controller.dart';
import '../domain/match_models.dart';
import 'match_calculator.dart';

final matchResultsProvider = Provider<List<MatchResult>>((ref) {
  final settings = ref.watch(appFlowControllerProvider).settings;
  final swipeState = ref.watch(swipeDeckControllerProvider);
  if (settings == null) {
    return const [];
  }
  final calculator = const MatchCalculator();
  return calculator.calculate(settings: settings, decisions: swipeState.decisions);
});

final fullMatchesProvider = Provider<List<MatchResult>>((ref) {
  return ref.watch(matchResultsProvider).where((match) => match.type == MatchType.full).toList();
});

final partialMatchesProvider = Provider<List<MatchResult>>((ref) {
  return ref.watch(matchResultsProvider).where((match) => match.type == MatchType.partial).toList();
});
