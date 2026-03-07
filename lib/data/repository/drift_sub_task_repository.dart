import 'package:declara/data/local/drift_database.dart';
import 'package:declara/domain/sub_task.dart';
import 'package:declara/repository/sub_task_repository.dart';
import 'package:drift/drift.dart';

class DriftSubTaskRepository implements SubTaskRepository {
  DriftSubTaskRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveAll(List<SubTask> subTasks) async {
    await _database.managers.subTasks.bulkCreate(
      (o) => subTasks
          .map(
            (s) => o(
              id: s.id,
              todoId: s.todoId,
              title: s.title.value,
              sortOrder: s.sortOrder,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<List<SubTask>> findByTodoId(String todoId) async {
    final rows = await _database.managers.subTasks
        .filter((f) => f.todoId.id(todoId))
        .orderBy((o) => o.sortOrder.asc())
        .get();
    return rows
        .map(
          (r) => SubTask.rehydrate(
            id: r.id,
            todoId: r.todoId,
            title: r.title,
            done: r.done,
            sortOrder: r.sortOrder,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateDone(String id, bool done) async {
    await _database.managers.subTasks
        .filter((f) => f.id(id))
        .update((o) => o(done: Value(done)));
  }
}
