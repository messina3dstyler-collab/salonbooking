import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_service_model.dart';

class AdminServicesRepository {
  AdminServicesRepository(
      this._firestore,
      );

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>>
  _servicesCollection(
      String salonId,
      ) {
    return _firestore
        .collection('salons')
        .doc(salonId)
        .collection('services');
  }

  // =====================================================
  // GET SERVIZI ATTIVI
  // =====================================================

  Future<List<AdminServiceModel>> getServices(
      String salonId,
      ) async {
    final snapshot = await _servicesCollection(
      salonId,
    ).get();

    final services = snapshot.docs
        .map(
          (doc) => AdminServiceModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .where(
          (service) => service.active,
    )
        .toList();

    services.sort(
          (a, b) => a.name.compareTo(
        b.name,
      ),
    );

    return services;
  }

  // =====================================================
  // GET TUTTI I SERVIZI
  // =====================================================

  Future<List<AdminServiceModel>> getAllServices(
      String salonId,
      ) async {
    final snapshot = await _servicesCollection(
      salonId,
    ).get();

    final services = snapshot.docs
        .map(
          (doc) => AdminServiceModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();

    services.sort(
          (a, b) => a.name.compareTo(
        b.name,
      ),
    );

    return services;
  }

  // =====================================================
  // GET PER CATEGORIA
  // =====================================================

  Future<List<AdminServiceModel>> getServicesByCategory(
      String salonId,
      String category,
      ) async {
    final snapshot = await _servicesCollection(
      salonId,
    )
        .where(
      'category',
      isEqualTo: category,
    )
        .get();

    return snapshot.docs
        .map(
          (doc) => AdminServiceModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  // =====================================================
  // CREATE
  // =====================================================

  Future<String> createService(
      String salonId,
      AdminServiceModel service,
      ) async {
    final data = service.toMap();

    final doc = await _servicesCollection(
      salonId,
    ).add(
      {
        ...data,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    );

    return doc.id;
  }

  // =====================================================
  // UPDATE
  // =====================================================

  Future<void> updateService(
      String salonId,
      String serviceId,
      Map<String, dynamic> data,
      ) async {
    await _servicesCollection(
      salonId,
    )
        .doc(serviceId)
        .update(
      {
        ...data,
        'updatedAt': Timestamp.now(),
      },
    );
  }

  // =====================================================
  // TOGGLE ATTIVO / INATTIVO
  // =====================================================

  Future<void> toggleActive(
      String salonId,
      String serviceId,
      bool active,
      ) async {
    await _servicesCollection(
      salonId,
    )
        .doc(serviceId)
        .update(
      {
        'active': active,
        'updatedAt': Timestamp.now(),
      },
    );
  }

  // =====================================================
  // DISATTIVA SERVIZIO
  // =====================================================

  Future<void> deleteService(
      String salonId,
      String serviceId,
      ) async {
    await toggleActive(
      salonId,
      serviceId,
      false,
    );
  }

  // =====================================================
  // RIATTIVA SERVIZIO
  // =====================================================

  Future<void> restoreService(
      String salonId,
      String serviceId,
      ) async {
    await toggleActive(
      salonId,
      serviceId,
      true,
    );
  }
}