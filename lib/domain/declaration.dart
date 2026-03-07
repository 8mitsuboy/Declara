import 'package:declara/domain/declaration_title.dart';
import 'package:uuid/uuid.dart';

class Declaration {
  final String id;
  final DeclarationTitle title;
  final bool done;

  Declaration._({required this.id, required this.title, this.done = false});

  factory Declaration({required String title}) {
    return Declaration._(id: const Uuid().v4(), title: DeclarationTitle(title));
  }

  factory Declaration.rehydrate({
    required String id,
    required String title,
    required bool done,
  }) {
    return Declaration._(id: id, title: DeclarationTitle(title), done: done);
  }
}
