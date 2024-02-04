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

class ProducerSearchApi
    implements Api<JikanProducerQuery, JikanProducerResponse> {
  Http client;
  Builder<JikanProducerQuery, String> builder = ProducerQueryBuilder();
  Parser<List<JikanProducer>> producerSearchParser = ProducerSearchParser();
  Parser<JikanPagination> paginationParser = PaginationParser();
  Parser<JikanApiException> errorParser = ErrorParser();

  ProducerSearchApi(this.client);

  String buildQuery(JikanProducerQuery arg) {
    String query = builder.build(arg);
    query = query.isEmpty ? "" : "?$query";
    return "producers$query";
  }

  @override
  Future<JikanProducerResponse> call(JikanProducerQuery arg) async {
    String query = buildQuery(arg);
    HttpResult res = await client.get(query);
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }

    JikanPagination pagination = paginationParser.parse(res.data ?? {});
    List<JikanProducer> producers = producerSearchParser.parse(res.data ?? {});
    return JikanProducerResponse()
      ..query = query
      ..pagination = pagination
      ..data = producers;
  }
}
