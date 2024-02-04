import 'pagination.dart';
import 'anime.dart';
import 'producer.dart';

abstract class JikanResponse<T> {
  String? query;
  DateTime? date;
  DateTime? expires;
  JikanPagination? pagination;
  T? data;

  @override
  String toString() => "Response(pagination: $pagination, data: $data)";
}

class JikanAnimeResponse extends JikanResponse<List<JikanAnime>> {}

class JikanProducerResponse extends JikanResponse<List<JikanProducer>> {}
