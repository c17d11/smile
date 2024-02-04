import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarGenre {
  @Index(unique: true, replace: true)
  Id id;

  String? name;
  int? count;

  IsarGenre({required this.id});
}
