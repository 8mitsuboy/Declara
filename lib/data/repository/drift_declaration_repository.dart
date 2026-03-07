import 'package:declara/data/local/drift_database.dart';
import 'package:declara/domain/declaration.dart';
import 'package:declara/repository/declaration_repository.dart';
import 'package:drift/drift.dart';

class DriftDeclarationRepository implements DeclarationRepository {
  DriftDeclarationRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> save(Declaration declaration) async {
    await _database.managers.declarations.create(
      (o) => o(
        id: declaration.id,
        title: declaration.title.value,
        done: Value(declaration.done),
      ),
    );
  }

  @override
  Future<List<Declaration>> findAll() async {
    final rows = await _database.managers.declarations.get();
    return rows
        .map(
          (r) => Declaration.rehydrate(
            id: r.id,
            title: r.title,
            done: r.done,
          ),
        )
        .toList();
  }
}
