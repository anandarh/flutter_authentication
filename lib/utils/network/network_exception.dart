class NetworkException implements Exception {
  String message;
  int statusCode;

  NetworkException({this.message, this.statusCode});

  @override
  String toString() {
    return 'NetworkException{message: $message, statusCode: $statusCode}';
  }
}