import 'package:app/database/src/interface/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerQuery extends JikanProducerQuery {
  void replace(JikanProducerQuery q) {
    searchTerm = q.searchTerm;
    page = q.page;
  }

  static ProducerQuery from(ProducerQuery q) {
    ProducerQuery query = ProducerQuery()
      ..searchTerm = q.searchTerm
      ..page = q.page;
    return query;
  }

  static ProducerQuery nextPage(ProducerQuery q) {
    ProducerQuery query = ProducerQuery.from(q);
    query.page = (query.page ?? 1) + 1;
    return query;
  }

  @override
  bool operator ==(Object other) =>
      other is ProducerQuery &&
      other.page == page &&
      other.searchTerm == searchTerm;

  @override
  int get hashCode => page.hashCode ^ searchTerm.hashCode;
}
