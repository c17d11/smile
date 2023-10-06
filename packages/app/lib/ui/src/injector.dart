import 'package:app/database/src/database_base.dart';
import 'package:app/database/src/populate_database.dart';
import 'package:flutter/foundation.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:kiwi/kiwi.dart';

class Injector {
  late KiwiContainer container;

  void setup() {
    container = KiwiContainer();

    if (kDebugMode) {
      container.registerSingleton<JikanApi>((container) => JikanApiMockImpl());
      container.registerSingleton((container) => PopulateDatabase(
          container.resolve<Database>(), container.resolve<JikanApi>()));
    } else {
      container.registerSingleton<JikanApi>((container) => JikanApiImpl());
      container.registerSingleton((container) => PopulateDatabase(
          container.resolve<Database>(), container.resolve<JikanApi>()));
    }

    container.registerSingleton((container) => Database());
  }
}
