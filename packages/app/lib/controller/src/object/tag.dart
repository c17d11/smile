import 'package:app/ui/selection_widget/src/selection_item.dart';

class Tag with SelectionItem {
  final String name;
  final int animeCount;

  const Tag(this.name, this.animeCount);

  @override
  String get displayName => name;
}
