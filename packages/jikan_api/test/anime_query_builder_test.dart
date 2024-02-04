import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/src/builder/anime_query_builder.dart';
import 'package:jikan_api/src/builder/builder.dart';
import 'package:jikan_api/src/object/anime_order.dart';
import 'package:jikan_api/src/object/anime_query.dart';
import 'package:jikan_api/src/object/anime_rating.dart';
import 'package:jikan_api/src/object/anime_sort.dart';
import 'package:jikan_api/src/object/anime_status.dart';
import 'package:jikan_api/src/object/anime_type.dart';
import 'package:jikan_api/src/object/producer.dart';

void main() {
  group('Anime Query Builder Positive', () {
    Builder<JikanAnimeQuery, String> builder = AnimeQueryBuilder();

    String s = builder.build(
      JikanAnimeQuery()
        ..searchTerm = 'searchTerm'
        ..type = JikanAnimeType.tv
        ..rating = JikanAnimeRating.g
        ..status = JikanAnimeStatus.airing
        ..minScore = 1.0
        ..maxScore = 9.99
        ..minYear = 1
        ..maxYear = 2
        ..sfw = true
        ..producers = [
          JikanProducer()..malId = 1,
          JikanProducer()..malId = 2,
        ]
        ..page = 1
        ..orderBy = JikanAnimeOrder.malId
        ..sort = JikanAnimeSort.asc,
    );
    List<String> subQueries = s.split("&");

    test('Correct searchTerm', () {
      expect(subQueries.contains("q=searchTerm"), isTrue);
    });
    test('Correct type', () {
      expect(subQueries.contains("type=tv"), isTrue);
    });
    test('Correct rating', () {
      expect(subQueries.contains("rating=g"), isTrue);
    });
    test('Correct status', () {
      expect(subQueries.contains("status=airing"), isTrue);
    });
    test('Correct minScore', () {
      expect(subQueries.contains("min_score=1.0"), isTrue);
    });
    test('Correct maxScore', () {
      expect(subQueries.contains("max_score=9.99"), isTrue);
    });
    test('Correct minYear', () {
      expect(subQueries.contains("start_date=1"), isTrue);
    });
    test('Correct maxYear', () {
      expect(subQueries.contains("end_date=2"), isTrue);
    });
    test('Correct sfw', () {
      expect(subQueries.contains("sfw=true"), isTrue);
    });
    test('Correct producers', () {
      expect(subQueries.contains("producers=1,2"), isTrue);
    });
    test('Correct orderBy', () {
      expect(subQueries.contains("order_by=mal_id"), isTrue);
    });

    test('Correct sort', () {
      expect(subQueries.contains("sort=asc"), isTrue);
    });
  });

  group('Anime Query Builder Negative', () {
    Builder<JikanAnimeQuery, String> builder = AnimeQueryBuilder();

    String s = builder.build(
      JikanAnimeQuery()
        ..searchTerm = ''
        ..producers = [
          JikanProducer(),
          JikanProducer(),
        ],
    );
    List<String> subQueries = s.split("&");

    // splitting an empty string returns an list with an empty string
    subQueries.removeWhere((e) => e.isEmpty);
    List<String> subQueryNames =
        subQueries.map((e) => e.substring(0, e.indexOf('='))).toList();

    test('Remove empty searchTerm', () {
      expect(subQueryNames.contains("q"), isFalse);
    });
    test('Remove producers without malId', () {
      expect(subQueryNames.contains("producers"), isFalse);
    });

    String s2 = builder.build(
      JikanAnimeQuery()
        ..producers = [
          JikanProducer()..malId = 1,
        ],
    );
    List<String> subQueries2 = s2.split("&");
    test('Remove trailing comma when only one producer', () {
      expect(subQueries2.contains("producers=1"), isTrue);
    });
  });
}
