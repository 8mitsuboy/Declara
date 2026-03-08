import 'package:flutter/material.dart';

class DeclarationHeader extends StatelessWidget {
  const DeclarationHeader({
    super.key,
    required this.title,
    required this.completedTasks,
    required this.totalTasks,
    required this.allDone,
  });

  final String title;
  final int completedTasks;
  final int totalTasks;
  final bool allDone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              allDone ? Icons.check_circle : Icons.campaign,
              color: allDone ? Colors.green : colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (totalTasks > 0)
              Text(
                '$completedTasks/$totalTasks',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: allDone
                          ? Colors.green
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
          ],
        ),
        if (totalTasks > 0) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                allDone ? Colors.green : colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
