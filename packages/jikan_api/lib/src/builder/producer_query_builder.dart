import 'builder.dart';
import '../object/producer_query.dart';

class ProducerQueryBuilder extends Builder<JikanProducerQuery, String> {
  String buildSearchTermQuery(String? searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      return "";
    }
    return "letter=${searchTerm[0]}";
  }

  String buildPageQuery(int? page) {
    return page != null ? "page=$page" : "";
  }

  @override
  String build(JikanProducerQuery arg) {
    List<String> queries = [
      buildSearchTermQuery(arg.searchTerm),
      buildPageQuery(arg.page),
    ];
    return queries.where((e) => e.isNotEmpty).join("&");
  }
}
