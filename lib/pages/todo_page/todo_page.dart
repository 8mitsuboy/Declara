import 'package:declara/pages/todo_page/widgets/todo_tile.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoPage extends ConsumerWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListAsync = ref.watch(todoListProvider);

    if (todoListAsync.value case final todos? when todos.isNotEmpty) {
      return ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return TodoTile(todoId: todo.id, todoLabel: todo.label.value);
        },
      );
    }
    if (todoListAsync.hasError) {
      return Center(child: Text('エラー: ${todoListAsync.error}'));
    }
    if (todoListAsync.hasValue) {
      return const Center(child: Text('Todoがまだありません'));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
