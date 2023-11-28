import 'package:app/controller/src/object/anime_query_intern.dart';
import 'package:isar/isar.dart';

part 'isar_producer_query.g.dart';

@Collection()
class IsarProducerQuery extends ProducerQueryIntern {
  Id? id;

  @Index(unique: true, replace: true)
  late String pageUi;

  static IsarProducerQuery from(String pageUi, ProducerQueryIntern q) {
    IsarProducerQuery query = IsarProducerQuery()
      ..searchTerm = q.searchTerm
      ..page = q.page
      ..pageUi = pageUi;
    return query;
  }
}
