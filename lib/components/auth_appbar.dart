import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Dishly", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: [
        TransparentButton(
          iconLabel: Icons.search,
          action: () {
            Navigator.pushNamed(context, '/recipe/search');
          },
        ),
      ],
      backgroundColor: Colors.orangeAccent,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
