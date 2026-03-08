import 'package:declara/domain/task.dart';
import 'package:declara/pages/declaration_page/widgets/task_check_item.dart';
import 'package:flutter/material.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.tasks,
    required this.allDone,
    required this.onTaskChanged,
  });

  final List<Task> tasks;
  final bool allDone;
  final void Function(String taskId, bool value) onTaskChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (allDone)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.green.withValues(alpha: 0.05),
            child: const Text(
              '宣言達成！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ...tasks.map(
          (task) => TaskCheckItem(
            taskId: task.id,
            title: task.title.value,
            done: task.done,
            onChanged: (value) => onTaskChanged(task.id, value),
          ),
        ),
      ],
    );
  }
}
