import 'pagination.dart';
import 'anime.dart';
import 'producer.dart';

abstract class Response<T> {
  DateTime? date;
  DateTime? expires;
  Pagination? pagination;
  T? data;

  @override
  String toString() => "Response(pagination: $pagination, data: $data)";
}

class AnimeResponse extends Response<List<Anime>> {}

class ProducerResponse extends Response<List<Producer>> {}
