class CollectionQueryIntern {
  String? collectionName;
  int? page;

  static CollectionQueryIntern copy(CollectionQueryIntern query) {
    CollectionQueryIntern c = CollectionQueryIntern();
    c.collectionName = query.collectionName;
    c.page = query.page;
    return c;
  }
}
