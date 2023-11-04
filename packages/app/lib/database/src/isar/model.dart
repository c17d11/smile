import 'package:app/database/src/isar/collection/isar_expiration.dart';
import 'package:isar/isar.dart';

abstract class IsarModel {
  late final Isar db;
  int expirationHours;

  bool isExpired(IsarExpiration? value) =>
      value != null &&
      value.storedAt.difference(DateTime.now()).inHours >= expirationHours;

  IsarModel(this.db, {required this.expirationHours});

  Future<void> write(Future Function() f) async {
    await db.writeTxn(() async {
      await f();
    });
  }

  Future<void> read(Future Function() f) async {
    await db.txn(() async {
      await f();
    });
  }
}
