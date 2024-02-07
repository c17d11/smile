import 'package:isar/isar.dart';

abstract class IsarModel {
  late final Isar db;
  IsarModel(this.db);
}
