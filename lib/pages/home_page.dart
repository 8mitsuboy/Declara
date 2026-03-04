import 'package:declara/pages/create_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:declara/pages/todo_page.dart';

class HomePage extends HookConsumerWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPageIndex = useState<int>(0);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: [const CreateTodoPage(), const TodoPage()][currentPageIndex.value],
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
