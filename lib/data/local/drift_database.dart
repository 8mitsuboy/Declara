import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift_database.g.dart';

@DataClassName('DeclarationRecord')
class Declarations extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().withLength(min: 1, max: 30)();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TaskRecord')
class Tasks extends Table {
  TextColumn get id => text()();

  TextColumn get declarationId => text().references(Declarations, #id)();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Declarations, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          await m.deleteTable('sub_tasks');
          await m.deleteTable('todos');
          await m.createAll();
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'declara');
  }
}
