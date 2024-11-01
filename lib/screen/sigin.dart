import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/connectPHP.dart';
import 'package:tonyyyoyfood/model/user_model.dart';
import 'package:tonyyyoyfood/screen/Main_rider.dart';
import 'package:tonyyyoyfood/screen/Main_shop.dart';
import 'package:tonyyyoyfood/screen/main_User.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:tonyyyoyfood/urinity/normail_diarlog.dart';

class Sigin extends StatefulWidget {
  const Sigin({super.key});

  @override
  State<Sigin> createState() => _SiginState();
}

class _SiginState extends State<Sigin> {
  String? user, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sigIn'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: <Color>[Colors.white, MyStyle().promaryColor],
              center: Alignment(0, -0.3),
              radius: 1.0),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MyStyle().showLogo(),
                MyStyle().showTitle('Tony Food'),
                MyStyle().mySizebox(),
                userForm(),
                MyStyle().mySizebox(),
                PasswordForm(),
                MyStyle().mySizebox(),
                loginBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginBtn() => Container(
        width: 250,
        child: OutlinedButton(
          onPressed: () {
            if (user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              mormailDiarlog(context, 'ປ້ອນໃຫ້ຄົບ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: MyStyle().darkcolor, // สีตัวอักษร
            side: BorderSide(color: Colors.blue), // สีขอบปุ่ม
            padding:
                EdgeInsets.symmetric(vertical: 15), // การจัดตำแหน่งขอบในปุ่ม
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        '${Part.baseUrl}UngFood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        var result = json.decode(response.data);
        if (result is List && result.isNotEmpty) {
          for (var map in result) {
            UserModel userModel = UserModel.fromJson(map);
            if (password == userModel.password) {
              String? chooseType = userModel.chooseType;
              if (chooseType == 'User') {
                routeTuservice(MainUser(), userModel);
              } else if (chooseType == 'shop') {
                routeTuservice(MainShop(), userModel);
              } else if (chooseType == 'Rider') {
                routeTuservice(MainRider(), userModel);
              } else {
                mormailDiarlog(context, 'Error: Unknown user type');
              }
            } else {
              mormailDiarlog(context, 'Incorrect password');
            }
          }
        } else {
          mormailDiarlog(context, 'No user found');
        }
      } else {
        mormailDiarlog(context,
            'Error: Server responded with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      mormailDiarlog(context, 'Cannot connect to the server');
    }
  }

  Future<Null> routeTuservice(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', userModel.id!);
    preferences.setString('ChooseType', userModel.chooseType!);
    preferences.setString('Name', userModel.name!);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
      width: 250,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_box,
              color: MyStyle().darkcolor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkcolor),
            labelText: 'User',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkcolor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().promaryColor))),
      ));

  Widget PasswordForm() => Container(
      width: 250,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.password,
              color: MyStyle().darkcolor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkcolor),
            labelText: 'Password',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkcolor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().promaryColor))),
      ));
}
