import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:salon_booking/features/admin/helpers/next_appointment_builder.dart';
import 'package:salon_booking/features/admin/helpers/revenue_builder.dart';
import 'package:salon_booking/features/admin/helpers/team_status_builder.dart';
import 'package:salon_booking/features/admin/helpers/today_tasks_builder.dart';
import 'package:salon_booking/features/admin/models/employee_status.dart';
import 'package:salon_booking/features/appointment/models/appointment_model.dart';
import 'package:salon_booking/features/employee/models/employee_model.dart';

void main() {
  final referenceTime = DateTime(2026, 8, 27, 9);

  group('RevenueBuilder', () {
    test('calcola incasso previsto e incassato escludendo gli annullati', () {
      final revenue = const RevenueBuilder().build([
        _appointment(
          id: 'pending',
          date: referenceTime.add(const Duration(hours: 1)),
          status: 'Prenotata',
          price: 20,
        ),
        _appointment(
          id: 'completed',
          date: referenceTime.add(const Duration(hours: 2)),
          status: 'Completata',
          price: 30,
        ),
        _appointment(
          id: 'cancelled',
          date: referenceTime.add(const Duration(hours: 3)),
          status: 'Annullata',
          price: 40,
        ),
      ]);

      expect(revenue.expectedRevenue, 50.0);
      expect(revenue.today, 50.0);
      expect(revenue.collectedRevenue, 0.0);
    });
  });

  group('NextAppointmentBuilder', () {
    test('restituisce il primo appuntamento futuro non annullato', () {
      final nextAppointment = const NextAppointmentBuilder().build(
        [
          _appointment(
            id: 'later',
            date: referenceTime.add(const Duration(hours: 2)),
          ),
          _appointment(
            id: 'cancelled',
            date: referenceTime.add(const Duration(minutes: 30)),
            status: 'Annullata',
          ),
          _appointment(
            id: 'next',
            date: referenceTime.add(const Duration(hours: 1)),
            customerName: 'Giulia Rossi',
            serviceName: 'Taglio',
            employeeName: 'Anna',
          ),
          _appointment(
            id: 'past',
            date: referenceTime.subtract(const Duration(minutes: 30)),
          ),
        ],
        now: referenceTime,
      );

      expect(nextAppointment.id, 'next');
      expect(nextAppointment.customer, 'Giulia Rossi');
      expect(nextAppointment.time, '10:00');
      expect(nextAppointment.countdown, 'Tra 60 min');
    });

    test('restituisce un modello vuoto senza appuntamenti futuri', () {
      final nextAppointment = const NextAppointmentBuilder().build(
        [
          _appointment(
            id: 'past',
            date: referenceTime.subtract(const Duration(hours: 1)),
          ),
        ],
        now: referenceTime,
      );

      expect(nextAppointment.isEmpty, isTrue);
    });
  });

  group('TodayTasksBuilder', () {
    test('conta conferme e pagamenti mancanti', () {
      final tasks = const TodayTasksBuilder().build([
        _appointment(
          id: 'pending',
          date: referenceTime,
          status: 'Prenotata',
        ),
        _appointment(
          id: 'completed-paid',
          date: referenceTime,
          status: 'Completata',
          price: 25,
        ),
        _appointment(
          id: 'completed-free',
          date: referenceTime,
          status: 'Completata',
          price: 0,
        ),
      ]);

      expect(tasks.unconfirmedAppointments, 1);
      expect(tasks.missingPayments, 1);
    });
  });

  group('TeamStatusBuilder', () {
    test('assegna correttamente gli stati dei dipendenti', () {
      final team = const TeamStatusBuilder().build(
        employees: [
          _employee(id: 'anna', name: 'Anna'),
          _employee(id: 'marta', name: 'Marta'),
          _employee(
            id: 'lisa',
            name: 'Lisa',
            active: false,
          ),
        ],
        appointments: [
          _appointment(
            id: 'current',
            date: DateTime(2026, 8, 27, 8, 30),
            duration: 90,
            employeeId: 'anna',
            customerName: 'Giulia Rossi',
            serviceName: 'Colore',
          ),
          _appointment(
            id: 'next',
            date: DateTime(2026, 8, 27, 11),
            duration: 60,
            employeeId: 'marta',
            serviceName: 'Piega',
          ),
        ],
        now: DateTime(2026, 8, 27, 9),
      );

      final anna = team.firstWhere((member) => member.id == 'anna');
      final marta = team.firstWhere((member) => member.id == 'marta');
      final lisa = team.firstWhere((member) => member.id == 'lisa');

      expect(anna.status, EmployeeStatus.busy);
      expect(anna.currentCustomer, 'Giulia Rossi');
      expect(anna.subtitle, 'Colore');

      expect(marta.status, EmployeeStatus.available);
      expect(marta.nextAppointmentTime, '11:00');

      expect(lisa.status, EmployeeStatus.offline);
    });
  });
}

AppointmentModel _appointment({
  required String id,
  required DateTime date,
  String status = 'Prenotata',
  String employeeId = 'employee-1',
  String customerName = 'Cliente',
  String employeeName = 'Dipendente',
  String serviceName = 'Servizio',
  double price = 20,
  int duration = 60,
}) {
  final timestamp = Timestamp.fromDate(date);

  return AppointmentModel(
    id: id,
    userId: 'user-$id',
    salonId: 'salon-1',
    employeeId: employeeId,
    serviceId: 'service-1',
    date: timestamp,
    status: status,
    createdAt: timestamp,
    updatedAt: timestamp,
    duration: duration,
    customerName: customerName,
    employeeName: employeeName,
    serviceName: serviceName,
    price: price,
  );
}

EmployeeModel _employee({
  required String id,
  required String name,
  bool active = true,
}) {
  return EmployeeModel(
    id: id,
    salonId: 'salon-1',
    name: name,
    photoUrl: '',
    phone: '',
    active: active,
    rating: 0,
    reviewCount: 0,
    specialization: '',
    workingDays: const [1, 2, 3, 4, 5],
    startHour: 9,
    endHour: 18,
    breakStart: 780,
    breakEnd: 840,
  );
}