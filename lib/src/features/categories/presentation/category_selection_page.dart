import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_state.dart';
import '../domain/category.dart';

class CategorySelectionPage extends ConsumerStatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  ConsumerState<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends ConsumerState<CategorySelectionPage> {
  late Set<Category> _selected;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appFlowControllerProvider).settings;
    _selected = settings?.selectedCategories ?? Category.values.toSet();
  }

  void _toggle(Category category, bool value) {
    setState(() {
      if (value) {
        _selected = {..._selected, category};
      } else {
        final updated = {..._selected}..remove(category);
        if (updated.isEmpty) {
          return;
        }
        _selected = updated;
      }
    });
  }

  void _continue() {
    ref.read(appFlowControllerProvider.notifier).updateCategorySelection(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Which types of plans do you want to explore?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ...Category.values.map(
              (category) => SwitchListTile(
                value: _selected.contains(category),
                onChanged: (value) => _toggle(category, value),
                title: Text(category.label),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selected.isEmpty ? null : _continue,
                child: const Text('Start swiping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
