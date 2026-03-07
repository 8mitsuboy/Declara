import 'package:declara/domain/todo.dart';

abstract class TodoRepository {
  Future<void> save(Todo todo);
  Future<List<Todo>> findAll();
}
