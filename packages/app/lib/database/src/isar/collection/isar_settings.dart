import 'package:app/controller/src/object/settings_intern.dart';
import 'package:isar/isar.dart';

part 'isar_settings.g.dart';

@Collection(ignore: {'apiSettings', 'dbSettings'})
class IsarSettings extends Settings {
  Id? id;

  @Enumerated(EnumType.name)
  IsarJikanApiSettings? isarApiSettings;

  @Enumerated(EnumType.name)
  IsarDatabaseSettings? isarDbSettings;

  static IsarSettings from(Settings s) {
    IsarSettings settings = IsarSettings()
      ..apiSettings = s.apiSettings
      ..isarApiSettings = IsarJikanApiSettings.from(s.apiSettings)
      ..dbSettings = s.dbSettings
      ..isarDbSettings = IsarDatabaseSettings.from(s.dbSettings);
    return settings;
  }
}

@embedded
class IsarJikanApiSettings extends JikanApiSettings {
  static from(JikanApiSettings s) => IsarJikanApiSettings()
    ..requestsPerMinute = s.requestsPerMinute
    ..requestsPerSecond = s.requestsPerSecond;
}

@embedded
class IsarDatabaseSettings extends DatabaseSettings {
  static from(DatabaseSettings s) =>
      IsarDatabaseSettings()..cacheTimeoutHours = s.cacheTimeoutHours;
}
