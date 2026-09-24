import '../models/appointment_request.dart';
import '../models/request_timeline_event.dart';

abstract class AppointmentRequestDatasource {
  Future<void> create(AppointmentRequest request);

  Future<void> update(AppointmentRequest request);

  Future<void> delete(String requestId);

  Future<AppointmentRequest?> getById(String requestId);

  Future<void> addTimelineEvent(
      RequestTimelineEvent event,
      );

  Future<List<RequestTimelineEvent>> getTimeline(
      String requestId,
      );

  Stream<List<AppointmentRequest>> watchAppointmentRequests(
      String appointmentId,
      );

  Stream<List<AppointmentRequest>> watchCustomerRequests(
      String customerId,
      );

  Stream<List<AppointmentRequest>> watchSalonRequests(
      String salonId,
      );

  Stream<List<AppointmentRequest>> watchPendingRequests(
      String salonId,
      );

  Stream<List<AppointmentRequest>> watchPendingSalonRequests(
      String salonId,
      );
}