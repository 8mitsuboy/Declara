import 'package:declara/domain/task.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeneratedTaskList extends ConsumerWidget {
  const GeneratedTaskList({
    super.key,
    required this.declarationId,
    required this.declarationTitle,
    required this.tasks,
  });

  final String declarationId;
  final String declarationTitle;
  final List<String> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '「$declarationTitle」のタスク',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(tasks[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final taskRepository = ref.read(taskRepositoryProvider);
            final taskList = tasks
                .asMap()
                .entries
                .map(
                  (e) => Task(
                    declarationId: declarationId,
                    title: e.value,
                    sortOrder: e.key,
                  ),
                )
                .toList();
            await taskRepository.saveAll(taskList);
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: const Text('保存する'),
        ),
      ],
    );
  }
}
