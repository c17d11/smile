import 'package:app/database/src/interface/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JikanApiSettings {
  int? requestsPerSecond = 3;
  int? requestsPerMinute = 60;
}

class DatabaseSettings {
  int? cacheTimeoutHours = 24;
}

class Settings {
  JikanApiSettings apiSettings = JikanApiSettings();
  DatabaseSettings dbSettings = DatabaseSettings();

  static Settings from(Settings s) {
    Settings settings = Settings()
      ..apiSettings = s.apiSettings
      ..dbSettings = s.dbSettings;
    return settings;
  }
}
