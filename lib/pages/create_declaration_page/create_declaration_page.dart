import 'package:declara/domain/declaration.dart';
import 'package:declara/pages/task_generation_page/task_generation_page.dart';
import 'package:declara/providers.dart';
import 'package:declara/widgets/declara_text_field.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class CreateDeclarationPage extends HookConsumerWidget {
  const CreateDeclarationPage({super.key, this.onDeclared});

  final VoidCallback? onDeclared;

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
      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              TaskGenerationPage(
            declarationId: declaration.id,
            declarationTitle: userInput,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
      onDeclared?.call();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(flex: 2),
            Text(
              'あなたの「やりたい」を\n宣言しよう',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(flex: 1),
            DeclaraTextField(
              controller: controller,
              onSubmitted: () => _saveAndNavigate(context, ref, controller),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _saveAndNavigate(context, ref, controller),
              icon: const Icon(Icons.campaign),
              label: const Text('宣言する'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
