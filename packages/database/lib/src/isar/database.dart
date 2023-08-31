import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collection/isar_anime.dart';
import 'collection/isar_anime_response.dart';
import 'collection/isar_producer.dart';
import '../database_base.dart';

class IsarDatabase implements Database {
  late final Isar instance;

  @override
  Future<void> init() async {
    String name = 'isar';
    Directory dir = await getApplicationDocumentsDirectory();
    if (!Isar.instanceNames.contains(name)) {
      instance = await Isar.open(
        [
          IsarAnimeSchema,
          IsarAnimeResponseSchema,
          IsarProducerSchema,
        ],
        directory: dir.path,
        inspector: true,
        name: name,
      );
    }
  }
}

abstract class IsarTransaction {
  IsarDatabase db;
  IsarTransaction({required this.db});

  Future<void> writeTransaction(Future Function() f) async {
    await db.instance.writeTxn(() async {
      await f();
    });
  }
}

Database getDatabase() => IsarDatabase();
