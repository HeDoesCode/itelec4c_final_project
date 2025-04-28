import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final IconData iconLabel;
  final VoidCallback action;

  const TransparentButton({
    super.key,
    required this.iconLabel,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Icon(iconLabel, color: Colors.black, size: 24),
    );
  }
}
