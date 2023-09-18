import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:jikan_api/src/jikan_api_facade.dart';
import 'http/dio_wrapper.dart';

String _jikanBaseUrl = 'https://api.jikan.moe/v4/';

class JikanApiImpl extends JikanApi {
  JikanApiImpl()
      : super(
          DioWrapper(Dio(BaseOptions(baseUrl: _jikanBaseUrl))),
        );
}

class JikanApiMockImpl extends JikanApi {
  JikanApiMockImpl()
      : super(
          DioWrapper(Dio(BaseOptions(baseUrl: _jikanBaseUrl))
            ..interceptors.add(MockInterceptor())),
        );
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
    final pathUnderscope = options.path.replaceAll('/', '_');
    final resourcePath = _jsonDir + pathUnderscope + _jsonExtension;
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
