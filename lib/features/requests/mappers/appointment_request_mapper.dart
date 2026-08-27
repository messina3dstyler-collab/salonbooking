import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment_request.dart';

class AppointmentRequestMapper {
  const AppointmentRequestMapper();

  AppointmentRequest fromMap(
      Map<String, dynamic> map,
      ) {
    return AppointmentRequest.fromMap(map);
  }

  AppointmentRequest fromDocument(
      DocumentSnapshot<Map<String, dynamic>> document,
      ) {
    final data = document.data() ?? <String, dynamic>{};

    return AppointmentRequest.fromMap({
      "id": document.id,
      ...data,
    });
  }

  Map<String, dynamic> toMap(
      AppointmentRequest request,
      ) {
    return request.toMap();
  }

  List<AppointmentRequest> fromList(
      List<Map<String, dynamic>> list,
      ) {
    return list
        .map(fromMap)
        .toList();
  }

  List<AppointmentRequest> fromDocuments(
      Iterable<DocumentSnapshot<Map<String, dynamic>>> documents,
      ) {
    return documents
        .map(fromDocument)
        .toList();
  }

  List<Map<String, dynamic>> toList(
      List<AppointmentRequest> list,
      ) {
    return list
        .map(toMap)
        .toList();
  }
}