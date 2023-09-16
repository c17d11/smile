import 'api.dart';
import '../object/response.dart';
import '../builder/builder.dart';
import '../http/http.dart';
import '../http/http_result.dart';
import '../object/producer_query.dart';
import '../parser/parser.dart';
import '../parser/exception_parser.dart';
import '../parser/pagination_parser.dart';
import '../builder/producer_query_builder.dart';
import '../parser/producer_search_parser.dart';
import '../object/exception.dart';
import '../object/pagination.dart';
import '../object/producer.dart';

class ProducerSearchApi implements Api<ProducerQuery, ProducerResponse> {
  Http client;
  Builder<ProducerQuery, String> builder = ProducerQueryBuilder();
  Parser<List<Producer>> producerSearchParser = ProducerSearchParser();
  Parser<Pagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  ProducerSearchApi(this.client);

  String buildQuery(ProducerQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return query;
  }

  @override
  Future<ProducerResponse> call(ProducerQuery arg) async {
    String query = buildQuery(arg);
    HttpResult res = await client.get("producers$query");
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }

    Pagination pagination = paginationParser.parse(res.data ?? {});
    List<Producer> producers = producerSearchParser.parse(res.data ?? {});
    return ProducerResponse()
      ..pagination = pagination
      ..data = producers;
  }
}
