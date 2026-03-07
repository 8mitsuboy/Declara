import 'package:declara/domain/sub_task.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeneratedTaskList extends ConsumerWidget {
  const GeneratedTaskList({
    super.key,
    required this.todoId,
    required this.todoTitle,
    required this.tasks,
  });

  final String todoId;
  final String todoTitle;
  final List<String> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '「$todoTitle」のサブタスク',
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
            final subTaskRepository = ref.read(subTaskRepositoryProvider);
            final subTasks = tasks
                .asMap()
                .entries
                .map(
                  (e) => SubTask(
                    todoId: todoId,
                    title: e.value,
                    sortOrder: e.key,
                  ),
                )
                .toList();
            await subTaskRepository.saveAll(subTasks);
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
