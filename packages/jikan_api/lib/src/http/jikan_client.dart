import 'http.dart';
import 'http_result.dart';
import 'package:rate_manager/rate_manager.dart';

class PrimaryHttpClient implements Http {
  final RateManger _manager;
  final Http _httpClient;
  PrimaryHttpClient(this._httpClient, this._manager);

  @override
  Future<HttpResult> get(String url) async {
    late dynamic ret;
    await _manager.primaryCall(() async => ret = await _httpClient.get(url));
    return ret;
  }
}

class SecondaryHttpClient implements Http {
  final RateManger _manager;
  final Http _httpClient;
  SecondaryHttpClient(this._httpClient, this._manager);

  @override
  Future<HttpResult> get(String url) async {
    late dynamic ret;
    await _manager.secondaryCall(() async => ret = await _httpClient.get(url));
    return ret;
  }
}
