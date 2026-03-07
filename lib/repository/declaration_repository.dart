import 'package:declara/domain/declaration.dart';

abstract class DeclarationRepository {
  Future<void> save(Declaration declaration);
  Future<List<Declaration>> findAll();
}
