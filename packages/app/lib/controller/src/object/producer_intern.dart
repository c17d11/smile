import 'package:app/ui/selection_widget/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class ProducerIntern extends Producer with SelectionItem {
  @override
  String get displayName => title ?? '';

  static ProducerIntern from(Producer p) {
    ProducerIntern producerIntern = ProducerIntern()
      ..malId = p.malId
      ..title = p.title
      ..established = p.established
      ..about = p.about
      ..count = p.count
      ..imageUrl = p.imageUrl;
    return producerIntern;
  }
}
