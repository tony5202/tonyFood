import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/screen/Main_rider.dart';
import 'package:tonyyyoyfood/screen/Main_shop.dart';
import 'package:tonyyyoyfood/screen/main_User.dart';
import 'package:tonyyyoyfood/screen/sigIn.dart';
import 'package:tonyyyoyfood/screen/sigUp.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:tonyyyoyfood/urinity/normail_diarlog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    checkPreferen();
  }

  Future<Null> checkPreferen() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString('ChooseType');
      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToservic(MainUser());
        } else if (chooseType == 'shop') {
          routeToservic(MainShop());
        } else if (chooseType == 'Rider') {
          routeToservic(MainRider());
        } else {
          mormailDiarlog(context, 'Erorr use type');
        }
      }
    } catch (e) {}
  }

  void routeToservic(Widget myWisget) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWisget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Image.asset(
          'images/bn.png',
          height: 300,
        ),
      ),
      drawer: showdrawer(),
    );
  }

  Drawer showdrawer() => Drawer(
        child: ListView(
          children: <Widget>[showHeadra(), signMenu(), siUpMenu()],
        ),
      );

  ListTile signMenu() => ListTile(
        leading: Icon(Icons.android),
        title: Text('Sigin'),
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => Sigin());
          Navigator.push(context, route);
        },
      );
  ListTile siUpMenu() => ListTile(
        leading: Icon(Icons.android),
        title: Text('SigUp'),
        onTap: () {
          Navigator.pop(context);
          MaterialPageRoute route =
              MaterialPageRoute(builder: (value) => Sigup());
          Navigator.push(context, route);
        },
      );

  UserAccountsDrawerHeader showHeadra() {
    return UserAccountsDrawerHeader(
        decoration: MyStyle().myBoxDecoration('home.png'),
        currentAccountPicture: MyStyle().showLogo(),
        accountName: Text('guest'),
        accountEmail: Text('Login'));
  }
}
