import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarProducerQuery {
  @Index(unique: true, replace: true)
  Id id = 1;

  String? searchTerm;
  int? page;
}
