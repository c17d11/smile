import '../database_base.dart';

class DatabaseStub implements Database {
  @override
  Future<void> init() {
    throw UnsupportedError('Platform not supported');
  }
}

Database get database => DatabaseStub();
