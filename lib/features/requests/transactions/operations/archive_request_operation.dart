import '../../models/appointment_request.dart';

import '../request_transaction_operation.dart';

class ArchiveRequestOperation extends RequestTransactionOperation {
  ArchiveRequestOperation(
      super.context,
      );

  Future<void> execute(
      AppointmentRequest request,
      ) async {
    if (!request.isClosed) {
      throw StateError(
        "Solo una richiesta in stato finale può essere archiviata.",
      );
    }

    transaction.delete(
      requestDocument(
        request.id,
      ),
    );
  }
}