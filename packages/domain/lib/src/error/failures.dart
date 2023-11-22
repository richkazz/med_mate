import 'package:domain/src/error/error_message.dart';

abstract class Failure implements Exception {}
 class AuthenticationException implements Exception {}

// General failures
class ServerFailure extends Failure {}

class NetWorkFailure extends Failure {}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return ErrorMessagesConstants.serverFailureMessage;
    case NetWorkFailure:
      return ErrorMessagesConstants.networkFailureMessage;
    default:
      return 'Unexpected error';
  }
}

class CacheFailure extends Failure {}
