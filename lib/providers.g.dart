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

@ProviderFor(declarationRepository)
final declarationRepositoryProvider = DeclarationRepositoryProvider._();

final class DeclarationRepositoryProvider
    extends
        $FunctionalProvider<
          DeclarationRepository,
          DeclarationRepository,
          DeclarationRepository
        >
    with $Provider<DeclarationRepository> {
  DeclarationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'declarationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$declarationRepositoryHash();

  @$internal
  @override
  $ProviderElement<DeclarationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeclarationRepository create(Ref ref) {
    return declarationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeclarationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeclarationRepository>(value),
    );
  }
}

String _$declarationRepositoryHash() =>
    r'a0126be0737c301c6af9e211eb814162c971e682';

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'420730d3caa8cf7680c6e318312b83392599ccd0';

@ProviderFor(declarationList)
final declarationListProvider = DeclarationListProvider._();

final class DeclarationListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Declaration>>,
          List<Declaration>,
          FutureOr<List<Declaration>>
        >
    with
        $FutureModifier<List<Declaration>>,
        $FutureProvider<List<Declaration>> {
  DeclarationListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'declarationListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$declarationListHash();

  @$internal
  @override
  $FutureProviderElement<List<Declaration>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Declaration>> create(Ref ref) {
    return declarationList(ref);
  }
}

String _$declarationListHash() => r'85f58874084ca9cf953eeafbfa83a3b5172e4e09';

@ProviderFor(taskList)
final taskListProvider = TaskListFamily._();

final class TaskListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          FutureOr<List<Task>>
        >
    with $FutureModifier<List<Task>>, $FutureProvider<List<Task>> {
  TaskListProvider._({
    required TaskListFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskListHash();

  @override
  String toString() {
    return r'taskListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return taskList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskListHash() => r'00f800e0058ad4b6ebbbc2b7e78e932db728a5ab';

final class TaskListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Task>>, String> {
  TaskListFamily._()
    : super(
        retry: null,
        name: r'taskListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TaskListProvider call(String declarationId) =>
      TaskListProvider._(argument: declarationId, from: this);

  @override
  String toString() => r'taskListProvider';
}

@ProviderFor(generatedTasks)
final generatedTasksProvider = GeneratedTasksFamily._();

final class GeneratedTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  GeneratedTasksProvider._({
    required GeneratedTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'generatedTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$generatedTasksHash();

  @override
  String toString() {
    return r'generatedTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return generatedTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GeneratedTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$generatedTasksHash() => r'2f9914fc06122613250eaaa98fa9603a1e31449b';

final class GeneratedTasksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  GeneratedTasksFamily._()
    : super(
        retry: null,
        name: r'generatedTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GeneratedTasksProvider call(String declarationTitle) =>
      GeneratedTasksProvider._(argument: declarationTitle, from: this);

  @override
  String toString() => r'generatedTasksProvider';
}
