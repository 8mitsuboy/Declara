import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:declara/pages/todo_page.dart';

class HomePage extends HookConsumerWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final colorScheme = Theme.of(context).colorScheme;
    final currentPageIndex = useState<int>(0);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: "やりたいこと",
                  hintText: "例: 引っ越し業者を比較する",
                  prefixIcon: const Icon(Icons.edit_note),
                  suffixIcon: IconButton(
                    onPressed: controller.clear,
                    icon: const Icon(Icons.close),
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => {}, child: const Text("やらなきゃ")),
            ],
          ),
        ),
        const TodoPage(),
      ][currentPageIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex.value,
        onDestinationSelected: (int index) {
          currentPageIndex.value = index;
        },
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.list_alt)),
            label: "Todos",
          ),
        ],
      ),
    );
  }
}
