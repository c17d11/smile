class CollectionQuery {
  String? collectionName;
  int? page;

  CollectionQuery copyWith({String? collectionName, int? page}) {
    return CollectionQuery()
      ..collectionName = collectionName ?? this.collectionName
      ..page = page ?? this.page;
  }
}
