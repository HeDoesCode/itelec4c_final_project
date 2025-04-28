import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/appbar.dart';
import 'package:itelec4c_final_project/components/transparent_btn.dart';

class RecipeDetailsPage extends StatelessWidget {
  const RecipeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 255, 224, 178),
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            RecipeDetailHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Image(image: AssetImage('images/img_placeholder_rect.png')),
                  SizedBox(height: 20),
                  ListBuilder(
                    title: "Ingredients",
                    list: ["ingredient 1", "ingredient 2", "ingredient 3"],
                  ),
                  SizedBox(height: 20),
                  ListBuilder(
                    title: "Procedure",
                    list: ["Step 1", "Step 2", "Step 3", "step 4"],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListBuilder extends StatelessWidget {
  final String title;
  final List<String> list;

  const ListBuilder({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (String text in list) Text(text)],
          ),
        ],
      ),
    );
  }
}

class RecipeDetailHeader extends StatelessWidget {
  const RecipeDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          TransparentButton(iconLabel: Icons.arrow_back, action: () {}),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          TransparentButton(
            iconLabel: Icons.bookmark_border_outlined,
            action: () {},
          ),
        ],
      ),
    );
  }
}
