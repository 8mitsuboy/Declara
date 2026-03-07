import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift_database.g.dart';

@DataClassName('TodoRecord')
class Todos extends Table {
  TextColumn get id => text()();

  TextColumn get label => text().withLength(min: 1, max: 30)();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SubTaskRecord')
class SubTasks extends Table {
  TextColumn get id => text()();

  TextColumn get todoId => text().references(Todos, #id)();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Todos, SubTasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(subTasks);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'declara.sqlite');
  }
}
