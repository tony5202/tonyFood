import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/screen/home.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart'; // Import the Sigin screen

class MainUser extends StatefulWidget {
  const MainUser({super.key});

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String? nameUser;

  @override
  void initState() {
    super.initState();
    finUser();
  }

  Future<Null> finUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

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
        title: Text(nameUser == null ? 'MainUser' : '$nameUser Login'),
        actions: <Widget>[
          IconButton(
            onPressed: () => sigOutProcess(),
            icon: Icon(Icons.exit_to_app),
          ),
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
        decoration: MyStyle().myBoxDecoration('User.png'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text(
          'Name login',
          style: TextStyle(color: MyStyle().darkcolor),
        ),
        accountEmail: Text(
          'Login',
          style: TextStyle(color: MyStyle().promaryColor),
        ));
  }
}
