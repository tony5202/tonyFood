import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/screen/add_food_menu.dart';

class FoodMenuShop extends StatefulWidget {
  const FoodMenuShop({super.key});

  @override
  State<FoodMenuShop> createState() => _FoodMenuShopState();
}

class _FoodMenuShopState extends State<FoodMenuShop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menu Shop'),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              // เนื้อหาอื่น ๆ
            ],
          ),
          addMenubtn(),
        ],
      ),
    );
  }

  Widget addMenubtn() => Align(
        alignment: Alignment.bottomRight, // จัดให้อยู่มุมล่างขวา
        child: Padding(
          padding: EdgeInsets.all(16.0), // ระยะห่างจากขอบ
          child: FloatingActionButton(
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => AddFoodMenu());
              Navigator.push(context, route);
            },
            child: const Icon(Icons.add), // ไอคอนหรือเนื้อหาที่จะแสดง
          ),
        ),
      );
}
