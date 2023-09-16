import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/api/anime_api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/anime.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'anime_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Anime Positive', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/anime/1"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": {
            "mal_id": 123,
            "title": "title",
            "score": 1.23,
            "broadcast": {"string": "schedule"},
            "type": "type",
            "source": "source",
            "status": "status",
            "aired": {"from": "airedFrom", "to": "airedTo"},
            "duration": "duration",
            "rating": "rating",
            "rank": 123,
            "synopsis": "synopsis",
            "background": "background",
            "season": "season",
            "year": 123,
            // TODO: broadcast
            "producers": [
              {"mal_id": 123, "name": "title"}
            ],
            "episodes": 123,
            "images": {
              "jpg": {"image_url": "imageUrl"}
            }
          },
        }),
    );

    test('Correct anime', () async {
      AnimeApi animeApi = AnimeApi(client);
      Anime anime = await animeApi.call(1);
      expect(anime.malId, equals(123));
      expect(anime.title, equals("title"));
      expect(anime.score, equals(1.23));
      expect(anime.schedule, equals("schedule"));
      expect(anime.type, equals("type"));
      expect(anime.source, equals("source"));
      expect(anime.status, equals("status"));
      expect(anime.airedFrom, equals("airedFrom"));
      expect(anime.airedTo, equals("airedTo"));
      expect(anime.duration, equals("duration"));
      expect(anime.rating, equals("rating"));
      expect(anime.rank, equals(123));
      expect(anime.synopsis, equals("synopsis"));
      expect(anime.background, equals("background"));
      expect(anime.season, equals("season"));
      expect(anime.year, equals(123));
      expect(anime.producers, isNotNull);
      expect(anime.producers!.length, equals(1));
      expect(anime.producers![0].malId, equals(123));
      expect(anime.producers![0].title, equals("title"));
      expect(anime.episodes, equals(123));
      expect(anime.imageUrl, equals("imageUrl"));
    });
  });

  group('Anime Negative', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/anime/1"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "wrong": {},
        }),
    );
    when(
      client.get("https://api.jikan.moe/v4/anime/2"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": {"key": "value"},
        }),
    );
    test('Data key missing', () async {
      AnimeApi animeApi = AnimeApi(client);
      expect(() async => await animeApi.call(1),
          throwsA(isA<JikanParseException>()));
    });
    test('All null values', () async {
      AnimeApi animeApi = AnimeApi(client);
      Anime anime = await animeApi.call(2);
      expect(anime.malId, isNull);
      expect(anime.title, isNull);
      expect(anime.score, isNull);
      expect(anime.schedule, isNull);
      expect(anime.type, isNull);
      expect(anime.source, isNull);
      expect(anime.status, isNull);
      expect(anime.airedFrom, isNull);
      expect(anime.airedTo, isNull);
      expect(anime.duration, isNull);
      expect(anime.rating, isNull);
      expect(anime.rank, isNull);
      expect(anime.synopsis, isNull);
      expect(anime.background, isNull);
      expect(anime.season, isNull);
      expect(anime.year, isNull);
      expect(anime.producers, isNull);
      expect(anime.episodes, isNull);
      expect(anime.imageUrl, isNull);
    });
  });
}
