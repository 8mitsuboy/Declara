import 'package:declara/domain/todo_label.dart';
import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final TodoLabel label;
  final bool done;

  Todo._({required this.id, required this.label, this.done = false});

  factory Todo({required String title}) {
    return Todo._(id: const Uuid().v4(), label: TodoLabel(title));
  }

  factory Todo.rehydrate({
    required String id,
    required String label,
    required bool done,
  }) {
    return Todo._(id: id, label: TodoLabel(label), done: done);
  }
}
