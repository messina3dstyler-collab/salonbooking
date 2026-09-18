import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'firebase_options.dart';

import 'core/services/notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb && kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator(
      '127.0.0.1',
      9099,
    );

    FirebaseFirestore.instance.useFirestoreEmulator(
      '127.0.0.1',
      8080,
    );

    FirebaseFunctions.instanceFor(
      region: 'europe-west12',
    ).useFunctionsEmulator(
      '127.0.0.1',
      5001,
    );
  }

  await NotificationService().initialize();
  await initializeDateFormatting('it_IT');

  runApp(
    const ProviderScope(
      child: SalonBookingApp(),
    ),
  );
}