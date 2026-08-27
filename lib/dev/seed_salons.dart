import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

import 'package:flutter/foundation.dart';

Future<void> seedSalons() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  final salons = [
    {
      "name": "Luxury Barber",
      "address": "Via Roma 25",
      "city": "Torino",
      "description": "Barber Shop Premium",
      "imageUrl": "",
      "phone": "0111234567",
      "rating": 4.8,
      "reviewCount": 132,
    },
    {
      "name": "Elite Hair Studio",
      "address": "Corso Francia 80",
      "city": "Torino",
      "description": "Tagli moderni e colore professionale",
      "imageUrl": "",
      "phone": "0119876543",
      "rating": 4.9,
      "reviewCount": 281,
    },
    {
      "name": "Beauty Lounge",
      "address": "Via Garibaldi 12",
      "city": "Milano",
      "description": "Centro estetico e parrucchiere",
      "imageUrl": "",
      "phone": "028881111",
      "rating": 4.7,
      "reviewCount": 175,
    },
    {
      "name": "Style Point",
      "address": "Via Toledo 41",
      "city": "Napoli",
      "description": "Hair stylist professionisti",
      "imageUrl": "",
      "phone": "081445566",
      "rating": 4.6,
      "reviewCount": 96,
    },
    {
      "name": "Barber House",
      "address": "Via del Corso 101",
      "city": "Roma",
      "description": "Barber shop moderno",
      "imageUrl": "",
      "phone": "061234567",
      "rating": 4.8,
      "reviewCount": 310,
    },
  ];

  for (final salon in salons) {
    await firestore.collection('salons').add(salon);
  }

  debugPrint("Saloni importati!");
}
