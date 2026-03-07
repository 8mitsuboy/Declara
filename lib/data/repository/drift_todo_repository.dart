import 'package:declara/data/local/drift_database.dart' hide Todo;
import 'package:declara/domain/todo.dart';
import 'package:declara/repository/todo_repository.dart';
import 'package:drift/drift.dart';

class DriftTodoRepository implements TodoRepository {
  DriftTodoRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> save(Todo todo) async {
    await _database.managers.todos.create(
      (o) => o(id: todo.id, label: todo.label.value, done: Value(todo.done)),
    );
  }

  @override
  Future<List<Todo>> findAll() async {
    final rawTodos = await _database.managers.todos.get();
    final todos = rawTodos
        .map(
          (todo) =>
              Todo.rehydrate(id: todo.id, label: todo.label, done: todo.done),
        )
        .toList();
    return todos;
  }
}
