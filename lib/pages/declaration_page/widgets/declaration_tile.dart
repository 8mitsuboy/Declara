import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeclarationTile extends ConsumerWidget {
  const DeclarationTile({
    super.key,
    required this.declarationId,
    required this.declarationTitle,
  });

  final String declarationId;
  final String declarationTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider(declarationId));

    return ExpansionTile(
      title: Text(declarationTitle),
      children: [
        if (tasksAsync.value case final tasks? when tasks.isNotEmpty)
          Column(
            children: tasks
                .map(
                  (task) => CheckboxListTile(
                    value: task.done,
                    title: Text(task.title.value),
                    onChanged: (value) async {
                      if (value == null) return;
                      final repo = ref.read(taskRepositoryProvider);
                      await repo.updateDone(task.id, value);
                      ref.invalidate(taskListProvider(declarationId));
                    },
                  ),
                )
                .toList(),
          )
        else if (tasksAsync.hasError)
          Text('エラー: ${tasksAsync.error}')
        else if (tasksAsync.hasValue)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('タスクなし'),
          )
        else
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
