// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'18ce5c8c4d8ddbfe5a7d819d8fb7d5aca76bf416';

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'a03da399b44b3740dc4fcfc6716203041d66ff01';

@ProviderFor(aiService)
final aiServiceProvider = AiServiceProvider._();

final class AiServiceProvider
    extends $FunctionalProvider<AiService, AiService, AiService>
    with $Provider<AiService> {
  AiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aiServiceHash();

  @$internal
  @override
  $ProviderElement<AiService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiService create(Ref ref) {
    return aiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AiService>(value),
    );
  }
}

String _$aiServiceHash() => r'3e1c9ce75858e901728c3e3177e0c16926b82f2d';

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoRepository, TodoRepository, TodoRepository>
    with $Provider<TodoRepository> {
  TodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRepository create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRepository>(value),
    );
  }
}

String _$todoRepositoryHash() => r'a68b8b0d7693970e4ffe78bb444931503170e0ab';

@ProviderFor(subTaskRepository)
final subTaskRepositoryProvider = SubTaskRepositoryProvider._();

final class SubTaskRepositoryProvider
    extends
        $FunctionalProvider<
          SubTaskRepository,
          SubTaskRepository,
          SubTaskRepository
        >
    with $Provider<SubTaskRepository> {
  SubTaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subTaskRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subTaskRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubTaskRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubTaskRepository create(Ref ref) {
    return subTaskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubTaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubTaskRepository>(value),
    );
  }
}

String _$subTaskRepositoryHash() => r'77b896ea0ccd7dbdb8e1c1b0e04e96d903938a82';

@ProviderFor(todoList)
final todoListProvider = TodoListProvider._();

final class TodoListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Todo>>,
          List<Todo>,
          FutureOr<List<Todo>>
        >
    with $FutureModifier<List<Todo>>, $FutureProvider<List<Todo>> {
  TodoListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  $FutureProviderElement<List<Todo>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Todo>> create(Ref ref) {
    return todoList(ref);
  }
}

String _$todoListHash() => r'a6baffdc7b46e4663562ce0c7ea9c18417a75e7f';

@ProviderFor(subTaskList)
final subTaskListProvider = SubTaskListFamily._();

final class SubTaskListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SubTask>>,
          List<SubTask>,
          FutureOr<List<SubTask>>
        >
    with $FutureModifier<List<SubTask>>, $FutureProvider<List<SubTask>> {
  SubTaskListProvider._({
    required SubTaskListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'subTaskListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subTaskListHash();

  @override
  String toString() {
    return r'subTaskListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SubTask>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SubTask>> create(Ref ref) {
    final argument = this.argument as String;
    return subTaskList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubTaskListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subTaskListHash() => r'f24fbb01ead1b0077ff021356216e1e3e5c420d5';

final class SubTaskListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SubTask>>, String> {
  SubTaskListFamily._()
    : super(
        retry: null,
        name: r'subTaskListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SubTaskListProvider call(String todoId) =>
      SubTaskListProvider._(argument: todoId, from: this);

  @override
  String toString() => r'subTaskListProvider';
}
