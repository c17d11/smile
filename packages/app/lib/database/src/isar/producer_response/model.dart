import 'package:app/database/src/interface/model.dart';
import 'package:app/database/src/isar/producer/model.dart';
import 'package:app/database/src/isar/producer_response/collection.dart';
import 'package:app/database/src/isar/producer_response/converter.dart';
import 'package:app/database/src/isar/model.dart';
import 'package:app/object/producer.dart';
import 'package:app/object/producer_response.dart';
import 'package:isar/isar.dart';

class IsarProducerResponseModel extends IsarModel
    implements ProducerResponseModel {
  final IsarProducerResponseConverter _producerResponseConverter =
      IsarProducerResponseConverter();
  final IsarProducerModel _producerModel;
  IsarProducerResponseModel(super.db) : _producerModel = IsarProducerModel(db);

  Future<ProducerResponse?> get(String id) async {
    IsarProducerResponse? ret =
        await db.isarProducerResponses.where().qEqualTo(id).findFirst();

    if (ret == null) return null;

    ProducerResponse r = _producerResponseConverter.fromImpl(ret);
    for (int producerId in ret.producerIds ?? []) {
      Producer? p = await _producerModel.get(producerId);
      if (p != null) r.producers!.add(p);
    }
    return r;
  }

  Future<int> insert(ProducerResponse responseIn) async {
    IsarProducerResponse responseImpl =
        _producerResponseConverter.toImpl(responseIn);
    for (var producer in responseIn.producers ?? []) {
      int id = await _producerModel.insert(producer);
      responseImpl.producerIds!.add(id);
    }
    int id = await db.isarProducerResponses.put(responseImpl);
    return id;
  }

  @override
  Future<ProducerResponse?> getProducerResponse(String query) async {
    return await get(query);
  }

  @override
  Future<void> insertProducerResponse(ProducerResponse res) async {
    await insert(res);
  }
}
