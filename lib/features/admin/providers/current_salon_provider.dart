import 'package:flutter_riverpod/flutter_riverpod.dart';

/// =======================================================
/// CURRENT SALON PROVIDER
/// =======================================================
///
/// Contiene il salonId dell'amministratore loggato.
/// Viene valorizzato al login.
///

final currentSalonIdProvider = StateProvider<String>(
      (ref) => '',
);