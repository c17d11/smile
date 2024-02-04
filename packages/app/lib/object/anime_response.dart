import 'package:app/object/pagination.dart';
import 'package:jikan_api/jikan_api.dart';
import 'anime.dart';

class AnimeResponse {
  String? query;
  DateTime? date;
  DateTime? expires;
  Pagination? pagination;
  List<Anime>? animes;

  AnimeResponse();

  AnimeResponse.from(JikanAnimeResponse res) {
    query = res.query;
    date = res.date;
    expires = res.expires;
    pagination = Pagination.from(res.pagination!);
    animes = res.data?.map((e) => Anime.from(e)).toList();
  }
}
