import 'package:app/database/src/isar/common/expiration.dart';
import 'package:isar/isar.dart';

part 'collection.g.dart';

@Collection()
class IsarAnimeResponse with IsarExpiration {
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

  List<int>? animeIds;

  IsarAnimeResponse({required this.q}) {
    storedAt = DateTime.now();
  }
}
