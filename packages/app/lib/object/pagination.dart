import 'package:jikan_api/jikan_api.dart';

class Pagination extends JikanPagination {
  Pagination();

  Pagination.from(JikanPagination pagination) {
    lastVisiblePage = pagination.lastVisiblePage;
    hasNextPage = pagination.hasNextPage;
    currentPage = pagination.currentPage;
    itemCount = pagination.itemCount;
    itemTotal = pagination.itemTotal;
    itemPerPage = pagination.itemPerPage;
  }
}
