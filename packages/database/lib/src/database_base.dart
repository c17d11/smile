import 'stub/database.dart' if (dart.library.io) 'isar/database.dart';

abstract class Database {
  Future<void> init();

  factory Database() => database;
}
