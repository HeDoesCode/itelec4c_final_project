import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/appbar.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;

  const ProfilePage({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(), body: Center());
  }
}
