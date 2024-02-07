import 'package:app/object/pagination.dart';
import 'package:app/object/producer.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerResponse {
  String? query;
  DateTime? timestamp;
  // DateTime? expires;
  Pagination? pagination;
  List<Producer>? producers;

  ProducerResponse();

  ProducerResponse.from(JikanProducerResponse res) {
    query = res.query;
    // date = res.date;
    // expires = res.expires;
    pagination = Pagination.from(res.pagination!);
    producers = res.data?.map((e) => Producer.from(e)).toList();
  }
}
