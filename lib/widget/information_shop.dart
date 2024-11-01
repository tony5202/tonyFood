import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/screen/add_info_shop.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';

class InformationShop extends StatefulWidget {
  const InformationShop({super.key});

  @override
  State<InformationShop> createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MyStyle().titleCenter(context, 'ຍັງບໍ່ມີຂໍ້ມູນ'),
        addAndEditButton(),
      ],
    );
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.all(40),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: routeInfo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void routeInfo() {
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => AddInfoShop(),
    );
    Navigator.push(context, materialPageRoute);
  }
}
