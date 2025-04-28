import 'package:flutter/material.dart';

class RecipeFeaturedItem extends StatelessWidget {
  const RecipeFeaturedItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage('images/img_placeholder_rect.png')),
        Positioned(bottom: 0, left: 0, child: Text("Title")),
      ],
    );
  }
}
