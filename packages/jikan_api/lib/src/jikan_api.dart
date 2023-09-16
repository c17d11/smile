import 'package:dio/dio.dart';
import 'package:jikan_api/src/jikan_api_base.dart';
import 'http/dio_wrapper.dart';

class JikanApi extends JikanApiBase {
  JikanApi() : super(DioWrapper(Dio()));
}

// class JikanApiMock extends JikanApiBase {
//   JikanApiMock()
//       : super(DioWrapper(Dio()..interceptors.add(MockInterceptor())));
// }
