import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../../categories/domain/category.dart';
import '../domain/group_models.dart';

class GroupSetupPage extends ConsumerStatefulWidget {
  const GroupSetupPage({super.key});

  @override
  ConsumerState<GroupSetupPage> createState() => _GroupSetupPageState();
}

class _GroupSetupPageState extends ConsumerState<GroupSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  int _memberCount = 2;
  int _threshold = 2;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final members = List.generate(_memberCount, (index) {
      final isLocal = index == 0;
      return GroupMember(
        id: 'member-${index + 1}',
        displayName: isLocal ? 'You' : 'Member ${index + 1}',
        isLocal: isLocal,
      );
    });
    final settings = GroupSettings(
      groupName: _groupNameController.text.trim(),
      members: members,
      matchThreshold: _threshold,
      selectedCategories: Category.values.toSet(),
    );
    ref.read(appFlowControllerProvider.notifier).saveGroupSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your group'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start by telling us about your crew.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _groupNameController,
                  decoration: const InputDecoration(
                    labelText: 'Group name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a group name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Text('How many people are swiping?')),
                    DropdownButton<int>(
                      value: _memberCount,
                      items: List.generate(8, (index) => index + 2)
                          .map(
                            (count) => DropdownMenuItem<int>(
                              value: count,
                              child: Text('$count'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _memberCount = value;
                          _threshold = value == 2 ? 2 : value - 1;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'How many yes votes are needed for a plan?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    DropdownButton<int>(
                      value: _threshold,
                      items: List.generate(_memberCount - 1, (index) => index + 2)
                          .map(
                            (value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value'),
                            ),
                          )
                          .toList(),
                      onChanged: _memberCount <= 2
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _threshold = value;
                              });
                            },
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _handleContinue,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
