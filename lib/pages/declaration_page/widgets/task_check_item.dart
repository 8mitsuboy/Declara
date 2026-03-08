import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TaskCheckItem extends HookWidget {
  const TaskCheckItem({
    super.key,
    required this.taskId,
    required this.title,
    required this.done,
    required this.onChanged,
  });

  final String taskId;
  final String title;
  final bool done;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final bounceController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final bounceAnimation = useMemoized(
      () => TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.4, end: 0.9), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
      ]).animate(
        CurvedAnimation(parent: bounceController, curve: Curves.easeInOut),
      ),
      [bounceController],
    );

    void handleChanged(bool? value) {
      if (value == null) return;
      if (value) {
        HapticFeedback.lightImpact();
        bounceController.forward(from: 0);
      }
      onChanged(value);
    }

    return AnimatedOpacity(
      opacity: done ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: ListTile(
        leading: ScaleTransition(
          scale: bounceAnimation,
          child: Checkbox(
            value: done,
            onChanged: handleChanged,
          ),
        ),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 16,
            color: done
                ? Theme.of(context).textTheme.bodyLarge?.color?.withValues(
                      alpha: 0.5,
                    )
                : Theme.of(context).textTheme.bodyLarge?.color,
            decoration:
                done ? TextDecoration.lineThrough : TextDecoration.none,
          ),
          child: Text(title),
        ),
        onTap: () => handleChanged(!done),
      ),
    );
  }
}
