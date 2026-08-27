import 'request_exception.dart';

class RequestConflictException
    extends RequestException {
  const RequestConflictException(
      String message,
      ) : super(
    message: message,
  );
}