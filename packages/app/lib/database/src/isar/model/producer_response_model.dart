import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/isar/collection/isar_producer.dart';
import 'package:app/database/src/isar/collection/isar_producer_response.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarProducerResponseModel extends IsarModel
    implements ProducerResponseModel {
  IsarProducerResponseModel(super.db, {required super.expirationHours});

  @override
  Future<void> insertProducerResponse(ProducerResponseIntern arg) async {
    IsarProducerResponse res = arg as IsarProducerResponse;

    List<IsarProducer> producers =
        res.data?.map((e) => IsarProducer.from(e)).toList() ?? [];
    await write(() async {
      if (producers.isNotEmpty) {
        await db.isarProducers.putAll(producers);
        res.isarProducers.addAll(producers);
      }
      await db.isarProducerResponses.put(res);
      await res.isarProducers.save();
    });
  }

  @override
  Future<ProducerResponseIntern?> getProducerResponse(String query) async {
    IsarProducerResponse? res;
    await read(() async {
      res = await db.isarProducerResponses.where().qEqualTo(query).findFirst();
    });
    if (isExpired(res)) return null;
    res?.data = res?.isarProducers.toList();
    return res;
  }

  @override
  Future<bool> deleteProducerResponse(ProducerQuery query) async {
    String isarQuery = IsarProducerResponse.createQueryString(query);

    bool success = false;
    await write(() async {
      success = await db.isarProducerResponses.deleteByIndex("q", [isarQuery]);
    });

    return success;
  }

  @override
  ProducerResponseIntern createProducerResponseIntern(ProducerResponse res) {
    return IsarProducerResponse.from(res);
  }
}
