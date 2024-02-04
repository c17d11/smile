import 'package:app/controller/state.dart';
import 'package:app/database/src/interface/database.dart';
import 'package:app/database/src/isar/anime/collection.dart';
import 'package:app/database/src/isar/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

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
      Anime anime = IsarAnime.from(JikanAnime()..malId = 10);

      await db.insertAnime(anime..title = "1");
      await db.insertAnime(anime..title = "2");
      await db.insertAnime(anime..title = "3");

      List<Anime> animes = await db.getAllAnimes();
      expect(animes, isNotNull);
      expect(animes.length, equals(1));

      Anime? a = await db.getAnime(10);
      expect(a, isNotNull);
      expect(a!.malId, 10);
      expect(a.title, "3");
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteAnime(1);
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      Anime anime = IsarAnime.from(JikanAnime()..malId = 1);
      await db.insertAnime(anime..title = "1");

      List<Anime> animes = await db.getAllAnimes();
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
      IsarAnime anime = IsarAnime.from(JikanAnime()..malId = 1);
      List<IsarAnime> animes = [anime];
      String query = "123";

      IsarAnimeResponse isarAnimeResponse =
          IsarAnimeResponse.from(JikanAnimeResponse()
            ..query = query
            ..data = animes);

      await db.insertAnimeResponse(isarAnimeResponse);

      IsarAnimeResponse isarAnimeResponse2 =
          IsarAnimeResponse.from(JikanAnimeResponse()
            ..query = query
            ..data = []);

      await db.insertAnimeResponse(isarAnimeResponse2);

      AnimeResponseIntern? res = await db.getAnimeResponse(query);
      expect(res, isNotNull);
      expect(res!.data, isNotNull);
      expect(res.data!.length, equals(0));
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteAnimeResponse("123");
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      AnimeResponseIntern res =
          IsarAnimeResponse.from(JikanAnimeResponse()..query = "");
      await db.insertAnimeResponse(res);

      AnimeResponseIntern? ret = await db.getAnimeResponse("");
      expect(ret, isNotNull);

      bool success = await db.deleteAnimeResponse("");
      expect(success, isTrue);

      ret = await db.getAnimeResponse("");
      expect(ret, isNull);
    });
  });

  group('Producer Model', () {
    test('Insert Replaces Existing', () async {
      Producer producer = IsarProducer.from(JikanProducer()..malId = 1);

      await db.insertProducer(producer..title = "1");
      await db.insertProducer(producer..title = "2");

      List<Producer> producers = await db.getAllProducers();
      expect(producers, isNotNull);
      expect(producers.length, equals(1));

      Producer? a = await db.getProducer(1);
      expect(a, isNotNull);
      expect(a!.title, "2");
    });

    test('Delete Fails If Not In Database', () async {
      bool success = await db.deleteProducer(1);
      expect(success, isFalse);
    });

    test('Delete Removes Item', () async {
      Producer producer = IsarProducer.from(JikanProducer()..malId = 1);
      await db.insertProducer(producer..title = "1");

      List<Producer> producers = await db.getAllProducers();
      expect(producers, isNotNull);
      expect(producers.length, equals(1));

      bool success = await db.deleteProducer(1);
      expect(success, isTrue);

      producers = await db.getAllProducers();
      expect(producers.length, equals(0));
    });
  });

  group('Expiration', () {
    setUp(() async {
      Anime anime = IsarAnime.from(JikanAnime()..malId = 10);
      await db.insertAnime(anime..title = "1");
    });

    test('Get Anime When Not Expired', () async {
      Anime? a = await db.getAnime(10);
      expect(a, isNotNull);
    });

    test('Get Null When Expired', () async {
      db.setExpirationHours(0);
      Anime? a = await db.getAnime(10);
      expect(a, isNull);
    });
  });
}
