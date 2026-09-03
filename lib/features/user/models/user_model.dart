class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.salonId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;

  /// customer | admin
  ///
  /// customer = cliente finale
  /// admin = account del Salon
  final String role;

  /// Valorizzato per gli account Salon (admin).
  final String? salonId;

  final DateTime createdAt;

  factory UserModel.fromMap(
      String id,
      Map<String, dynamic> json,
      ) {
    return UserModel(
      id: id,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer',
      salonId: json['salonId']?.toString(),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'salonId': salonId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? salonId,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      salonId: salonId ?? this.salonId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get isCustomer => role == 'customer';

  bool get isAdmin => role == 'admin';
}