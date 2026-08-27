import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'package:flutter/foundation.dart';

Future<void> seedServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  final salons = await firestore.collection('salons').get();

  final services = [
    {
      "name": "Taglio Uomo",
      "description": "Taglio classico e styling",
      "price": 25.0,
      "duration": 30,
    },
    {
      "name": "Barba",
      "description": "Rifinitura barba professionale",
      "price": 15.0,
      "duration": 20,
    },
    {
      "name": "Taglio + Barba",
      "description": "Pacchetto completo",
      "price": 35.0,
      "duration": 50,
    },
    {
      "name": "Shampoo",
      "description": "Lavaggio professionale",
      "price": 8.0,
      "duration": 10,
    },
    {
      "name": "Colore",
      "description": "Colorazione capelli",
      "price": 45.0,
      "duration": 90,
    },
  ];

  for (final salon in salons.docs) {
    final collection = firestore
        .collection('salons')
        .doc(salon.id)
        .collection('services');

    for (final service in services) {
      await collection.add(service);
    }
  }

  debugPrint("Saloni importati!");
}
