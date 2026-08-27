import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/admin_appointment_model.dart';
import '../models/admin_service_model.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

class AdminAppointmentsRepository {
  AdminAppointmentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String,dynamic>> get _appointments =>
      _firestore.collection('appointments');

  Future<List<AdminAppointmentModel>> getAppointments(String salonId) async {
    try {
      final results = await Future.wait([
        _appointments
            .where('salonId', isEqualTo: salonId)
            .orderBy('date')
            .get(),
        _firestore.collection('users').get(),
        _firestore
            .collection('salons')
            .doc(salonId)
            .collection('employees')
            .get(),
        _firestore
            .collection('salons')
            .doc(salonId)
            .collection('services')
            .get(),
      ]);

      final appointmentsSnap = results[0];
      final usersSnap = results[1];
      final employeesSnap = results[2];
      final servicesSnap = results[3];

      final users={
        for(final d in usersSnap.docs)d.id:d.data(),
      };

      final employees={
        for(final d in employeesSnap.docs)
          d.id:EmployeeModel.fromMap(d.id,d.data()),
      };

      final services={
        for(final d in servicesSnap.docs)
          d.id:AdminServiceModel.fromMap(d.id,d.data()),
      };

      return appointmentsSnap.docs.map((doc){
        final data=Map<String,dynamic>.from(doc.data());

        final user=users[data['userId']]??{};
        final employee=employees[data['employeeId']];
        final service=services[data['serviceId']];

        data.addAll({

          // Cliente
          'customerName':user['name']??'',
          'customerPhone':user['phone']??'',
          'customerEmail':user['email']??'',

          // Dipendente
          'employeeName':employee?.name??'',
          'employeePhone':employee?.phone??'',
          'employeeSpecialization':employee?.specialization??'',
          'employeeRating':employee?.rating??0,

          // Servizio
          'serviceName':service?.name??'',
          'serviceDuration':service?.duration??0,
          'price':service?.price??0,
        });

        return AdminAppointmentModel.fromMap(doc.id,data);
      }).toList();
    } catch(e,s){
      _logError('GET APPOINTMENTS',e,s);
      rethrow;
    }
  }

  Stream<List<AdminAppointmentModel>> watchAppointments(String salonId)=>
      _appointments
          .where('salonId',isEqualTo:salonId)
          .orderBy('date')
          .snapshots()
          .asyncMap((_)=>getAppointments(salonId));
  Stream<List<AdminAppointmentModel>> watchAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) {
    return watchAppointments(salonId).map(
          (appointments) => appointments.where((appointment) {
        final d = appointment.appointmentDate;

        return d.year == date.year &&
            d.month == date.month &&
            d.day == date.day;
      }).toList(),
    );
  }

  Future<List<AdminAppointmentModel>> getAppointmentsWithDetails(
      String salonId)=>getAppointments(salonId);

  Future<List<AdminAppointmentModel>> getAppointmentsByDate({
    required String salonId,
    required DateTime date,
  }) async {
    final appointments = await getAppointments(salonId);

    return appointments.where((appointment) {
      final d = appointment.appointmentDate;

      return d.year == date.year &&
          d.month == date.month &&
          d.day == date.day;
    }).toList();
  }

  Future<void> updateStatus(
      String salonId,
      String appointmentId,
      String status,
      ) =>
      _appointments.doc(appointmentId).update({
        'status':status.trim(),
        'updatedAt':Timestamp.now(),
      });

  Future<void> updateEmployee({
    required String salonId,
    required String appointmentId,
    required String employeeId,
    required String employeeName,
    required String employeePhone,
    required String employeeSpecialization,
    required double employeeRating,
  }) =>
      _appointments.doc(appointmentId).update({
        'employeeId':employeeId,
        'employeeName':employeeName,
        'employeePhone':employeePhone,
        'employeeSpecialization':employeeSpecialization,
        'employeeRating':employeeRating,
        'updatedAt':Timestamp.now(),
      });

  Future<void> deleteAppointment(
      String salonId,
      String appointmentId,
      ) =>
      _appointments.doc(appointmentId).delete();

  void _logError(String action,Object error,StackTrace stack){
    debugPrint('$action ERROR: $error');
    debugPrintStack(stackTrace: stack);
  }
}