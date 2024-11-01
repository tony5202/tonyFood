import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/screen/home.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';

class MainRider extends StatefulWidget {
  const MainRider({super.key});

  @override
  State<MainRider> createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
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
        title: Text('Main Rider'),
        actions: <Widget>[
          IconButton(
              onPressed: () => sigOutProcess(), icon: Icon(Icons.exit_to_app)),
        ],
      ),
      drawer: ShowDrawer(),
    );
  }

  Drawer ShowDrawer() => Drawer(
        child: ListView(
          children: <Widget>[showHead()],
        ),
      );
  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('rider.jpg'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Name Rider',
          style: TextStyle(color: MyStyle().darkcolor),
        ),
        accountEmail: Text(
          'Login',
          style: TextStyle(color: MyStyle().promaryColor),
        ));
  }
}
