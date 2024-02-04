import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarTag {
  Id? id;

  @Index(name: 'name', unique: true, replace: true)
  String name;

  IsarTag({required this.name});
}
