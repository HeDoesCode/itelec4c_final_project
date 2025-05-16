import 'package:flutter/material.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: Colors.orangeAccent);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
