abstract mixin class SelectionItem {
  String get displayName;

  @override
  bool operator ==(Object other) =>
      other is SelectionItem &&
      // other.runtimeType == runtimeType &&
      other.displayName == displayName;

  @override
  int get hashCode => displayName.hashCode;
}

class SelectionWrapper<T extends SelectionItem> {
  T item;
  SelectionWrapper(this.item);

  @override
  bool operator ==(Object other) =>
      other is SelectionWrapper &&
      // other.runtimeType == runtimeType &&
      other.item == item;

  @override
  int get hashCode => item.hashCode;
}
