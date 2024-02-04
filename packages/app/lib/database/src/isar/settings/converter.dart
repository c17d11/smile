import 'package:app/object/settings.dart';
import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/settings/collection.dart';

class IsarSettingsConverter extends Converter<Settings, IsarSettings> {
  @override
  Settings fromImpl(IsarSettings t) {
    return Settings()
      ..apiSettings = (JikanApiSettings()
        ..requestsPerSecond = t.requestsPerSecond
        ..requestsPerMinute = t.requestsPerMinute)
      ..dbSettings =
          (DatabaseSettings()..cacheTimeoutHours = t.cacheTimeoutHours);
  }

  @override
  IsarSettings toImpl(Settings t) {
    return IsarSettings()
      ..requestsPerSecond = t.apiSettings.requestsPerSecond
      ..requestsPerMinute = t.apiSettings.requestsPerMinute
      ..cacheTimeoutHours = t.dbSettings.cacheTimeoutHours;
  }
}
