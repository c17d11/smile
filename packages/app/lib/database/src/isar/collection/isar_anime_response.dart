import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_expiration.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'isar_anime.dart';

part 'isar_anime_response.g.dart';

@Collection(ignore: {'data', 'pagination'})
class IsarAnimeResponse extends AnimeResponseIntern with IsarExpiration {
  Id? id;

  @Index(unique: true, replace: true)
  String q;

  final isarAnimes = IsarLinks<IsarAnime>();
  IsarPagination? isarPagination;

  IsarAnimeResponse({required this.q}) {
    storedAt = DateTime.now();
  }

  static IsarAnimeResponse from(AnimeResponse res) {
    IsarAnimeResponse isarRes = IsarAnimeResponse(q: res.query!)
      ..query = res.query
      ..date = res.date
      ..expires = res.expires
      ..pagination = res.pagination
      ..data = res.data?.map((e) => IsarAnime.from(e)).toList();
    return isarRes;
  }
}

@embedded
class IsarPagination extends Pagination {
  static IsarPagination? from(Pagination? pagination) {
    if (pagination == null) return null;
    IsarPagination p = IsarPagination()
      ..lastVisiblePage = pagination.lastVisiblePage
      ..hasNextPage = pagination.hasNextPage
      ..currentPage = pagination.currentPage
      ..itemCount = pagination.itemCount
      ..itemTotal = pagination.itemTotal
      ..itemPerPage = pagination.itemPerPage;
    return p;
  }
}
