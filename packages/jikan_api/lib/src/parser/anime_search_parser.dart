import 'anime_parser.dart';
import 'jikan_parser.dart';
import '../object/anime.dart';
import './parser.dart';

class AnimeSearchParser implements Parser<List<JikanAnime>> {
  Parser<List> listParser = ListParser();
  AnimeParser animeParser = AnimeApiParser();

  List<JikanAnime> parseAnimeSearch(List data) {
    if (data.isEmpty) {
      return [];
    }
    List<JikanAnime> animes =
        data.map((e) => animeParser.parseAnime(e)).toList();
    return animes;
  }

  @override
  List<JikanAnime> parse(Map<String, dynamic> value) {
    List data = listParser.parse(value);
    List<JikanAnime> animes = parseAnimeSearch(data);
    return animes;
  }
}
