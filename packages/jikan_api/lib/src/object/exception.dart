class JikanParseException implements Exception {}

class JikanTimeoutException implements Exception {}

class JikanApiException implements Exception {
  String? status;
  String? type;
  String? message;
  String? error;
}
