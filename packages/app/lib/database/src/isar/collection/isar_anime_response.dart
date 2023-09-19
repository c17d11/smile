import 'package:app/controller/state.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'isar_anime.dart';

part 'isar_anime_response.g.dart';

@Collection(ignore: {'data', 'pagination'})
class IsarAnimeResponse extends AnimeResponseIntern {
  Id? id;

  @Index(unique: true, replace: true)
  String q;

  final isarAnimes = IsarLinks<IsarAnime>();

  IsarAnimeResponse({required this.q});

  static String createQueryString(AnimeQuery q) {
    List<String> queries = [
      "${q.searchTerm}",
      "${q.type?.code}",
      "${q.rating?.lowerCase}",
      "${q.status?.lowerCase}",
      "${q.minScore}",
      "${q.maxScore}",
      "${q.minYear}",
      "${q.maxYear}",
      "${q.sfw}",
      "${q.producers}",
      "${q.page}",
    ];
    String query = queries.join("-");
    return query;
  }

  static IsarAnimeResponse from(AnimeResponse res, AnimeQuery query) {
    String q = createQueryString(query);
    IsarAnimeResponse isarRes = IsarAnimeResponse(q: q)
      ..date = res.date
      ..expires = res.expires
      ..pagination = res.pagination
      ..data = res.data?.map((e) => IsarAnime.from(e)).toList();
    return isarRes;
  }
}
