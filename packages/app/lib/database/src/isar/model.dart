import 'package:app/database/src/isar/common/expiration.dart';
import 'package:isar/isar.dart';

abstract class IsarModel {
  late final Isar db;
  IsarModel(this.db);
}

abstract class IsarExpirationModel extends IsarModel {
  int expirationHours;

  bool isExpired(IsarExpiration? value) =>
      value != null &&
      value.storedAt.difference(DateTime.now()).inHours >= expirationHours;

  IsarExpirationModel(super.db, {required this.expirationHours});
}
