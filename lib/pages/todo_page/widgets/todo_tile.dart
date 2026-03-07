import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoTile extends ConsumerWidget {
  const TodoTile({super.key, required this.todoId, required this.todoLabel});

  final String todoId;
  final String todoLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subTasksAsync = ref.watch(subTaskListProvider(todoId));

    return ExpansionTile(
      title: Text(todoLabel),
      children: [
        if (subTasksAsync.value case final subTasks?
            when subTasks.isNotEmpty)
          Column(
            children: subTasks
                .map(
                  (st) => CheckboxListTile(
                    value: st.done,
                    title: Text(st.title.value),
                    onChanged: (value) async {
                      if (value == null) return;
                      final repo = ref.read(subTaskRepositoryProvider);
                      await repo.updateDone(st.id, value);
                      ref.invalidate(subTaskListProvider(todoId));
                    },
                  ),
                )
                .toList(),
          )
        else if (subTasksAsync.hasError)
          Text('エラー: ${subTasksAsync.error}')
        else if (subTasksAsync.hasValue)
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('サブタスクなし'),
          )
        else
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
