import 'detailed_producer_parser.dart';
import 'jikan_parser.dart';
import 'parser.dart';
import '../object/producer.dart';

class ProducerSearchParser implements Parser<List<JikanProducer>> {
  Parser<List> listParser = ListParser();
  ProducerParser producerParser = DetailedProducerParser();

  List<JikanProducer> parseProducerSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<JikanProducer> producers =
        data.map((e) => producerParser.parseProducer(e)).toList();
    return producers;
  }

  @override
  List<JikanProducer> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<JikanProducer> producers = parseProducerSearch(data);
    return producers;
  }
}
