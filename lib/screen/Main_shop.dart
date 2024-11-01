import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/screen/home.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:tonyyyoyfood/widget/food_menu_shop.dart';
import 'package:tonyyyoyfood/widget/information_shop.dart';
import 'package:tonyyyoyfood/widget/order_shop.dart';

class MainShop extends StatefulWidget {
  const MainShop({super.key});

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currenWidget = OrderShop();
  Future<Null> sigOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const Home()), // Navigate to Sigin
      (route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main shop'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            onPressed: () => sigOutProcess(), // Call the method here
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      drawer: ShowDrawer(),
      body: currenWidget,
    );
  }

  Drawer ShowDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHead(),
            homeMenu(),
            foodMenu(),
            informationMenu(),
            singOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
      leading: Icon(Icons.home),
      title: Text('ລາຍການອາຫານທີ່ສັງລຼກຄ້າ'),
      subtitle: Text('ລາຍການທີ່ຫຍັງບໍທັນສົ່ງ'),
      onTap: () {
        setState(() {
          currenWidget = OrderShop();
        });
        Navigator.pop(context);
      });
  ListTile foodMenu() => ListTile(
      leading: Icon(Icons.food_bank),
      title: Text('ລາຍການອາຫານຂອງຮ້ານ'),
      subtitle: Text('ລາຍການ'),
      onTap: () {
        setState(() {
          currenWidget = FoodMenuShop();
        });
        Navigator.pop(context);
      });
  ListTile informationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('ລາຍລະອຽດຂອງຮ້ານ'),
        onTap: () {
          setState(() {
            currenWidget = InformationShop();
          });
          Navigator.pop(context);
        },
      );
  ListTile singOutMenu() => ListTile(
      leading: Icon(Icons.logout),
      title: Text('ອອກລະບົບ'),
      onTap: () => sigOutProcess());
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('shop.avif'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Name Shop',
          style: TextStyle(color: MyStyle().darkcolor),
        ),
        accountEmail: Text(
          'Login',
          style: TextStyle(color: MyStyle().promaryColor),
        ));
  }
}
