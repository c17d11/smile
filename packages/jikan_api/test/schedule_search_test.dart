import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/api/api.dart';
import 'package:jikan_api/src/api/schedule_search_api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/object/response.dart';
import 'package:jikan_api/src/object/schedule_query.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'schedule_search_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Producer Search Positive', () {
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
          "pagination": {
            "last_visible_page": 1,
          }
        }),
    );

    Api<JikanScheduleQuery, JikanAnimeResponse> scheduleSearchApi =
        ScheduleSearchApi(client);

    test('Correct anime count', () async {
      JikanAnimeResponse res =
          await scheduleSearchApi.call(JikanScheduleQuery()..page = 1);
      expect(res.data!.length, equals(2));
    });
  });

  group('Anime Negative', () {
    MockHttp client = MockHttp();
    when(
      client.get(any),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "wrong": {},
        }),
    );
    Api<JikanScheduleQuery, JikanAnimeResponse> scheduleSearchApi =
        ScheduleSearchApi(client);
    test('Data key missing', () async {
      expect(() async => await scheduleSearchApi.call(JikanScheduleQuery()),
          throwsA(isA<JikanParseException>()));
    });
  });
}
