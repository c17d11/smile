import 'package:test/test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/api/anime_search_api.dart';
import 'package:jikan_api/src/api/api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/anime_query.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/object/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'anime_search_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Anime Search Positive', () {
    MockHttp client = MockHttp();
    when(
      client.get(any),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": [
            {
              "mal_id": 1,
            },
            {
              "mal_id": 2,
            },
          ],
          "pagination": {"last_visible_page": 1}
        }),
    );

    Api<AnimeQuery, AnimeResponse> animeSearchApi = AnimeSearchApi(client);

    test('Correct anime response', () async {
      AnimeResponse res = await animeSearchApi.call(AnimeQuery()..page = 1);
      expect(res.data, isNotNull);
      expect(res.data!.length, equals(2));
      expect(res.pagination, isNotNull);
      expect(res.pagination!.lastVisiblePage, equals(1));
    });
  });

  group('Anime Negative', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/anime?page=1"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "pagination": {"last_visible_page": 1}
        }),
    );
    when(
      client.get("https://api.jikan.moe/v4/anime?page=2"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": [
            {
              "mal_id": 1,
            },
            {
              "mal_id": 2,
            },
          ],
        }),
    );
    test('Data key missing', () async {
      Api<AnimeQuery, AnimeResponse> animeSearchApi = AnimeSearchApi(client);
      expect(() async => await animeSearchApi.call(AnimeQuery()..page = 1),
          throwsA(isA<JikanParseException>()));
    });
    test('Pagination key missing', () async {
      Api<AnimeQuery, AnimeResponse> animeSearchApi = AnimeSearchApi(client);
      expect(() async => await animeSearchApi.call(AnimeQuery()..page = 2),
          throwsA(isA<JikanParseException>()));
    });
  });
}
