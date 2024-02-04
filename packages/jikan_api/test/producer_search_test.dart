import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/api/api.dart';
import 'package:jikan_api/src/api/producer_search_api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/object/producer_query.dart';
import 'package:jikan_api/src/object/response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'producer_search_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Producer Search Positive', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/producers?page=1"),
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

    Api<JikanProducerQuery, JikanProducerResponse> producerSearchApi =
        ProducerSearchApi(client);

    test('Correct producer count', () async {
      JikanProducerResponse res =
          await producerSearchApi.call(JikanProducerQuery()..page = 1);
      expect(res.data!.length, equals(2));
    });
  });

  group('Anime Negative', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/producers"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "wrong": {},
        }),
    );
    test('Data key missing', () async {
      Api<JikanProducerQuery, JikanProducerResponse> producerSearchApi =
          ProducerSearchApi(client);
      expect(() async => await producerSearchApi.call(JikanProducerQuery()),
          throwsA(isA<JikanParseException>()));
    });
  });
}
