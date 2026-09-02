import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/salon_model.dart';

class SalonRepository {
  SalonRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _salons =>
      _firestore.collection('salons');

  Future<List<SalonModel>> getSalons() async {
    final snapshot = await _salons
        .where('active', isEqualTo: true)
        .get();

    debugPrint(
      'SALONI ATTIVI TROVATI: ${snapshot.docs.length}',
    );

    for (final doc in snapshot.docs) {
      debugPrint(
        '${doc.id} => ${doc.data()}',
      );
    }

    return snapshot.docs
        .map(
          (doc) => SalonModel.fromMap(
        doc.id,
        doc.data(),
      ),
    )
        .toList();
  }

  Future<void> createSalon(
      SalonModel salon,
      ) async {
    await _salons
        .doc(salon.id)
        .set(
      salon.toMap(),
    );
  }

  Future<SalonModel?> getSalon(
      String id,
      ) async {
    final doc = await _salons.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return SalonModel.fromMap(
      doc.id,
      doc.data()!,
    );
  }

  Future<void> deleteSalon(
      String salonId,
      ) async {
    await _salons
        .doc(salonId)
        .delete();
  }
}