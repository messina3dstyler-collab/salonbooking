import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:salon_booking/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Firebase bootstrap with local emulators',
    (tester) async {
      print('');
      print('=== FIREBASE INTEGRATION BOOTSTRAP TEST ===');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      print('FIREBASE INITIALIZE: OK');

      final auth = FirebaseAuth.instance;
      final firestore = FirebaseFirestore.instance;
      final functions = FirebaseFunctions.instanceFor(
        region: 'europe-west12',
      );

      await auth.useAuthEmulator(
        '127.0.0.1',
        9099,
      );

      firestore.useFirestoreEmulator(
        '127.0.0.1',
        8080,
      );

      functions.useFunctionsEmulator(
        '127.0.0.1',
        5001,
      );

      print('AUTH EMULATOR: OK');
      print('FIRESTORE EMULATOR: OK');
      print('FUNCTIONS EMULATOR: OK');

      print('');
      print('==========================================');
      print('FIREBASE INTEGRATION BOOTSTRAP: PASS');
      print('==========================================');
    },
  );
}