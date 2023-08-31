import 'parser.dart';
import '../object/exception.dart';
import '../object/pagination.dart';

class PaginationParser implements Parser<Pagination> {
  Pagination parsePagination(Map<String, dynamic> value) {
    return Pagination()
      ..lastVisiblePage = value['last_visible_page']
      ..hasNextPage = value['has_next_page']
      ..currentPage = value['current_page']
      ..itemCount = value['items']?['count']
      ..itemTotal = value['items']?['total']
      ..itemPerPage = value['items']?['per_page'];
  }

  @override
  Pagination parse(Map<String, dynamic> value) {
    if (!value.containsKey("pagination")) {
      throw JikanParseException();
    }
    return parsePagination(value['pagination']);
  }
}
