import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';
import 'isar_producer.dart';

part 'isar_anime.g.dart';

@Collection(ignore: {'producers'})
class IsarAnime extends AnimeIntern {
  @Index(unique: true, replace: true)
  Id id;
  final isarProducers = IsarLinks<IsarProducer>();

  IsarAnime({required this.id});

  static IsarAnime from(Anime t) {
    IsarAnime anime = IsarAnime(id: t.malId!)
      ..malId = t.malId
      ..title = t.title
      ..titles = t.titles
      ..score = t.score
      ..schedule = t.schedule
      ..type = t.type
      ..source = t.source
      ..status = t.status
      ..airedFrom = t.airedFrom
      ..airedTo = t.airedTo
      ..duration = t.duration
      ..rating = t.rating
      ..rank = t.rank
      ..synopsis = t.synopsis
      ..background = t.background
      ..season = t.season
      ..year = t.year
      ..broadcast = t.broadcast
      ..producers = t.producers
      ..episodes = t.episodes
      ..imageUrl = t.imageUrl;
    return anime;
  }
}
