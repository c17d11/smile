import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarProducerResponse {
  Id? id;

  @Index(unique: true, replace: true)
  String q;

  late DateTime timestamp;

  int? lastVisiblePage;
  bool? hasNextPage;
  int? currentPage;
  int? itemCount;
  int? itemTotal;
  int? itemPerPage;

  List<int>? producerIds;

  IsarProducerResponse({required this.q}) {
    timestamp = DateTime.now();
  }
}
