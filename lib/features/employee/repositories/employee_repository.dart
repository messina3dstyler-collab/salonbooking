import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';

class EmployeeRepository {
  EmployeeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _employees(
      String salonId,
      ) =>
      _firestore
          .collection('salons')
          .doc(salonId)
          .collection('employees');

  Future<List<EmployeeModel>> getEmployees(
      String salonId,
      ) async {
    final snapshot = await _employees(salonId)
        .where('active', isEqualTo: true)
        .orderBy('name')
        .get();

    return snapshot.docs
        .map(
          (doc) => EmployeeModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  Future<EmployeeModel?> getEmployee({
    required String salonId,
    required String employeeId,
  }) async {
    final doc = await _employees(salonId)
        .doc(employeeId)
        .get();

    if (!doc.exists) return null;

    return EmployeeModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  Future<void> updateEmployee(
      EmployeeModel employee,
      ) async {
    await _employees(employee.salonId)
        .doc(employee.id)
        .set(
      employee.toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> updateEmployeeRating({
    required String salonId,
    required String employeeId,
    required double rating,
    required int reviewCount,
  }) async {
    await _employees(salonId)
        .doc(employeeId)
        .set(
      {
        'rating': rating,
        'reviewCount': reviewCount,
        'updatedAt': Timestamp.now(),
      },
      SetOptions(merge: true),
    );
  }
}