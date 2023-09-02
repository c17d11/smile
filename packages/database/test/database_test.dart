import 'package:database/src/database_base.dart';
import 'package:database/src/isar/collection/isar_anime.dart';
import 'package:database/src/isar/collection/isar_anime_response.dart';
import 'package:database/src/isar/collection/isar_producer.dart';
import 'package:database/src/isar/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
    return '.';
  });
  Database db = IsarDatabase();

  setUpAll(() async {
    await Isar.initializeIsarCore(download: false);
    await db.init();
    await db.clear();
  });

  setUp(() async {
    await db.clear();
  });

  tearDownAll(() async {
    await db.remove();
  });

  group('Anime Model', () {
    test('Insert Replaces Existing', () async {
      AnimeIntern anime = IsarAnime.from(Anime()..malId = 10);

      await db.insertAnime(anime..title = "1");
      await db.insertAnime(anime..title = "2");
      await db.insertAnime(anime..title = "3");

      List<AnimeIntern> animes = await db.getAllAnimes();
      expect(animes, isNotNull);
      expect(animes.length, equals(1));

      AnimeIntern? a = await db.getAnime(10);
      expect(a, isNotNull);
      expect(a!.malId, 10);
      expect(a.title, "3");
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteAnime(1);
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      AnimeIntern anime = IsarAnime.from(Anime()..malId = 1);
      await db.insertAnime(anime..title = "1");

      List<AnimeIntern> animes = await db.getAllAnimes();
      expect(animes, isNotNull);
      expect(animes.length, equals(1));

      bool success = await db.deleteAnime(1);
      expect(success, isTrue);

      animes = await db.getAllAnimes();
      expect(animes.length, equals(0));
    });
  });

  group('Anime Response Model', () {
    test('Insert Replaces Existing', () async {
      IsarAnime anime = IsarAnime.from(Anime()..malId = 1);
      List<IsarAnime> animes = [anime];
      AnimeQuery query = AnimeQuery()
        ..page = 1
        ..rating = RatingG();
      IsarAnimeResponse isarAnimeResponse =
          IsarAnimeResponse.from(AnimeResponse()..data = animes, query);

      await db.insertAnimeResponse(isarAnimeResponse);

      IsarAnimeResponse isarAnimeResponse2 =
          IsarAnimeResponse.from(AnimeResponse()..data = [], query);

      await db.insertAnimeResponse(isarAnimeResponse2);

      AnimeResponseIntern? res = await db.getAnimeResponse(query);
      expect(res, isNotNull);
      expect(res!.data, isNotNull);
      expect(res.data!.length, equals(0));
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteAnimeResponse(AnimeQuery());
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      AnimeResponseIntern res =
          IsarAnimeResponse.from(AnimeResponse(), AnimeQuery());
      await db.insertAnimeResponse(res);

      AnimeResponseIntern? ret = await db.getAnimeResponse(AnimeQuery());
      expect(ret, isNotNull);

      bool success = await db.deleteAnimeResponse(AnimeQuery());
      expect(success, isTrue);

      ret = await db.getAnimeResponse(AnimeQuery());
      expect(ret, isNull);
    });
  });

  group('Producer Model', () {
    test('Insert Replaces Existing', () async {
      ProducerIntern producer = IsarProducer.from(Producer()..malId = 1);

      await db.insertProducer(producer..title = "1");
      await db.insertProducer(producer..title = "2");

      List<ProducerIntern> producers = await db.getAllProducers();
      expect(producers, isNotNull);
      expect(producers.length, equals(1));

      ProducerIntern? a = await db.getProducer(1);
      expect(a, isNotNull);
      expect(a!.title, "2");
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteProducer(1);
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      ProducerIntern producer = IsarProducer.from(Producer()..malId = 1);
      await db.insertProducer(producer..title = "1");

      List<ProducerIntern> producers = await db.getAllProducers();
      expect(producers, isNotNull);
      expect(producers.length, equals(1));

      bool success = await db.deleteProducer(1);
      expect(success, isTrue);

      producers = await db.getAllProducers();
      expect(producers.length, equals(0));
    });
  });
}
