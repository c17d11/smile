import 'api.dart';
import '../object/exception.dart';
import '../parser/detailed_producer_parser.dart';
import '../parser/exception_parser.dart';
import '../parser/parser.dart';
import '../object/producer.dart';
import '../http/http.dart';
import '../http/http_result.dart';

class ProducerApi implements Api<int, JikanProducer> {
  Http client;
  Parser<JikanProducer> parser = DetailedProducerParser();
  ErrorParser errorParser = ErrorParser();

  ProducerApi(this.client);

  @override
  Future<JikanProducer> call(int arg) async {
    HttpResult res = await client.get("producers/$arg");
    if (res.error != null) {
      JikanApiException error = errorParser.parse(res.error!);
      return Future.error(error);
    }
    JikanProducer anime = parser.parse(res.data ?? {});
    return anime;
  }
}
