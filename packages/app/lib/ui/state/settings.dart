import 'package:app/database/src/interface/database.dart';
import 'package:app/object/settings.dart';
import 'package:app/ui/state/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings> {
  final Database db;
  SettingsNotifier(this.db) : super(Settings());

  Future<void> load() async {
    Settings? settings = await db.getSettings();
    state = settings ?? Settings();
  }

  Future<void> set(Settings newSettings) async {
    await db.updateSettings(newSettings);
    state = newSettings;
  }
}

final settingsPod = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
  Database db = ref.watch(databasePod);
  final notifier = SettingsNotifier(db);
  notifier.load();
  return notifier;
});
