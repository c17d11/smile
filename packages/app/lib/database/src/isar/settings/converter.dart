import 'package:app/object/settings.dart';
import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/settings/collection.dart';

class IsarSettingsConverter extends Converter<Settings, IsarSettings> {
  @override
  Settings fromImpl(IsarSettings t) {
    return Settings()
      ..apiSettings = JikanApiSettings(
        perSecond: t.requestsPerSecond,
        perMinute: t.requestsPerMinute,
      )
      ..dbSettings = DatabaseSettings(
        hours: t.cacheTimeoutHours,
      )
      ..viewSettings = ViewSettings(
        perWidth: t.animePerDeviceWidth,
        ratio: t.animeRatio,
      );
  }

  @override
  IsarSettings toImpl(Settings t) {
    return IsarSettings()
      ..requestsPerSecond = t.apiSettings.requestsPerSecond
      ..requestsPerMinute = t.apiSettings.requestsPerMinute
      ..cacheTimeoutHours = t.dbSettings.cacheTimeoutHours
      ..animePerDeviceWidth = t.viewSettings.animePerDeviceWidth
      ..animeRatio = t.viewSettings.animeRatio;
  }
}
