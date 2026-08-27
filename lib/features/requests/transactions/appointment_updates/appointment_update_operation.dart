import '../../models/appointment_request.dart';
import '../request_transaction_context.dart';

abstract class AppointmentUpdateOperation {
  const AppointmentUpdateOperation(
      this.context,
      );

  final RequestTransactionContext context;

  Future<void> execute(
      AppointmentRequest request,
      );
}