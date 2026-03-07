import 'package:declara/pages/task_generation_page/widgets/error_view.dart';
import 'package:declara/pages/task_generation_page/widgets/generated_task_list.dart';
import 'package:declara/pages/task_generation_page/widgets/loading_view.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TaskGenerationPage extends ConsumerWidget {
  const TaskGenerationPage({
    super.key,
    required this.declarationId,
    required this.declarationTitle,
  });

  final String declarationId;
  final String declarationTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(generatedTasksProvider(declarationTitle));

    return Scaffold(
      appBar: AppBar(title: const Text('タスク生成')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: asyncTasks.when(
          loading: () => const LoadingView(message: 'AIがタスクを生成中...'),
          error: (error, _) => ErrorView(
            message: error.toString(),
            onRetry: () =>
                ref.invalidate(generatedTasksProvider(declarationTitle)),
          ),
          data: (tasks) => GeneratedTaskList(
            declarationId: declarationId,
            declarationTitle: declarationTitle,
            tasks: tasks,
          ),
        ),
      ),
    );
  }
}
