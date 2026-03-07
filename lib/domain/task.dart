import 'package:declara/domain/task_title.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String declarationId;
  final TaskTitle title;
  final bool done;
  final int sortOrder;

  Task._({
    required this.id,
    required this.declarationId,
    required this.title,
    this.done = false,
    required this.sortOrder,
  });

  factory Task({
    required String declarationId,
    required String title,
    required int sortOrder,
  }) {
    return Task._(
      id: const Uuid().v4(),
      declarationId: declarationId,
      title: TaskTitle(title),
      sortOrder: sortOrder,
    );
  }

  factory Task.rehydrate({
    required String id,
    required String declarationId,
    required String title,
    required bool done,
    required int sortOrder,
  }) {
    return Task._(
      id: id,
      declarationId: declarationId,
      title: TaskTitle(title),
      done: done,
      sortOrder: sortOrder,
    );
  }
}
