import 'package:app/controller/state.dart';
import 'package:app/object/pagination.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerResponse {
  String? query;
  DateTime? date;
  DateTime? expires;
  Pagination? pagination;
  List<Producer>? producers;

  ProducerResponse();

  ProducerResponse.from(JikanProducerResponse res) {
    query = res.query;
    date = res.date;
    expires = res.expires;
    pagination = Pagination.from(res.pagination!);
    producers = res.data?.map((e) => Producer.from(e)).toList();
  }
}
