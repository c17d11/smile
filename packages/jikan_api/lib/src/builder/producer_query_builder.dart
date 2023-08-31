import 'builder.dart';
import '../object/producer_query.dart';

class ProducerQueryBuilder extends Builder<ProducerQuery, String> {
  String buildSearchTermQuery(String? searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      return "";
    }
    return "q=$searchTerm";
  }

  String buildPageQuery(int? page) {
    return page != null ? "page=$page" : "";
  }

  @override
  String build(ProducerQuery arg) {
    List<String> queries = [
      buildSearchTermQuery(arg.searchTerm),
      buildPageQuery(arg.page),
    ];
    return queries.where((e) => e.isNotEmpty).join("&");
  }
}
