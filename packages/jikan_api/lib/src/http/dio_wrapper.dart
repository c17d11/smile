import 'dart:io';

import 'package:dio/dio.dart';
import 'http.dart';
import 'http_result.dart';

class DioWrapper implements Http {
  Dio dio;

  DioWrapper(this.dio);

  Map<String, dynamic> getHeaders(Headers headers) {
    Map<String, dynamic> ret = {};
    headers.forEach((name, values) {
      ret[name] = values;
    });
    return ret;
  }

  @override
  Future<HttpResult> get(String url) async {
    HttpResult ret = HttpResult();
    try {
      Response res = await dio.get(url);
      ret.data = res.data;

      Map<String, dynamic> headers = getHeaders(res.headers);
      ret.headers = headers;

      String? date = headers['date']?[0];
      if (date != null) {
        DateTime dt = HttpDate.parse(date);
        ret.date = dt;
      }
    } on DioException catch (e) {
      ret.error = e.response?.data;
    }
    return ret;
  }
}
