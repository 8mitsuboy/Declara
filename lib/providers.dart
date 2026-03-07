import 'package:declara/data/local/drift_database.dart';
import 'package:declara/data/repository/drift_todo_repository.dart';
import 'package:declara/domain/todo.dart';
import 'package:declara/repository/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// DIコンテナ
// 作成することで、DBの設定やrepositoryの組み立てロジックが各画面（UI）に散らばることを防ぐ
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

@riverpod
TodoRepository todoRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTodoRepository(db);
}

@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return await todoRepository.findAll();
}
