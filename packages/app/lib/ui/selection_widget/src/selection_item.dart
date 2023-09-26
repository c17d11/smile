abstract mixin class SelectionItem {
  String get displayName;

  @override
  bool operator ==(Object other) =>
      other is SelectionItem && other.displayName == displayName;

  @override
  int get hashCode => displayName.hashCode;
}
