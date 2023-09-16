import 'package:app/database/src/database_base.dart';
import 'package:flutter/foundation.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:kiwi/kiwi.dart';

class Injector {
  late KiwiContainer container;

  void setup() {
    container = KiwiContainer();

    // if (const bool.fromEnvironment('DEBUG', defaultValue: true)) {
    if (kDebugMode) {
      // container.registerSingleton((container) => MockInterceptor());
      // container.registerSingleton((container) =>
      //     Dio()..interceptors.add(container.resolve<MockInterceptor>()));
      // container.registerSingleton(
      //     (container) => DioWrapper(container.resolve<Dio>()));
      // container.registerSingleton((container) => MockDioWrapper());
      container.registerSingleton<JikanApi>((container) => JikanApiMockImpl());
      // container.registerSingleton<JikanApi>((container) => JikanApiMockImpl());
    } else {
      container.registerSingleton<JikanApi>((container) => JikanApiImpl());
    }

    container.registerSingleton((container) => Database());
  }
}
