import '../database_base.dart';

class DatabaseStub implements Database {
  @override
  Future<void> init() {
    throw UnsupportedError('Platform not supported');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Database get database => DatabaseStub();
