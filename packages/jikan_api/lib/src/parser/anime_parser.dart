import 'breif_producer_parser.dart';
import 'jikan_parser.dart';
import '../object/anime.dart';
import '../object/producer.dart';

class AnimeApiParser implements AnimeParser {
  DataParser dataParser = DataParser();
  ProducerParser producerParser = BreifProducerParser();

  double? parseAsDouble(value) => value is int ? value.toDouble() : value;
  List<Producer>? parseProducers(List? producers) {
    return producers?.map((e) => producerParser.parseProducer(e)).toList();
  }

  @override
  Anime parseAnime(Map<String, dynamic> data) {
    Anime anime = Anime()
      ..malId = data['mal_id']
      ..title = data['title']
      // TODO titles
      ..score = parseAsDouble(data['score'])
      ..schedule = data['broadcast']?['string']
      ..type = data['type']
      ..source = data['source']
      ..status = data['status']
      ..airedFrom = data['aired']?['from']
      ..airedTo = data['aired']?['to']
      ..duration = data['duration']
      ..rating = data['rating']
      ..rank = data['rank']
      ..synopsis = data['synopsis']
      ..background = data['background']
      ..season = data['season']
      ..year = data['year']
      ..broadcast = DateTime.now() // TODO: Parse to utc
      ..producers = parseProducers(data['producers'])
      // TODO: studios etc
      ..episodes = data['episodes']
      ..imageUrl = data['images']?['jpg']?['image_url'];
    return anime;
  }

  @override
  Anime parse(Map<String, dynamic> value) {
    Map<String, dynamic> data = dataParser.parse(value);
    Anime anime = parseAnime(data);
    return anime;
  }
}
