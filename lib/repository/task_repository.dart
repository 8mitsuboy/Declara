import 'package:declara/domain/task.dart';

abstract class TaskRepository {
  Future<void> saveAll(List<Task> tasks);
  Future<List<Task>> findByDeclarationId(String declarationId);
  Future<void> updateDone(String id, bool done);
}
