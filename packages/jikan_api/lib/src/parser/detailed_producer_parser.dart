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

  String parseTitleFromUrl(String url) {
    String titleWithUnderscore = url.split('/').last;
    String title = titleWithUnderscore.replaceAll('_', ' ');
    return title;
  }

  String? parseImageUrl(Map? imageData) {
    return imageData?['jpg']['image_url'];
  }

  @override
  JikanProducer parseProducer(Map<String, dynamic> data) {
    return JikanProducer()
      ..malId = data['mal_id']
      ..title = parseTitleFromUrl(data['url'])
      ..established = data['established']
      ..about = data['about']
      ..count = data['count']
      ..imageUrl = parseImageUrl(data['images']);
  }

  @override
  JikanProducer parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    JikanProducer producer = parseProducer(data);
    return producer;
  }
}
