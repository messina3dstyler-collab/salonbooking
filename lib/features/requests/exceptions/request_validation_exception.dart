import 'request_exception.dart';

class RequestValidationException
    extends RequestException {
  const RequestValidationException(
      String message,
      ) : super(
    message: message,
  );
}