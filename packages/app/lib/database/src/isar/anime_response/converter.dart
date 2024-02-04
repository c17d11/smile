import 'package:app/controller/state.dart';
import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/anime_response/collection.dart';
import 'package:app/object/pagination.dart';

class IsarAnimeResponseConverter
    extends Converter<AnimeResponse, IsarAnimeResponse> {
  @override
  AnimeResponse fromImpl(IsarAnimeResponse t) {
    return AnimeResponse()
      ..query = t.q
      ..date = t.date
      ..expires = t.expires
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
      ..date = t.date
      ..expires = t.expires
      ..animeIds = []
      ..lastVisiblePage = t.pagination?.lastVisiblePage
      ..hasNextPage = t.pagination?.hasNextPage
      ..currentPage = t.pagination?.currentPage
      ..itemCount = t.pagination?.itemCount
      ..itemTotal = t.pagination?.itemTotal
      ..itemPerPage = t.pagination?.itemPerPage;
  }
}
