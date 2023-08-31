import 'jikan_parser.dart';
import '../object/producer.dart';
import 'parser.dart';

class BreifProducerParser implements ProducerParser {
  Parser<Map<String, dynamic>> dataParser = DataParser();

  @override
  Producer parseProducer(Map<String, dynamic> data) {
    return Producer()
      ..malId = data['mal_id']
      ..title = data['name'];
  }

  @override
  Producer parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    Producer producer = parseProducer(data);
    return producer;
  }
}
