import 'jikan_parser.dart';
import '../object/producer.dart';
import 'parser.dart';

class BreifProducerParser implements ProducerParser {
  Parser<Map<String, dynamic>> dataParser = DataParser();

  @override
  JikanProducer parseProducer(Map<String, dynamic> data) {
    return JikanProducer()
      ..malId = data['mal_id']
      ..title = data['name'];
  }

  @override
  JikanProducer parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    JikanProducer producer = parseProducer(data);
    return producer;
  }
}
