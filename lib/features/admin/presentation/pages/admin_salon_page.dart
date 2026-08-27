import 'package:flutter/material.dart';

class AdminSalonPage extends StatelessWidget {
  const AdminSalonPage({
    super.key,
    required this.salonId,
  });

  final String salonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Salone',
        ),
      ),
      body: Center(
        child: Text(
          'Impostazioni Salone\n'
              'Salone ID: $salonId',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}