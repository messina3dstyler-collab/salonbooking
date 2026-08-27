import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

/// Crea gli operatori di esempio per ogni salone esistente.
/// Gli ID fissi rendono l'operazione sicura da eseguire piu' volte.
Future<void> seedEmployees() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final salons = await firestore.collection('salons').get();

  const employees = [
    {
      'id': 'operatore-marco',
      'name': 'Marco Rossi',
      'specialization': 'Taglio e styling',
      'phone': '+39 320 000 0001',
      'rating': 4.8,
      'reviewCount': 124,
    },
    {
      'id': 'operatore-giulia',
      'name': 'Giulia Bianchi',
      'specialization': 'Colore e trattamenti',
      'phone': '+39 320 000 0002',
      'rating': 4.9,
      'reviewCount': 98,
    },
  ];

  for (final salon in salons.docs) {
    final batch = firestore.batch();
    final collection = salon.reference.collection('employees');

    for (final employee in employees) {
      batch.set(collection.doc(employee['id']! as String), {
        'name': employee['name'],
        'specialization': employee['specialization'],
        'phone': employee['phone'],
        'rating': employee['rating'],
        'reviewCount': employee['reviewCount'],
        'active': true,
        'photoUrl': '',
      }, SetOptions(merge: true));
    }

    await batch.commit();
  }

  debugPrint('Operatori importati!');
}
