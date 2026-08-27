import 'request_exception.dart';

class RequestWorkflowException
    extends RequestException {
  const RequestWorkflowException(
      String message,
      ) : super(
    message: message,
  );
}