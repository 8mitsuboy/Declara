import 'package:declara/domain/todo.dart';
import 'package:declara/pages/sub_task_page/sub_task_generation_page.dart';
import 'package:declara/providers.dart';
import 'package:declara/widgets/declara_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class CreateTodoPage extends HookConsumerWidget {
  const CreateTodoPage({super.key});

  Future<void> _saveTodoAndNavigate(
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller,
  ) async {
    final userInput = controller.text;
    if (userInput.isEmpty) return;
    final todo = Todo(title: userInput);
    await ref.read(todoRepositoryProvider).save(todo);
    ref.invalidate(todoListProvider);
    controller.clear();
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SubTaskGenerationPage(
            todoId: todo.id,
            todoTitle: userInput,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DeclaraTextField(controller: controller),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _saveTodoAndNavigate(context, ref, controller),
            child: const Text("やらなきゃ"),
          ),
        ],
      ),
    );
  }
}
