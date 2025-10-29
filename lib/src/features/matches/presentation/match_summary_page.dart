import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../onboarding/domain/group_models.dart';
import '../../swipe/application/swipe_deck_controller.dart';
import '../application/match_provider.dart';
import '../domain/match_models.dart';

class MatchSummaryPage extends ConsumerWidget {
  const MatchSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullMatches = ref.watch(fullMatchesProvider);
    final partialMatches = ref.watch(partialMatchesProvider);
    final settings = ref.watch(appFlowControllerProvider).settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your matches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => ref.read(appFlowControllerProvider.notifier).resetToCategories(),
            tooltip: 'Adjust categories',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (fullMatches.isEmpty)
              const _SectionHeader(title: 'No full matches yet')
            else ...[
              const _SectionHeader(title: 'Ready to go'),
              ...fullMatches.map((match) => _MatchCard(match: match)),
            ],
            const SizedBox(height: 24),
            if (partialMatches.isEmpty)
              const _SectionHeader(title: 'No partial matches yet')
            else ...[
              const _SectionHeader(title: 'Need confirmations'),
              ...partialMatches.map(
                (match) => _PartialMatchCard(match: match, settings: settings),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});

  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.event.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(match.event.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: match.yesVoters
                  .map(
                    (member) => Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(member.displayName),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartialMatchCard extends ConsumerWidget {
  const _PartialMatchCard({required this.match, required this.settings});

  final MatchResult match;
  final GroupSettings? settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GroupMember? localMember;
    final resolvedSettings = settings;
    if (resolvedSettings != null && resolvedSettings.members.isNotEmpty) {
      try {
        localMember = resolvedSettings.members.firstWhere((member) => member.isLocal);
      } catch (_) {
        localMember = resolvedSettings.members.first;
      }
    }
    final controller = ref.read(swipeDeckControllerProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.event.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(match.event.description),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: match.yesVoters
                  .map(
                    (member) => Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(member.displayName),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: match.noVoters
                  .map(
                    (noVoter) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.close),
                      title: Text(noVoter.member.displayName),
                      subtitle: Text(noVoter.reason?.label ?? 'No reason provided'),
                      trailing: noVoter.member.id == localMember?.id
                          ? TextButton(
                              onPressed: () => controller.reconsiderDecision(noVoter.member.id, match.event),
                              child: const Text('Change to yes'),
                            )
                          : null,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
