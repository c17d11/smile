import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/api/api.dart';
import 'package:jikan_api/src/api/genre_search_api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/object/genre.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'genre_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Producer Positive', () {
    MockHttp client = MockHttp();
    when(
      client.get(any),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": [
            {
              "mal_id": 123,
              "name": "Yo",
              "count": 1,
            },
          ]
        }),
    );

    test('Correct genre', () async {
      Api<void, List<Genre>> genreSearchApi = GenreSearchApi(client);
      List<Genre> genres = await genreSearchApi.call(null);
      expect(genres.length, equals(1));
      expect(genres[0].malId, equals(123));
      expect(genres[0].name, equals("Yo"));
      expect(genres[0].count, equals(1));
    });
  });

  group('Anime Negative', () {
    test('Data key missing', () async {
      MockHttp client = MockHttp();
      when(
        client.get(any),
      ).thenAnswer(
        (_) => Future.value(HttpResult()
          ..data = {
            "wrong": {},
          }),
      );
      Api<void, List<Genre>> genreApi = GenreSearchApi(client);
      expect(() async => await genreApi.call(null),
          throwsA(isA<JikanParseException>()));
    });
    test('Zero genres', () async {
      MockHttp client = MockHttp();
      when(
        client.get(any),
      ).thenAnswer(
        (_) => Future.value(HttpResult()
          ..data = {
            "data": [],
          }),
      );
      Api<void, List<Genre>> genreSearchApi = GenreSearchApi(client);
      List<Genre> genres = await genreSearchApi.call(null);
      expect(genres.length, equals(0));
    });
    test('Empty genre', () async {
      MockHttp client = MockHttp();
      when(
        client.get(any),
      ).thenAnswer(
        (_) => Future.value(HttpResult()
          ..data = {
            "data": [
              {"key": "value"},
            ],
          }),
      );
      Api<void, List<Genre>> genreSearchApi = GenreSearchApi(client);
      List<Genre> genres = await genreSearchApi.call(null);
      expect(genres.length, equals(1));
      expect(genres[0].malId, isNull);
      expect(genres[0].name, isNull);
      expect(genres[0].count, isNull);
    });
  });
}
