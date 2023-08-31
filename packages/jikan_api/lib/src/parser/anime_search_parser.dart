import 'anime_parser.dart';
import 'jikan_parser.dart';
import '../object/anime.dart';
import './parser.dart';

class AnimeSearchParser implements Parser<List<Anime>> {
  Parser<List> listParser = ListParser();
  AnimeParser animeParser = AnimeApiParser();

  List<Anime> parseAnimeSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<Anime> animes = data.map((e) => animeParser.parseAnime(e)).toList();
    return animes;
  }

  @override
  List<Anime> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<Anime> animes = parseAnimeSearch(data);
    return animes;
  }
}
