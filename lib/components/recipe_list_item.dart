import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';

class RecipeListItem extends StatelessWidget {
  final String name;
  final String ingredients;
  final String category;
  final int time;

  const RecipeListItem({
    super.key,
    required this.name,
    required this.ingredients,
    required this.category,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          Row(
            children: [
              Image(
                width: 125,
                image: AssetImage('images/img_placeholder_square.png'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(ingredients, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orangeAccent,
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, color: Colors.grey),
                      SizedBox(width: 5),
                      Text(
                        "${time.toString()} mins",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 5,
            right: 5,
            child: TransparentButton(
              iconLabel: Icons.bookmark_border_rounded,
              action: () {},
            ),
          ),
        ],
      ),
    );
  }
}
