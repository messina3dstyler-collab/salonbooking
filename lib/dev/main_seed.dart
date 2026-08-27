import 'package:flutter/material.dart';

import 'seed_salons.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await seedSalons();

  debugPrint("Import completato");
}
