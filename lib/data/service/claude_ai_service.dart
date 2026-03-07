import 'dart:convert';

import 'package:declara/service/ai_service.dart';
import 'package:dio/dio.dart';

// TODO: 仮実装（APIキーをアプリに埋め込むのはナンセンスだけれど、時間がないから一旦これで対応）
class ClaudeAiService implements AiService {
  ClaudeAiService({required this.dio, required this.apiKey});

  final Dio dio;
  final String apiKey;

  @override
  Future<List<String>> generateSubTasks(String todoTitle) async {
    final response = await dio.post(
      'https://api.anthropic.com/v1/messages',
      options: Options(
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        },
      ),
      data: {
        'model': 'claude-haiku-4-5-20251001',
        'max_tokens': 1024,
        'messages': [
          {
            'role': 'user',
            'content':
                'あなたはタスク分解の専門家です。以下のTodoを3〜7個の具体的なサブタスクに分解してください。'
                'JSON配列形式で、各要素は文字列としてサブタスク名のみを返してください。'
                '説明や番号は不要です。JSON配列のみを返してください。\n\n'
                'Todo: $todoTitle',
          },
        ],
      },
    );

    final content = response.data['content'][0]['text'] as String;
    // Extract JSON array from response
    final jsonMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(content);
    if (jsonMatch == null) {
      throw FormatException('Failed to parse AI response');
    }
    final List<dynamic> parsed = jsonDecode(jsonMatch.group(0)!);
    return parsed.cast<String>();
  }
}
