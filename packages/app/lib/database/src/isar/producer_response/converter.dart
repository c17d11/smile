import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/producer_response/collection.dart';
import 'package:app/object/pagination.dart';
import 'package:app/object/producer_response.dart';

class IsarProducerResponseConverter
    extends Converter<ProducerResponse, IsarProducerResponse> {
  @override
  ProducerResponse fromImpl(IsarProducerResponse t) {
    return ProducerResponse()
      ..query = t.q
      ..date = t.date
      ..expires = t.expires
      ..pagination = (Pagination()
        ..lastVisiblePage = t.lastVisiblePage
        ..hasNextPage = t.hasNextPage
        ..currentPage = t.currentPage
        ..itemCount = t.itemCount
        ..itemTotal = t.itemTotal
        ..itemPerPage = t.itemPerPage)
      ..producers = [];
  }

  @override
  IsarProducerResponse toImpl(ProducerResponse t) {
    return IsarProducerResponse(q: t.query!)
      ..date = t.date
      ..expires = t.expires
      ..producerIds = []
      ..lastVisiblePage = t.pagination?.lastVisiblePage
      ..hasNextPage = t.pagination?.hasNextPage
      ..currentPage = t.pagination?.currentPage
      ..itemCount = t.pagination?.itemCount
      ..itemTotal = t.pagination?.itemTotal
      ..itemPerPage = t.pagination?.itemPerPage;
  }
}
