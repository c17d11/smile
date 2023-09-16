import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/http/http.dart';
import 'package:jikan_api/src/api/api.dart';
import 'package:jikan_api/src/api/producer_api.dart';
import 'package:jikan_api/src/http/http_result.dart';
import 'package:jikan_api/src/object/exception.dart';
import 'package:jikan_api/src/object/producer.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'producer_test.mocks.dart';

@GenerateMocks([Http])
void main() {
  group('Producer Positive', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/producers/1"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": {
            "mal_id": 123,
            "images": {
              "jpg": {"image_url": "imageUrl"},
            },
            "titles": [
              {"type": "Default", "title": "title1"},
              {"type": "English", "title": "title2"},
            ],
            "established": "established",
            "about": "about",
            "count": 1,
          },
        }),
    );

    test('Correct producer', () async {
      Api<int, Producer> producerApi = ProducerApi(client);
      Producer producer = await producerApi.call(1);
      expect(producer.malId, equals(123));
      expect(producer.imageUrl, equals("imageUrl"));
      expect(producer.title, equals("title1"));
      expect(producer.established, equals("established"));
      expect(producer.about, equals("about"));
      expect(producer.count, equals(1));
    });
  });

  group('Anime Negative', () {
    MockHttp client = MockHttp();
    when(
      client.get("https://api.jikan.moe/v4/producers/1"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "wrong": {},
        }),
    );
    when(
      client.get("https://api.jikan.moe/v4/producers/2"),
    ).thenAnswer(
      (_) => Future.value(HttpResult()
        ..data = {
          "data": {"key": "value"},
        }),
    );
    test('Data key missing', () async {
      Api<int, Producer> producerApi = ProducerApi(client);
      expect(() async => await producerApi.call(1),
          throwsA(isA<JikanParseException>()));
    });
    test('All null values', () async {
      Api<int, Producer> producerApi = ProducerApi(client);
      Producer producer = await producerApi.call(2);
      expect(producer.malId, isNull);
      expect(producer.imageUrl, isNull);
      expect(producer.title, isNull);
      expect(producer.established, isNull);
      expect(producer.about, isNull);
      expect(producer.count, isNull);
    });
  });
}
