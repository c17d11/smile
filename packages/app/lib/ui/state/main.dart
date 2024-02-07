import 'package:app/database/src/interface/database.dart';
import 'package:app/ui/routes/home/pages/injector.dart';
import 'package:app/ui/state/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

final depencyInjectorPod = Provider((ref) => Injector()..setup());

final apiPod = Provider<JikanApi>((ref) {
  final settings = ref.watch(settingsPod);
  final api = ref.watch(depencyInjectorPod).container.resolve<JikanApi>();
  api.setRequestRate(
    requestsPerSecond: settings.apiSettings.requestsPerSecond,
    requestsPerMinute: settings.apiSettings.requestsPerMinute,
  );
  return api;
});

final databasePod = Provider((ref) {
  return ref.watch(depencyInjectorPod).container.resolve<Database>();
});

final initPod = FutureProvider<bool>((ref) async {
  await ref.watch(databasePod).init();
  return true;
});
