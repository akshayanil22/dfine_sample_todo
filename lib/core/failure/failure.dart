abstract class Failure {
  Failure({required this.message, required this.statusCode});
  final String message;
  final dynamic statusCode;
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.statusCode});
}
