import 'package:app/database/src/isar/common/expiration.dart';
import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarProducerResponse with IsarExpiration {
  Id? id;

  @Index(unique: true, replace: true)
  String q;

  DateTime? date;
  DateTime? expires;

  int? lastVisiblePage;
  bool? hasNextPage;
  int? currentPage;
  int? itemCount;
  int? itemTotal;
  int? itemPerPage;

  List<int>? producerIds;

  IsarProducerResponse({required this.q}) {
    storedAt = DateTime.now();
  }
}
