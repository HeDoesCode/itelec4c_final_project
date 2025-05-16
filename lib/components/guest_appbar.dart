import 'package:flutter/material.dart';

class GuestAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Color darkYellow = Colors.amber[800]!;

  GuestAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: darkYellow,
      leading: BackButton(color: Colors.white),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
