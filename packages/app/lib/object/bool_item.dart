import 'package:app/ui/common/selection_item.dart';

class BoolItem with SelectionItem {
  bool value;
  BoolItem(this.value);

  @override
  String get displayName => value ? "True" : "False";
}
