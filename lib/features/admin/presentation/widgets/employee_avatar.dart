import 'package:flutter/material.dart';

class EmployeeAvatar extends StatelessWidget {
  const EmployeeAvatar({
    super.key,
    required this.photoUrl,
  });

  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundImage:
      photoUrl.isNotEmpty
          ? NetworkImage(photoUrl)
          : null,
      child: photoUrl.isEmpty
          ? const Icon(
        Icons.person,
        size: 30,
      )
          : null,
    );
  }
}