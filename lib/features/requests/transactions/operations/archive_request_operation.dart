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

    if (request.isArchived) {
      throw StateError(
        "La richiesta è già stata archiviata.",
      );
    }

    transaction.update(
      requestDocument(
        request.id,
      ),
      {
        "isArchived": true,
        "archivedAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      },
    );
  }
}