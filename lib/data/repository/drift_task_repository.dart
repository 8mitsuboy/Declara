import 'package:declara/data/local/drift_database.dart';
import 'package:declara/domain/task.dart';
import 'package:declara/repository/task_repository.dart';
import 'package:drift/drift.dart';

class DriftTaskRepository implements TaskRepository {
  DriftTaskRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> saveAll(List<Task> tasks) async {
    await _database.managers.tasks.bulkCreate(
      (o) => tasks
          .map(
            (t) => o(
              id: t.id,
              declarationId: t.declarationId,
              title: t.title.value,
              sortOrder: t.sortOrder,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<List<Task>> findByDeclarationId(String declarationId) async {
    final rows = await _database.managers.tasks
        .filter((f) => f.declarationId.id(declarationId))
        .orderBy((o) => o.sortOrder.asc())
        .get();
    return rows
        .map(
          (r) => Task.rehydrate(
            id: r.id,
            declarationId: r.declarationId,
            title: r.title,
            done: r.done,
            sortOrder: r.sortOrder,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateDone(String id, bool done) async {
    await _database.managers.tasks
        .filter((f) => f.id(id))
        .update((o) => o(done: Value(done)));
  }
}
