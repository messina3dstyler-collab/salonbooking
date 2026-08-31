enum RequestTimelineEventType {
  created,
  updated,
  notificationSent,
  viewed,
  accepted,
  rejected,
  expired,
  cancelled,
  appointmentUpdated,
  employeeUpdated,
  servicesUpdated,
  system,
}

enum RequestTimelineAuthor {
  admin,
  employee,
  customer,
  system,
}

class RequestTimelineEvent {
  const RequestTimelineEvent({
    required this.id,
    required this.requestId,
    required this.type,
    required this.createdAt,
    required this.author,
    this.message,
  });

  final String id;

  final String requestId;

  final RequestTimelineEventType type;

  final DateTime createdAt;

  final RequestTimelineAuthor author;

  /// Testo opzionale mostrato nella timeline.
  final String? message;

  RequestTimelineEvent copyWith({
    String? id,
    String? requestId,
    RequestTimelineEventType? type,
    DateTime? createdAt,
    RequestTimelineAuthor? author,
    String? message,
  }) {
    return RequestTimelineEvent(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "requestId": requestId,
      "type": type.name,
      "createdAt": createdAt.toIso8601String(),
      "author": author.name,
      "message": message,
    };
  }

  factory RequestTimelineEvent.fromMap(
      Map<String, dynamic> map,
      ) {
    return RequestTimelineEvent(
      id: map["id"] ?? "",
      requestId: map["requestId"] ?? "",
      type: RequestTimelineEventType.values.byName(
        map["type"] ?? "system",
      ),
      createdAt: DateTime.parse(
        map["createdAt"],
      ),
      author: RequestTimelineAuthor.values.byName(
        map["author"] ?? "system",
      ),
      message: map["message"],
    );
  }
}