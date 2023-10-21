import 'package:jikan_api/src/object/anime_order.dart';
import 'package:jikan_api/src/object/anime_sort.dart';
import 'package:jikan_api/src/object/genre.dart';

import 'builder.dart';
import '../object/anime_query.dart';
import '../object/anime_rating.dart';
import '../object/anime_status.dart';
import '../object/anime_type.dart';
import '../object/producer.dart';

class AnimeQueryBuilder extends Builder<AnimeQuery, String> {
  String buildSearchTermQuery(String? searchTerm) {
    if (searchTerm == null || searchTerm.isEmpty) {
      return "";
    }
    return "q=$searchTerm";
  }

  String buildTypeQuery(AnimeType? type) {
    return type != null ? "type=${type.lowerCase}" : "";
  }

  String buildStatusQuery(AnimeStatus? status) {
    return status != null ? "status=${status.lowerCase}" : "";
  }

  String buildRatingQuery(AnimeRating? rating) {
    return rating != null ? "rating=${rating.lowerCase}" : "";
  }

  String buildMinScoreQuery(double? minScore) {
    return minScore != null ? "min_score=$minScore" : "";
  }

  String buildMaxScoreQuery(double? maxScore) {
    return maxScore != null ? "max_score=$maxScore" : "";
  }

  String boolToString(bool b) {
    return b ? "true" : "false";
  }

  String buildSfwQuery(bool? sfw) {
    return sfw != null ? "sfw=${boolToString(sfw)}" : "";
  }

  String buildMinYearQuery(int? minYear) {
    String s = minYear?.toString() ?? "";
    return s.isNotEmpty ? "start_date=$s" : "";
  }

  String buildMaxYearQuery(int? maxYear) {
    String s = maxYear?.toString() ?? "";
    return s.isNotEmpty ? "end_date=$s" : "";
  }

  String buildPageQuery(int? page) {
    return page != null ? "page=$page" : "";
  }

  String buildProducersQuery(List<Producer>? producers) {
    if (producers == null) {
      return "";
    }
    String producerMalIds =
        producers.where((e) => e.malId != null).map((e) => e.malId).join(',');
    if (producerMalIds.isEmpty) {
      return "";
    }
    return "producers=$producerMalIds";
  }

  String getGenreMalIds(List<Genre>? genres) {
    if (genres == null) {
      return "";
    }
    String genreMalIds =
        genres.where((e) => e.malId != null).map((e) => e.malId).join(',');
    return genreMalIds;
  }

  String buildGenresIncludeQuery(List<Genre>? genres) {
    String genreMalIds = getGenreMalIds(genres);
    if (genreMalIds.isEmpty) {
      return "";
    }
    return "genres=$genreMalIds";
  }

  String buildGenresExcludeQuery(List<Genre>? genres) {
    String genreMalIds = getGenreMalIds(genres);
    if (genreMalIds.isEmpty) {
      return "";
    }
    return "genres_exclude=$genreMalIds";
  }

  String buildOrderBy(AnimeOrder? orderBy) {
    return orderBy != null ? "order_by=${orderBy.queryName}" : "";
  }

  String buildSort(AnimeSort? sort) {
    return sort != null ? "sort=${sort.queryName}" : "";
  }

  @override
  String build(AnimeQuery arg) {
    List<String> queries = [
      buildSearchTermQuery(arg.searchTerm),
      buildTypeQuery(arg.type),
      buildStatusQuery(arg.status),
      buildRatingQuery(arg.rating),
      buildMinScoreQuery(arg.minScore),
      buildMaxScoreQuery(arg.maxScore),
      buildSfwQuery(arg.sfw),
      buildMinYearQuery(arg.minYear),
      buildMaxYearQuery(arg.maxYear),
      buildPageQuery(arg.page),
      buildProducersQuery(arg.producers),
      buildGenresIncludeQuery(arg.genresInclude),
      buildGenresExcludeQuery(arg.genresExclude),
      buildOrderBy(arg.orderBy),
      buildSort(arg.sort),
    ];
    return queries.where((e) => e.isNotEmpty).join("&");
  }
}
