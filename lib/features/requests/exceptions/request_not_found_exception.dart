import 'request_exception.dart';

class RequestNotFoundException
    extends RequestException {
  const RequestNotFoundException(
      String message,
      ) : super(
    message: message,
  );
}