import 'package:declara/domain/todo.dart';
import 'package:declara/providers.dart';
import 'package:declara/widgets/declara_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class CreateTodoPage extends HookConsumerWidget {
  const CreateTodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final todoRepository = ref.watch(todoRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DeclaraTextField(controller: controller),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final userInput = controller.text;
              todoRepository.save(Todo(title: userInput));
            },
            child: const Text("やらなきゃ"),
          ),
        ],
      ),
    );
  }
}
