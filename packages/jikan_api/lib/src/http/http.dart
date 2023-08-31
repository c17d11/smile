import 'http_result.dart';

abstract class Http {
  Future<HttpResult> get(String url);
}
