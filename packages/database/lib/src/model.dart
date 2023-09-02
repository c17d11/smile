import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';

abstract interface class AnimeModel {
  Future<void> insertAnime(AnimeIntern anime);
  Future<AnimeIntern?> getAnime(int malId);
  Future<List<AnimeIntern>> getAllAnimes();
  Future<bool> deleteAnime(int malId);
}

abstract interface class AnimeResponseModel {
  Future<void> insertAnimeResponse(AnimeResponseIntern res);
  Future<AnimeResponseIntern?> getAnimeResponse(AnimeQuery query);
  Future<bool> deleteAnimeResponse(AnimeQuery query);
  AnimeResponseIntern createAnimeResponseIntern(
      AnimeResponse res, AnimeQuery query);
}

abstract interface class ProducerModel {
  Future<void> insertProducer(ProducerIntern producer);
  Future<ProducerIntern?> getProducer(int malId);
  Future<List<ProducerIntern>> getAllProducers();
  Future<bool> deleteProducer(int malId);
}

abstract interface class ModelProxy
    implements AnimeModel, AnimeResponseModel, ProducerModel {}
