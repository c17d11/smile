import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarAnimeNote {
  @Index(unique: true, replace: true)
  Id id;

  bool? favorite;
  List<String>? tagIds;
  float? score;
  String? notes;

  IsarAnimeNote({required this.id});
}
