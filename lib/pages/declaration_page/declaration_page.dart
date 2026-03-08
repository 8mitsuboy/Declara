import 'package:declara/pages/declaration_page/widgets/declaration_tile.dart';
import 'package:declara/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeclarationPage extends ConsumerWidget {
  const DeclarationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final declarationListAsync = ref.watch(declarationListProvider);

    if (declarationListAsync.value case final declarations?
        when declarations.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: declarations.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final declaration = declarations[index];
          return DeclarationTile(
            declarationId: declaration.id,
            declarationTitle: declaration.title.value,
          );
        },
      );
    }
    if (declarationListAsync.hasError) {
      return Center(child: Text('エラー: ${declarationListAsync.error}'));
    }
    if (declarationListAsync.hasValue) {
      return const Center(child: Text('宣言がまだありません'));
    }
    return const Center(child: CircularProgressIndicator());
  }
}
