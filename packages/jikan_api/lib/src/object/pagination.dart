class Pagination {
  int? lastVisiblePage;
  bool? hasNextPage;
  int? currentPage;
  int? itemCount;
  int? itemTotal;
  int? itemPerPage;

  @override
  String toString() => "Pagination("
      "lastVisiblePage: $lastVisiblePage, "
      "hasNextPage: $hasNextPage, "
      "currentPage: $currentPage, "
      "itemCount: $itemCount, "
      "itemTotal: $itemTotal, "
      "itemPerPage: $itemPerPage"
      ")";
}
