import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/anime_response/collection.dart';
import 'package:app/object/anime_response.dart';
import 'package:app/object/pagination.dart';

class IsarAnimeResponseConverter
    extends Converter<AnimeResponse, IsarAnimeResponse> {
  @override
  AnimeResponse fromImpl(IsarAnimeResponse t) {
    return AnimeResponse()
      ..query = t.q
      ..timestamp = t.timestamp
      ..pagination = (Pagination()
        ..lastVisiblePage = t.lastVisiblePage
        ..hasNextPage = t.hasNextPage
        ..currentPage = t.currentPage
        ..itemCount = t.itemCount
        ..itemTotal = t.itemTotal
        ..itemPerPage = t.itemPerPage)
      ..animes = [];
  }

  @override
  IsarAnimeResponse toImpl(AnimeResponse t) {
    return IsarAnimeResponse(q: t.query!)
      ..animeIds = []
      ..lastVisiblePage = t.pagination?.lastVisiblePage
      ..hasNextPage = t.pagination?.hasNextPage
      ..currentPage = t.pagination?.currentPage
      ..itemCount = t.pagination?.itemCount
      ..itemTotal = t.pagination?.itemTotal
      ..itemPerPage = t.pagination?.itemPerPage;
  }
}
