import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/service_model.dart';

class ServiceRepository {
  ServiceRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<ServiceModel>> getServices(String salonId) async {
    final snapshot =
        await _firestore
            .collection('salons')
            .doc(salonId)
            .collection('services')
            .orderBy('name')
            .get();

    return snapshot.docs
        .map((doc) => ServiceModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
