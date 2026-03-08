import 'package:declara/domain/task.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeneratedTaskList extends HookConsumerWidget {
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
    final totalDuration = tasks.length * 200 + 600;

    final controller = useAnimationController(
      duration: Duration(milliseconds: totalDuration),
    );

    // Build staggered intervals for each task card
    final taskAnimations = useMemoized(() {
      return List.generate(tasks.length, (index) {
        final startFraction = (index * 200) / totalDuration;
        final endFraction =
            ((index * 200) + 400).clamp(0, totalDuration) / totalDuration;
        return CurvedAnimation(
          parent: controller,
          curve: Interval(
            startFraction,
            endFraction,
            curve: Curves.easeOutCubic,
          ),
        );
      });
    }, [tasks.length, totalDuration]);

    // Message animation: starts after all tasks are revealed
    final messageStartFraction = (tasks.length * 200) / totalDuration;
    final messageEndFraction =
        ((tasks.length * 200) + 400).clamp(0, totalDuration) / totalDuration;
    final messageAnimation = useMemoized(
      () => CurvedAnimation(
        parent: controller,
        curve: Interval(
          messageStartFraction,
          messageEndFraction,
          curve: Curves.easeIn,
        ),
      ),
      [messageStartFraction, messageEndFraction],
    );

    // Save button animation: fades in at the very end
    final buttonStartFraction =
        ((tasks.length * 200) + 200).clamp(0, totalDuration) / totalDuration;
    final buttonAnimation = useMemoized(
      () => CurvedAnimation(
        parent: controller,
        curve: Interval(
          buttonStartFraction,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
      [buttonStartFraction],
    );

    // Start the animation on mount
    useEffect(() {
      controller.forward();
      return null;
    }, const []);

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '「$declarationTitle」のタスク',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: taskAnimations[index],
                builder: (context, child) {
                  final value = taskAnimations[index].value;
                  return Transform.translate(
                    offset: Offset(0, 40 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Card(
                    elevation: 3,
                    shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    color: colorScheme.primaryContainer.withValues(alpha: 0.15),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        tasks[index],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Completion message
        FadeTransition(
          opacity: messageAnimation,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              'これだけやればOK！',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        // Save button
        FadeTransition(
          opacity: buttonAnimation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
          ),
        ),
      ],
    );
  }
}
