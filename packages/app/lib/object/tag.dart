import 'package:app/ui/common/selection_item.dart';

class Tag with SelectionItem {
  String? name;
  int? animeCount;

  @override
  String get displayName => name ?? '';
}
