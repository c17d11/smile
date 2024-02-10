class JikanApiSettings {
  // Default values
  int requestsPerSecond = 3;
  int requestsPerMinute = 60;

  JikanApiSettings({int? perSecond, int? perMinute}) {
    if (perSecond != null) requestsPerSecond = perSecond;
    if (perMinute != null) requestsPerMinute = perMinute;
  }

  JikanApiSettings copy() => JikanApiSettings(
      perSecond: requestsPerSecond, perMinute: requestsPerMinute);
}

class DatabaseSettings {
  // Default values
  int cacheTimeoutHours = 24;

  DatabaseSettings({int? hours}) {
    if (hours != null) cacheTimeoutHours = hours;
  }

  DatabaseSettings copy() => DatabaseSettings(hours: cacheTimeoutHours);
}

class ViewSettings {
  // Default values
  int animePerDeviceWidth = 4;
  double animeRatio = 7 / 10;

  ViewSettings({int? perWidth, double? ratio}) {
    if (perWidth != null) animePerDeviceWidth = perWidth;
    if (ratio != null) animeRatio = ratio;
  }

  ViewSettings copy() =>
      ViewSettings(perWidth: animePerDeviceWidth, ratio: animeRatio);

  @override
  bool operator ==(Object other) =>
      other is ViewSettings &&
      other.animePerDeviceWidth == animePerDeviceWidth &&
      other.animeRatio == animeRatio;

  @override
  int get hashCode => animePerDeviceWidth.hashCode ^ animeRatio.hashCode;
}

class Settings {
  JikanApiSettings apiSettings = JikanApiSettings();
  DatabaseSettings dbSettings = DatabaseSettings();
  ViewSettings viewSettings = ViewSettings();

  Settings copy() => Settings()
    ..apiSettings = apiSettings.copy()
    ..dbSettings = dbSettings.copy()
    ..viewSettings = viewSettings.copy();

  @override
  bool operator ==(Object other) =>
      other is Settings &&
      // other.apiSettings == apiSettings &&
      // other.dbSettings == dbSettings &&
      other.viewSettings == viewSettings;

  @override
  int get hashCode =>
      // apiSettings.hashCode ^ viewSettings.hashCode ^
      viewSettings.hashCode;
}
