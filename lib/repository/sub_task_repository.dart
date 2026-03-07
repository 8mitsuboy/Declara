import 'package:declara/domain/sub_task.dart';

abstract class SubTaskRepository {
  Future<void> saveAll(List<SubTask> subTasks);
  Future<List<SubTask>> findByTodoId(String todoId);
  Future<void> updateDone(String id, bool done);
}
