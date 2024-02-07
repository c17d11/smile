import 'package:app/object/expiration.dart';
import 'package:app/object/pagination.dart';
import 'package:jikan_api/jikan_api.dart';
import 'anime.dart';

class AnimeResponse extends Expiration {
  String? query;
  Pagination? pagination;
  List<Anime>? animes;

  AnimeResponse();

  AnimeResponse.from(JikanAnimeResponse res) {
    query = res.query;
    pagination = Pagination.from(res.pagination!);
    animes = res.data?.map((e) => Anime.from(e)).toList();
  }
}
