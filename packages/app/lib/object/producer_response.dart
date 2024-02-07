import 'package:app/object/expiration.dart';
import 'package:app/object/pagination.dart';
import 'package:app/object/producer.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerResponse extends Expiration {
  String? query;
  Pagination? pagination;
  List<Producer>? producers;

  ProducerResponse();

  ProducerResponse.from(JikanProducerResponse res) {
    query = res.query;
    pagination = Pagination.from(res.pagination!);
    producers = res.data?.map((e) => Producer.from(e)).toList();
  }
}
