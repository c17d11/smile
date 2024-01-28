class CollectionQueryIntern {
  String? collectionName;
  int? page;

  CollectionQueryIntern copyWith({String? collectionName, int? page}) {
    return CollectionQueryIntern()
      ..collectionName = collectionName ?? this.collectionName
      ..page = page ?? this.page;
  }
}
