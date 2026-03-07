import 'package:declara/domain/declaration.dart';
import 'package:declara/pages/task_generation_page/task_generation_page.dart';
import 'package:declara/providers.dart';
import 'package:declara/widgets/declara_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class CreateDeclarationPage extends HookConsumerWidget {
  const CreateDeclarationPage({super.key});

  Future<void> _saveAndNavigate(
    BuildContext context,
    WidgetRef ref,
    TextEditingController controller,
  ) async {
    final userInput = controller.text;
    if (userInput.isEmpty) return;
    final declaration = Declaration(title: userInput);
    await ref.read(declarationRepositoryProvider).save(declaration);
    ref.invalidate(declarationListProvider);
    controller.clear();
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TaskGenerationPage(
            declarationId: declaration.id,
            declarationTitle: userInput,
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
            onPressed: () => _saveAndNavigate(context, ref, controller),
            child: const Text("宣言する"),
          ),
        ],
      ),
    );
  }
}
