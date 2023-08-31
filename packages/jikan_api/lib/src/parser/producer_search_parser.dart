import 'detailed_producer_parser.dart';
import 'jikan_parser.dart';
import 'parser.dart';
import '../object/producer.dart';

class ProducerSearchParser implements Parser<List<Producer>> {
  Parser<List> listParser = ListParser();
  ProducerParser producerParser = DetailedProducerParser();

  List<Producer> parseProducerSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<Producer> producers =
        data.map((e) => producerParser.parseProducer(e)).toList();
    return producers;
  }

  @override
  List<Producer> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<Producer> producers = parseProducerSearch(data);
    return producers;
  }
}
