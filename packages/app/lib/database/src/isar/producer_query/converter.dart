import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/producer_query/collection.dart';
import 'package:app/object/producer_query.dart';

class IsarProducerQueryConverter
    extends Converter<ProducerQuery, IsarProducerQuery> {
  @override
  ProducerQuery fromImpl(IsarProducerQuery t) {
    return ProducerQuery()
      ..searchTerm = t.searchTerm
      ..page = t.page;
  }

  @override
  IsarProducerQuery toImpl(ProducerQuery t) {
    return IsarProducerQuery()
      ..searchTerm = t.searchTerm
      ..page = t.page;
  }
}
