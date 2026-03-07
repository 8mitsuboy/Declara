import 'package:declara/domain/sub_task.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SubTaskGenerationPage extends HookConsumerWidget {
  const SubTaskGenerationPage({
    super.key,
    required this.todoId,
    required this.todoTitle,
  });

  final String todoId;
  final String todoTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generatedTasks = useState<List<String>?>(null);
    final isLoading = useState(true);
    final error = useState<String?>(null);

    Future<void> generate() async {
      isLoading.value = true;
      error.value = null;
      try {
        final aiService = ref.read(aiServiceProvider);
        final tasks = await aiService.generateSubTasks(todoTitle);
        generatedTasks.value = tasks;
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

    useEffect(() {
      generate();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('サブタスク生成')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(
          context,
          ref,
          isLoading: isLoading.value,
          error: error.value,
          generatedTasks: generatedTasks.value,
          onRetry: generate,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required bool isLoading,
    required String? error,
    required List<String>? generatedTasks,
    required VoidCallback onRetry,
  }) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('AIがサブタスクを生成中...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('エラーが発生しました', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('リトライ')),
          ],
        ),
      );
    }

    final tasks = generatedTasks ?? [];
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
