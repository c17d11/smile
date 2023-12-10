import 'package:app/controller/src/object/producer_response_intern.dart';
import 'package:app/database/src/isar/collection/isar_anime_response.dart';
import 'package:app/database/src/isar/collection/isar_producer_response.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/database/src/isar/model/producer_model.dart';
import 'package:app/database/src/model.dart';
import 'package:isar/isar.dart';
import 'package:jikan_api/jikan_api.dart';

class IsarProducerResponseModel extends IsarModel
    implements ProducerResponseModel {
  final IsarProducerModel _producerModel;

  IsarProducerResponseModel(super.db, {required super.expirationHours})
      : _producerModel =
            IsarProducerModel(db, expirationHours: expirationHours);

  @override
  Future<void> insertProducerResponse(ProducerResponseIntern arg) async {
    IsarProducerResponse res = arg as IsarProducerResponse;
    res.isarPagination = IsarPagination.from(res.pagination);

    await write(() async {
      final isarProducers =
          await _producerModel.insertProducersInTxn(res.data ?? []);
      res.isarProducers.clear();
      res.isarProducers.addAll(isarProducers);
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

    res?.data =
        _producerModel.getProducersFromIsar(res?.isarProducers.toList() ?? []);
    res?.pagination = res?.isarPagination;
    return res;
  }

  @override
  Future<bool> deleteProducerResponse(ProducerQuery query) async {
    // bool success = false;
    // await write(() async {
    //   success = await db.isarProducerResponses.deleteByIndex("q", [isarQuery]);
    // });

    // return success;
    return false;
  }

  @override
  ProducerResponseIntern createProducerResponseIntern(ProducerResponse res) {
    return IsarProducerResponse.from(res);
  }
}
