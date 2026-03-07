import 'package:declara/data/local/drift_database.dart';
import 'package:declara/data/repository/drift_sub_task_repository.dart';
import 'package:declara/data/repository/drift_todo_repository.dart';
import 'package:declara/data/service/claude_ai_service.dart';
import 'package:declara/domain/sub_task.dart';
import 'package:declara/domain/todo.dart';
import 'package:declara/repository/sub_task_repository.dart';
import 'package:declara/repository/todo_repository.dart';
import 'package:declara/service/ai_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// DIコンテナ
// 作成することで、DBの設定やrepositoryの組み立てロジックが各画面（UI）に散らばることを防ぐ
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

@riverpod
Dio dio(Ref ref) {
  return Dio();
}

@riverpod
AiService aiService(Ref ref) {
  final dioInstance = ref.watch(dioProvider);
  final apiKey = dotenv.env['CLAUDE_API_KEY'] ?? '';
  return ClaudeAiService(dio: dioInstance, apiKey: apiKey);
}

@riverpod
TodoRepository todoRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTodoRepository(db);
}

@riverpod
SubTaskRepository subTaskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftSubTaskRepository(db);
}

@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  final todoRepository = ref.watch(todoRepositoryProvider);
  return await todoRepository.findAll();
}

@riverpod
Future<List<SubTask>> subTaskList(Ref ref, String todoId) async {
  final subTaskRepository = ref.watch(subTaskRepositoryProvider);
  return await subTaskRepository.findByTodoId(todoId);
}

@riverpod
Future<List<String>> generatedSubTasks(Ref ref, String todoTitle) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.generateSubTasks(todoTitle);
}
