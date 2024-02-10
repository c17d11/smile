import 'package:app/ui/common/selection_item.dart';
import 'package:jikan_api/jikan_api.dart';

class Producer extends JikanProducer with SelectionItem {
  @override
  String get displayName => title ?? '';

  Producer();

  Producer.from(JikanProducer p) {
    malId = p.malId;
    title = p.title;
    established = p.established;
    about = p.about;
    count = p.count;
    imageUrl = p.imageUrl;
  }

  JikanProducer toJikan() {
    return JikanProducer()
      ..malId = malId
      ..title = title
      ..established = established
      ..about = about
      ..count = count
      ..imageUrl = imageUrl;
  }
}
