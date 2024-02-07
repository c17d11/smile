import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/anime/collection.dart';
import 'package:app/object/anime.dart';

class IsarAnimeConverter extends Converter<Anime, IsarAnime> {
  @override
  Anime fromImpl(IsarAnime t) {
    return Anime()
      ..malId = t.id
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
      ..producers = []
      ..genres = []
      ..episodes = t.episodes
      ..imageUrl = t.imageUrl;
  }

  @override
  IsarAnime toImpl(Anime t) {
    return IsarAnime(id: t.malId!)
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
      ..producerIds = []
      ..genreIds = []
      ..episodes = t.episodes
      ..imageUrl = t.imageUrl;
  }
}
