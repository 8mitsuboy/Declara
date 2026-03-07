import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('エラーが発生しました',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('リトライ')),
        ],
      ),
    );
  }
}
