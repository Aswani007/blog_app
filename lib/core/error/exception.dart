//getting exception from the server error
class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}
