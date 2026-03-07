import 'package:declara/data/local/drift_database.dart';
import 'package:declara/data/repository/drift_declaration_repository.dart';
import 'package:declara/data/repository/drift_task_repository.dart';
import 'package:declara/data/service/claude_ai_service.dart';
import 'package:declara/domain/declaration.dart';
import 'package:declara/domain/task.dart';
import 'package:declara/repository/declaration_repository.dart';
import 'package:declara/repository/task_repository.dart';
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
DeclarationRepository declarationRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftDeclarationRepository(db);
}

@riverpod
TaskRepository taskRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftTaskRepository(db);
}

@riverpod
Future<List<Declaration>> declarationList(Ref ref) async {
  final declarationRepository = ref.watch(declarationRepositoryProvider);
  return await declarationRepository.findAll();
}

@riverpod
Future<List<Task>> taskList(Ref ref, String declarationId) async {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return await taskRepository.findByDeclarationId(declarationId);
}

@riverpod
Future<List<String>> generatedTasks(Ref ref, String declarationTitle) async {
  final aiService = ref.watch(aiServiceProvider);
  return await aiService.generateTasks(declarationTitle);
}
