import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_expiration.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'isar_producer.dart';

part 'isar_anime.g.dart';

@Collection(ignore: {'producers', 'genres'})
class IsarAnime extends AnimeIntern with IsarExpiration {
  @Index(unique: true, replace: true)
  Id id;
  final isarProducers = IsarLinks<IsarProducer>();

  IsarAnime({required this.id}) {
    storedAt = DateTime.now();
  }

  static IsarAnime fromIntern(AnimeIntern t) {
    IsarAnime anime = from(t);
    anime
      ..isBlacklisted = t.isBlacklisted
      ..isFavorite = t.isFavorite;
    return anime;
  }

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
      ..genres = t.genres
      ..episodes = t.episodes
      ..imageUrl = t.imageUrl;
    return anime;
  }
}
