import 'jikan_parser.dart';
import '../object/producer.dart';
import 'parser.dart';

class DetailedProducerParser implements ProducerParser {
  Parser<Map<String, dynamic>> dataParser = DataParser();

  String? parseDefaultTitle(List? titles) {
    List? defaultTitles = titles?.where((e) => e['type'] == "Default").toList();
    if (defaultTitles != null && defaultTitles.isNotEmpty) {
      return defaultTitles[0]['title'];
    }
    return null;
  }

  String? parseImageUrl(Map? imageData) {
    return imageData?['jpg']['image_url'];
  }

  @override
  Producer parseProducer(Map<String, dynamic> data) {
    return Producer()
      ..malId = data['mal_id']
      ..title = parseDefaultTitle(data['titles'])
      ..established = data['established']
      ..about = data['about']
      ..count = data['count']
      ..imageUrl = parseImageUrl(data['images']);
  }

  @override
  Producer parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    Producer producer = parseProducer(data);
    return producer;
  }
}
