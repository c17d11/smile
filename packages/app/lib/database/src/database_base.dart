import 'package:app/database/src/model.dart';

import 'stub/database.dart' if (dart.library.io) 'isar/database.dart';

abstract interface class Database implements ModelProxy {
  /// Initialise the database
  Future<void> init();

  /// Clear data
  Future<void> clear();

  /// Close the database connection
  Future<void> close();

  /// Remove all data including the database-files
  Future<void> remove();

  factory Database() => database;
}
