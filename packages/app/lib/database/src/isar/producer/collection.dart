import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarProducer {
  @Index(unique: true, replace: true)
  Id id;

  String? title;
  String? established;
  String? about;
  int? count;
  String? imageUrl;

  IsarProducer({required this.id});
}
