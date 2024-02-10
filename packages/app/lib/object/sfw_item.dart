import 'package:app/ui/common/selection_item.dart';

class SfwItem with SelectionItem {
  bool sfw;
  SfwItem(this.sfw);

  @override
  String get displayName => sfw ? "True" : "False";
}
