import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class AnimeStatusItem with SelectionItem {
  AnimeStatus status;
  AnimeStatusItem(this.status);

  @override
  String get displayName => status.capitalize;
}

extension AnimeStatusItemText on AnimeStatus {
  String get capitalize => name[0].toUpperCase() + name.substring(1);
}
