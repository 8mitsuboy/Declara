import 'package:declara/domain/sub_task_title.dart';
import 'package:uuid/uuid.dart';

class SubTask {
  final String id;
  final String todoId;
  final SubTaskTitle title;
  final bool done;
  final int sortOrder;

  SubTask._({
    required this.id,
    required this.todoId,
    required this.title,
    this.done = false,
    required this.sortOrder,
  });

  factory SubTask({
    required String todoId,
    required String title,
    required int sortOrder,
  }) {
    return SubTask._(
      id: const Uuid().v4(),
      todoId: todoId,
      title: SubTaskTitle(title),
      sortOrder: sortOrder,
    );
  }

  factory SubTask.rehydrate({
    required String id,
    required String todoId,
    required String title,
    required bool done,
    required int sortOrder,
  }) {
    return SubTask._(
      id: id,
      todoId: todoId,
      title: SubTaskTitle(title),
      done: done,
      sortOrder: sortOrder,
    );
  }
}
