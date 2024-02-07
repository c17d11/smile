import 'package:app/database/src/interface/converter.dart';
import 'package:app/database/src/isar/producer/collection.dart';
import 'package:app/object/producer.dart';

class IsarProducerConverter extends Converter<Producer, IsarProducer> {
  @override
  Producer fromImpl(IsarProducer t) {
    return Producer()
      ..malId = t.id
      ..title = t.title
      ..established = t.established
      ..about = t.about
      ..count = t.count
      ..imageUrl = t.imageUrl;
  }

  @override
  IsarProducer toImpl(Producer t) {
    return IsarProducer(id: t.malId!)
      ..title = t.title
      ..established = t.established
      ..about = t.about
      ..count = t.count
      ..imageUrl = t.imageUrl;
  }
}
