import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:jikan_api/src/jikan_api_facade.dart';
import 'http/dio_wrapper.dart';

class JikanApiImpl extends JikanApi {
  JikanApiImpl() : super(DioWrapper(Dio()));
}

class JikanApiMockImpl extends JikanApi {
  JikanApiMockImpl()
      : super(DioWrapper(Dio()..interceptors.add(MockInterceptor())));
}

class MockInterceptor implements Interceptor {
  static const _jsonDir = 'packages/jikan_api/assets/json/';
  static const _jsonExtension = '.json';

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // final resourcePath = _jsonDir + options.path + _jsonExtension;
    final resourcePath = _jsonDir + 'anime3' + _jsonExtension;
    final data = await rootBundle.load(resourcePath);
    final map = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );

    handler.resolve(Response(
      data: map,
      statusCode: 200,
      requestOptions: options,
    ));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
  }
}
