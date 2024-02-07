import 'package:app/ui/selection_widget/src/selection_item.dart';

typedef WrapperList = List<SelectionWrapper<SelectionItem>>;
typedef SelectionList = List<SelectionItem>;
typedef Wrapper = SelectionWrapper<SelectionItem>;

class SelectionWrapper<T extends SelectionItem> {
  T item;
  SelectionWrapper(this.item);

  @override
  bool operator ==(Object other) =>
      other is SelectionWrapper && other.item == item;

  @override
  int get hashCode => item.hashCode;
}
