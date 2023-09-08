import 'http_result.dart';

abstract interface class Http {
  Future<HttpResult> get(String url);
}
