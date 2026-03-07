import 'package:declara/pages/create_declaration_page/create_declaration_page.dart';
import 'package:declara/pages/declaration_page/declaration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = [const CreateDeclarationPage(), const DeclarationPage()];
    final currentPageIndex = useState<int>(0);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: pages[currentPageIndex.value],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex.value,
        onDestinationSelected: (int index) {
          currentPageIndex.value = index;
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.list_alt)),
            label: "宣言一覧",
          ),
        ],
      ),
    );
  }
}
