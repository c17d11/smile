import 'package:database/src/model.dart';

import 'stub/database.dart' if (dart.library.io) 'isar/database.dart';

abstract interface class Database implements ModelProxy {
  Future<void> init();

  factory Database() => database;
}
