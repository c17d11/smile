import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/isar/collection/isar_producer.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'isar_producer_response.g.dart';

@Collection(ignore: {'data', 'pagination'})
class IsarProducerResponse extends ProducerResponseIntern {
  Id? id;

  @Index(unique: true, replace: true)
  String q;

  final isarProducers = IsarLinks<IsarProducer>();

  IsarProducerResponse({required this.q});

  static String createQueryString(ProducerQuery q) {
    List<String> queries = [
      "${q.searchTerm}",
      "${q.page}",
    ];
    String query = queries.join("-");
    return query;
  }

  static IsarProducerResponse from(ProducerResponse res, ProducerQuery query) {
    String q = createQueryString(query);
    IsarProducerResponse isarRes = IsarProducerResponse(q: q)
      ..date = res.date
      ..expires = res.expires
      ..pagination = res.pagination
      ..data = res.data?.map((e) => IsarProducer.from(e)).toList();
    return isarRes;
  }
}
