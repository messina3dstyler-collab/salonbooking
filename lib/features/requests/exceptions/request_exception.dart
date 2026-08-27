abstract class RequestException
    implements Exception {
  const RequestException({
    required this.message,
  });

  final String message;

  @override
  String toString() {
    return message;
  }
}