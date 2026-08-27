import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:salon_booking/features/employee/models/employee_model.dart';

class EmployeeRepository {
  EmployeeRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _employeesCollection(
      String salonId,
      ) {
    return _firestore
        .collection('salons')
        .doc(salonId)
        .collection('employees');
  }

  // =====================================================
  // GET DIPENDENTI ATTIVI
  // =====================================================

  Future<List<EmployeeModel>> getEmployees(
      String salonId,
      ) async {
    try {
      debugPrint('========================================');
      debugPrint('CARICO DIPENDENTI ATTIVI: $salonId');
      debugPrint('========================================');

      final snapshot = await _employeesCollection(
        salonId,
      ).where(
        'active',
        isEqualTo: true,
      ).get();

      debugPrint(
        'Dipendenti attivi trovati: ${snapshot.docs.length}',
      );

      for (final doc in snapshot.docs) {
        debugPrint(
          '${doc.id} -> ${doc.data()}',
        );
      }

      return snapshot.docs
          .map(
            (doc) => EmployeeModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    } catch (e, stack) {
      debugPrint(
        'ERRORE CARICAMENTO DIPENDENTI: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      rethrow;
    }
  }

  // =====================================================
  // GET TUTTI I DIPENDENTI
  // =====================================================

  Future<List<EmployeeModel>> getAllEmployees(
      String salonId,
      ) async {
    try {
      debugPrint('========================================');
      debugPrint('CARICO TUTTI DIPENDENTI: $salonId');
      debugPrint('========================================');

      final snapshot = await _employeesCollection(
        salonId,
      ).get();

      debugPrint(
        'Dipendenti trovati: ${snapshot.docs.length}',
      );

      for (final d in snapshot.docs) {
        debugPrint(
          '${d.id} -> ${d.data()}',
        );
      }

      return snapshot.docs
          .map(
            (doc) => EmployeeModel.fromMap(
          doc.id,
          doc.data(),
        ),
      )
          .toList();
    } catch (e, stack) {
      debugPrint(
        'ERRORE CARICAMENTO TUTTI DIPENDENTI: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      rethrow;
    }
  }

  // =====================================================
  // CREA DIPENDENTE
  // =====================================================

  Future<String> createEmployee(
      String salonId,
      EmployeeModel employee,
      ) async {
    try {
      debugPrint(
        'CREO DIPENDENTE: ${employee.name}',
      );

      final doc = await _employeesCollection(
        salonId,
      ).add(
        {
          ...employee.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      return doc.id;
    } catch (e, stack) {
      debugPrint(
        'ERRORE CREAZIONE DIPENDENTE: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      rethrow;
    }
  }

  // =====================================================
  // AGGIORNA DIPENDENTE
  // =====================================================

  Future<void> updateEmployee(
      String salonId,
      String employeeId,
      Map<String, dynamic> data,
      ) async {
    try {
      await _employeesCollection(
        salonId,
      ).doc(
        employeeId,
      ).update(
        {
          ...data,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e, stack) {
      debugPrint(
        'ERRORE AGGIORNAMENTO DIPENDENTE: $e',
      );

      debugPrintStack(
        stackTrace: stack,
      );

      rethrow;
    }
  }

  // =====================================================
  // DISATTIVA DIPENDENTE
  // =====================================================

  Future<void> deleteEmployee(
      String salonId,
      String employeeId,
      ) async {
    await updateEmployee(
      salonId,
      employeeId,
      {
        'active': false,
      },
    );
  }

  // =====================================================
  // RIATTIVA DIPENDENTE
  // =====================================================

  Future<void> restoreEmployee(
      String salonId,
      String employeeId,
      ) async {
    await updateEmployee(
      salonId,
      employeeId,
      {
        'active': true,
      },
    );
  }
}