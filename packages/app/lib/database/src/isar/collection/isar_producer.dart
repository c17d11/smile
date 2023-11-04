import 'package:app/controller/state.dart';
import 'package:app/database/src/isar/collection/isar_expiration.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

part 'isar_producer.g.dart';

@Collection()
class IsarProducer extends ProducerIntern with IsarExpiration {
  @Index(unique: true, replace: true)
  Id id;

  IsarProducer({required this.id}) {
    storedAt = DateTime.now();
  }

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
