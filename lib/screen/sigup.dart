import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/connectPHP.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:tonyyyoyfood/urinity/normail_diarlog.dart';

class Sigup extends StatefulWidget {
  const Sigup({super.key});

  @override
  State<Sigup> createState() => _SigupState();
}

class _SigupState extends State<Sigup> {
  String? choosetype, name, user, password = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sigUp'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          show_logo2(),
          MyStyle().mySizebox(),
          showAppname(),
          MyStyle().mySizebox(),
          nameForm(),
          MyStyle().mySizebox(),
          userForm(),
          MyStyle().mySizebox(),
          PasswordForm(),
          MyStyle().mySizebox(),
          MyStyle().showTitleH2('ສະຖານະ :'),
          MyStyle().mySizebox(),
          userRaio(),
          shopraio(),
          ridershop(),
          RegisterBtn()
        ],
      ),
    );
  }

  Widget RegisterBtn() => Container(
        width: 250,
        child: OutlinedButton(
          onPressed: () {
            print(
                'name= $name,user = $user , password = $password, choosetype=$choosetype');
            if (name == null ||
                name!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              print('Have space');
              mormailDiarlog(context, 'ມີຊ່ອງວ່າງ');
            } else if (choosetype == null) {
              mormailDiarlog(context, 'ເລືອກສະຖານະ');
            } else {
              checkUser();
            }
          },
          child: Text(
            'Register',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: MyStyle().darkcolor, // สีตัวอักษร
            side: BorderSide(color: Colors.blue), // สีขอบปุ่ม
            padding:
                EdgeInsets.symmetric(vertical: 15), // การจัดตำแหน่งขอบในปุ่ม
          ),
        ),
      );
  Future<Null> checkUser() async {
    String url =
        '${Part.baseUrl}UngFood/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        mormailDiarlog(context, 'user $user Sum kun');
      }
    } catch (e) {
      print('eoer');
    }
  }

  Future<Null> registerThread() async {
    String url =
        '${Part.baseUrl}UngFood/addUser2.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$choosetype';

    try {
      Response response = await Dio().get(url);
      print("Res = $response");

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        mormailDiarlog(context, 'Not regis');
      }
    } catch (e) {}
  }

  Widget userRaio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'User',
                  groupValue: choosetype,
                  onChanged: (value) {
                    setState(() {
                      choosetype = value;
                    });
                  },
                ),
                Text('ຜູ້ສັງອາຫານ')
              ],
            ),
          ),
        ],
      );

  Widget shopraio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'shop',
                  groupValue: choosetype,
                  onChanged: (value) {
                    setState(() {
                      choosetype = value;
                    });
                  },
                ),
                Text('ເຈົ້າຂອງຮ້ານ')
              ],
            ),
          ),
        ],
      );

  Widget ridershop() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Rider',
                  groupValue: choosetype,
                  onChanged: (value) {
                    setState(() {
                      choosetype = value;
                    });
                  },
                ),
                Text('ຜູ້ສົງອາຫານ')
              ],
            ),
          ),
        ],
      );

  Row showAppname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MyStyle().showTitle('Tony food'),
      ],
    );
  }

  Widget show_logo2() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );

  Widget nameForm() => Container(
      width: 250,
      child: TextField(
        onChanged: (value) => name = value.trim(),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.face,
              color: MyStyle().darkcolor,
            ),
            labelStyle: TextStyle(color: MyStyle().darkcolor),
            labelText: 'name',
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().darkcolor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyStyle().promaryColor))),
      ));
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
