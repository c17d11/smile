import 'package:app/object/anime_notes.dart';
import 'package:jikan_api/jikan_api.dart';

class Anime extends JikanAnime {
  AnimeNotes? notes;

  Anime();

  Anime.from(JikanAnime anime) {
    malId = anime.malId;
    title = anime.title;
    titles = anime.titles;
    score = anime.score;
    schedule = anime.schedule;
    type = anime.type;
    source = anime.source;
    status = anime.status;
    airedFrom = anime.airedFrom;
    airedTo = anime.airedTo;
    duration = anime.duration;
    rating = anime.rating;
    rank = anime.rank;
    synopsis = anime.synopsis;
    background = anime.background;
    season = anime.season;
    year = anime.year;
    broadcast = anime.broadcast;
    producers = anime.producers;
    genres = anime.genres;
    episodes = anime.episodes;
    imageUrl = anime.imageUrl;
  }

  // @override
  // bool operator ==(Object other) => other is Anime && other.malId == malId;

  // @override
  // int get hashCode => malId.hashCode;
}
