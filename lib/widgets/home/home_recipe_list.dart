import 'package:flutter/material.dart';
import 'package:my_recipe/screens/recipe_grid_screen.dart';
import 'package:my_recipe/widgets/recipe_card.dart';

final List<Map<String, dynamic>> recipeList = <Map<String, dynamic>>[
  {
    "title": "กะเพราหมูเด้ง",
    "likes": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
    "description":
        "กะเพราที่ถูกรังสรรค์เพื่อคนชอบหมูเด้ง เป็นชีวิตจิตใจ ทำมาจาก เนื้อฮิปโปผสมเนื้อหมูสับ",
    "ingredients": [
      "เนื้อหทูเด้ง 100 กรัม",
      "เนื้อหมูสับ 50 กรัม",
      "ใบกะเพรา 20 กรัม",
      "ข้าวเปล่า 4 ทัพพี",
      "ไข่ 1 ฟอง",
    ],
    "instructions":
        "1. เทน้ำมัน \n2.เทข้าว \n3.ใส่เนื้อกับใบกะเพราแล้วผัดๆๆๆๆงั่มๆ ",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "likes": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
    "description":
        "กะเพราที่ถูกรังสรรค์เพื่อคนชอบหมูเด้ง เป็นชีวิตจิตใจ ทำมาจาก เนื้อฮิปโปผสมเนื้อหมูสับ",
    "ingredients": [
      "เนื้อหทูเด้ง 100 กรัม",
      "เนื้อหมูสับ 50 กรัม",
      "ใบกะเพรา 20 กรัม",
      "ข้าวเปล่า 4 ทัพพี",
      "ไข่ 1 ฟอง",
    ],
    "instructions":
        "1. เทน้ำมัน \n2.เทข้าว \n3.ใส่เนื้อกับใบกะเพราแล้วผัดๆๆๆๆงั่มๆ ",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "likes": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
    "description":
        "กะเพราที่ถูกรังสรรค์เพื่อคนชอบหมูเด้ง เป็นชีวิตจิตใจ ทำมาจาก เนื้อฮิปโปผสมเนื้อหมูสับ",
    "ingredients": [
      "เนื้อหทูเด้ง 100 กรัม",
      "เนื้อหมูสับ 50 กรัม",
      "ใบกะเพรา 20 กรัม",
      "ข้าวเปล่า 4 ทัพพี",
      "ไข่ 1 ฟอง",
    ],
    "instructions":
        "1. เทน้ำมัน \n2.เทข้าว \n3.ใส่เนื้อกับใบกะเพราแล้วผัดๆๆๆๆงั่มๆ ",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "likes": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
    "description":
        "กะเพราที่ถูกรังสรรค์เพื่อคนชอบหมูเด้ง เป็นชีวิตจิตใจ ทำมาจาก เนื้อฮิปโปผสมเนื้อหมูสับ",
    "ingredients": [
      "เนื้อหทูเด้ง 100 กรัม",
      "เนื้อหมูสับ 50 กรัม",
      "ใบกะเพรา 20 กรัม",
      "ข้าวเปล่า 4 ทัพพี",
      "ไข่ 1 ฟอง",
    ],
    "instructions":
        "1. เทน้ำมัน \n2.เทข้าว \n3.ใส่เนื้อกับใบกะเพราแล้วผัดๆๆๆๆงั่มๆ ",
  },
  {
    "title": "กะเพราหมูเด้ง",
    "likes": 1234,
    "category": "ข้าวผัด",
    "difficulty": "ง่าย",
    "imageUrl": "assets/images/pad_kra_pao.png",
    "description":
        "กะเพราที่ถูกรังสรรค์เพื่อคนชอบหมูเด้ง เป็นชีวิตจิตใจ ทำมาจาก เนื้อฮิปโปผสมเนื้อหมูสับ",
    "ingredients": [
      "เนื้อหทูเด้ง 100 กรัม",
      "เนื้อหมูสับ 50 กรัม",
      "ใบกะเพรา 20 กรัม",
      "ข้าวเปล่า 4 ทัพพี",
      "ไข่ 1 ฟอง",
    ],
    "instructions":
        "1. เทน้ำมัน \n2.เทข้าว \n3.ใส่เนื้อกับใบกะเพราแล้วผัดๆๆๆๆงั่มๆ ",
  },
];

class HomeRecipeList extends StatelessWidget {
  const HomeRecipeList({super.key, required String title}) : _title = title;

  final String _title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_title, style: Theme.of(context).textTheme.headlineMedium),
            GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => RecipeGridScreen(
                            recipeList: recipeList,
                            title: _title,
                          ),
                    ),
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "เพิ่มเติม",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.navigate_next_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recipeList.length,
            separatorBuilder: (context, index) => SizedBox(width: 6),
            itemBuilder:
                (context, index) => RecipeCard(recipe: recipeList[index]),
          ),
        ),
      ],
    );
  }
}
