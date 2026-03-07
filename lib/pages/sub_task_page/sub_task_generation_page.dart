import 'package:declara/domain/sub_task.dart';
import 'package:declara/pages/sub_task_page/widgets/error_view.dart';
import 'package:declara/pages/sub_task_page/widgets/generated_task_list.dart';
import 'package:declara/pages/sub_task_page/widgets/loading_view.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubTaskGenerationPage extends ConsumerWidget {
  const SubTaskGenerationPage({
    super.key,
    required this.todoId,
    required this.todoTitle,
  });

  final String todoId;
  final String todoTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(generatedSubTasksProvider(todoTitle));

    return Scaffold(
      appBar: AppBar(title: const Text('サブタスク生成')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: asyncTasks.when(
          loading: () => const LoadingView(message: 'AIがサブタスクを生成中...'),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(generatedSubTasksProvider(todoTitle)),
          ),
          data: (tasks) => GeneratedTaskList(
            todoId: todoId,
            todoTitle: todoTitle,
            tasks: tasks,
          ),
        ),
      ),
    );
  }
}
