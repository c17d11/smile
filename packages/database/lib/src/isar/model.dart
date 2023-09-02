import 'package:isar/isar.dart';

abstract class IsarModel {
  final Isar db;
  IsarModel(this.db);

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
