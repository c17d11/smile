import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarSettings {
  Id id = 1;

  int? requestsPerSecond;
  int? requestsPerMinute;
  int? cacheTimeoutHours;
  int? animePerDeviceWidth;
  double? animeRatio;
}
