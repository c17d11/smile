import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:state/state.dart';

part 'isar_producer.g.dart';

@Collection()
class IsarProducer extends ProducerIntern {
  @Index(unique: true, replace: true)
  Id id;
  IsarProducer({required this.id});

  static IsarProducer from(Producer p) {
    IsarProducer producerIntern = IsarProducer(id: p.malId!)
      ..malId = p.malId
      ..title = p.title
      ..established = p.established
      ..about = p.about
      ..count = p.count
      ..imageUrl = p.imageUrl;
    return producerIntern;
  }
}
