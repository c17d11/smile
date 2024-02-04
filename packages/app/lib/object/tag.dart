import 'package:app/ui/selection_widget/src/selection_item.dart';

class Tag with SelectionItem {
  String? name;
  int? animeCount;

  @override
  String get displayName => name ?? '';
}
