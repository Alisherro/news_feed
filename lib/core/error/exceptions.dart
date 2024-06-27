class ServerException implements Exception {
  final String? message;

 const ServerException([this.message]);
}

class CacheException implements Exception {
  final String? message;

  const CacheException([this.message]);
}

class FormatException implements Exception {
  final String? message;

  const FormatException([this.message]);
}


class UnauthenticatedException implements Exception {
  final String? message;

  const UnauthenticatedException([this.message]);
}
