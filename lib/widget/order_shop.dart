import 'package:flutter/material.dart';

import 'package:tonyyyoyfood/model/user_model.dart';

class OrderShop extends StatefulWidget {
  const OrderShop({super.key});

  @override
  State<OrderShop> createState() => _OrderShopState();
}

class _OrderShopState extends State<OrderShop> {
  UserModel? userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Order user');
  }
}
