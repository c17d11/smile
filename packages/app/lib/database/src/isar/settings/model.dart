import 'package:app/object/expiration.dart';
import 'package:app/object/settings.dart';
import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/settings/collection.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/settings/converter.dart';
import 'package:isar/isar.dart';

class IsarSettingsModel extends IsarModel implements SettingsModel {
  IsarSettingsModel(super.db);

  Future<Settings?> get() async {
    IsarSettings? settings = await db.isarSettings.where().findFirst();
    return settings == null ? null : IsarSettingsConverter().fromImpl(settings);
  }

  Future<int> insert(Settings settings) async {
    IsarSettings isarSettings = IsarSettingsConverter().toImpl(settings);
    return await db.isarSettings.put(isarSettings);
  }

  @override
  Future<bool> isExpired(Expiration expiration) async {
    Settings? settings = await get();

    if (expiration.timestamp == null) return false;
    if (settings?.dbSettings.cacheTimeoutHours == null) return false;
    return DateTime.now().difference(expiration.timestamp!).inHours >=
        settings!.dbSettings.cacheTimeoutHours!;
  }

  @override
  Future<Settings?> getSettings() async {
    return await get();
  }

  @override
  Future<void> updateSettings(Settings s) async {
    await insert(s);
  }
}
