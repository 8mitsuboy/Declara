import 'package:confetti/confetti.dart';
import 'package:declara/pages/declaration_page/widgets/declaration_header.dart';
import 'package:declara/pages/declaration_page/widgets/task_list_section.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeclarationTile extends HookConsumerWidget {
  const DeclarationTile({
    super.key,
    required this.declarationId,
    required this.declarationTitle,
  });

  final String declarationId;
  final String declarationTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider(declarationId));
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(seconds: 2)),
    );

    useEffect(() {
      return confettiController.dispose;
    }, [confettiController]);

    final tasks = tasksAsync.value;
    final totalTasks = tasks?.length ?? 0;
    final completedTasks = tasks?.where((t) => t.done).length ?? 0;
    final allDone = totalTasks > 0 && completedTasks == totalTasks;

    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Card(
          elevation: 2,
          shadowColor: colorScheme.primary.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: allDone
                ? const BorderSide(color: Colors.green, width: 1.5)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: allDone
                  ? Colors.green.withValues(alpha: 0.08)
                  : colorScheme.primaryContainer.withValues(alpha: 0.15),
              title: DeclarationHeader(
                title: declarationTitle,
                completedTasks: completedTasks,
                totalTasks: totalTasks,
                allDone: allDone,
              ),
              children: [
                if (tasksAsync.value case final tasks? when tasks.isNotEmpty)
                  TaskListSection(
                    tasks: tasks,
                    allDone: allDone,
                    onTaskChanged: (taskId, value) async {
                      final repo = ref.read(taskRepositoryProvider);
                      await repo.updateDone(taskId, value);
                      ref.invalidate(taskListProvider(declarationId));

                      final willAllBeDone =
                          value && completedTasks + 1 == totalTasks;
                      if (willAllBeDone) {
                        confettiController.play();
                      }
                    },
                  )
                else if (tasksAsync.hasError)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('エラー: ${tasksAsync.error}'),
                  )
                else if (tasksAsync.hasValue)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('タスクなし'),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 20,
          gravity: 0.3,
          emissionFrequency: 0.05,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.yellow,
          ],
        ),
      ],
    );
  }
}
