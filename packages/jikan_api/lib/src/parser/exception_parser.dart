import 'parser.dart';
import '../object/exception.dart';

class ErrorParser implements Parser<JikanApiException> {
  JikanApiException parseError(Map<String, dynamic> value) {
    return JikanApiException()
      ..status = value['status']
      ..type = value['type']
      ..message = value['message']
      ..error = value['error'];
  }

  @override
  JikanApiException parse(Map<String, dynamic> value) {
    return parseError(value);
  }
}
