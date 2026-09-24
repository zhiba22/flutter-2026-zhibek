import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/1.jpg', height: 200, width:200),
        Text(name, style: TextStyle(fontFamily: 'MyFont')),
        Text(university),
      ],
    );
  }
}
