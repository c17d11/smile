import 'package:app/controller/state.dart';
import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/anime/model.dart';
import 'package:app/database/src/isar/anime_note/model.dart';
import 'package:app/database/src/isar/anime_response/converter.dart';
import 'package:app/database/src/isar/anime_response/collection.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/object/pagination.dart';
import 'package:isar/isar.dart';

class IsarAnimeResponseModel extends IsarModel implements AnimeResponseModel {
  final IsarAnimeResponseConverter _animeResponseConverter =
      IsarAnimeResponseConverter();
  final IsarAnimeModel _animeModel;
  final IsarAnimeNoteModel _animeNoteModel;
  IsarAnimeResponseModel(super.db)
      : _animeModel = IsarAnimeModel(db),
        _animeNoteModel = IsarAnimeNoteModel(db);

  Future<AnimeResponse?> get(String id) async {
    IsarAnimeResponse? ret =
        await db.isarAnimeResponses.where().qEqualTo(id).findFirst();

    if (ret == null) return null;

    AnimeResponse r = _animeResponseConverter.fromImpl(ret);
    for (int animeId in ret.animeIds ?? []) {
      Anime? a = await _animeModel.get(animeId);
      if (a != null) r.animes!.add(a);
    }
    return r;
  }

  Future<int> insert(AnimeResponse responseIn) async {
    IsarAnimeResponse responseImpl = _animeResponseConverter.toImpl(responseIn);
    for (var anime in responseIn.animes ?? []) {
      int id = await _animeModel.insert(anime);
      responseImpl.animeIds!.add(id);
    }
    int id = await db.isarAnimeResponses.put(responseImpl);
    return id;
  }

  @override
  Future<AnimeResponse?> getAnimeResponse(String query) async {
    return await get(query);
  }

  @override
  Future<void> insertAnimeResponse(AnimeResponse res) async {
    await insert(res);
  }

  @override
  Future<AnimeResponse> getFavoriteAnimes() async {
    List<int> animeIds = await _animeNoteModel.getFavoriteAnimeIds();
    List<Anime> animes = [];
    for (var animeId in animeIds) {
      Anime? a = await _animeModel.getAnime(animeId);
      if (a != null) animes.add(a);
    }

    AnimeResponse res = AnimeResponse()
      ..query = "favorite"
      ..pagination = (Pagination()
        ..lastVisiblePage = 1
        ..hasNextPage = false
        ..currentPage = 1
        ..itemCount = animes.length
        ..itemTotal = animes.length
        ..itemPerPage = animes.length)
      ..animes = animes;
    return res;
  }

  @override
  Future<AnimeResponse> getTagAnimes(String tagName) async {
    List<int> animeIds = await _animeNoteModel.getTagAnimeIds(tagName);

    List<Anime> animes = [];
    for (var animeId in animeIds) {
      Anime? a = await _animeModel.getAnime(animeId);
      if (a != null) animes.add(a);
    }

    AnimeResponse res = AnimeResponse()
      ..query = "tag-$tagName"
      ..pagination = (Pagination()
        ..lastVisiblePage = 1
        ..hasNextPage = false
        ..currentPage = 1
        ..itemCount = animes.length
        ..itemTotal = animes.length
        ..itemPerPage = animes.length)
      ..animes = animes;
    return res;
  }
}
