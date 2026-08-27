import '../models/appointment_request.dart';

extension RequestAuthorExtension on RequestAuthor {
  String get label {
    switch (this) {
      case RequestAuthor.admin:
        return "Amministratore";

      case RequestAuthor.employee:
        return "Operatore";

      case RequestAuthor.customer:
        return "Cliente";

      case RequestAuthor.system:
        return "Sistema";
    }
  }
}