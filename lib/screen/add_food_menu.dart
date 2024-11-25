import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';

class AddFoodMenu extends StatefulWidget {
  const AddFoodMenu({super.key});

  @override
  State<AddFoodMenu> createState() => _AddFoodMenuState();
}

class _AddFoodMenuState extends State<AddFoodMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add menu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            showtitleTopFood('ຮູບອາຫານ'),
            gourpIamge(),
            showtitleTopFood('ລາຍລະອຽດອາຫານ'),
            namForm(),
            MyStyle().mySizebox(),
            pricForm(),
            MyStyle().mySizebox(),
            detaiForm(),
            MyStyle().mySizebox(),
            savebtn()
          ],
        ),
      ),
    );
  }

  Widget savebtn() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton.icon(
        onPressed: () {
          debugPrint('Save Button Pressed');
        },
        icon: const Icon(Icons.save, color: Colors.white), // สีของไอคอน
        label: const Text('Save',
            style: TextStyle(color: Colors.white)), // สีข้อความ
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.blue, // สีพื้นหลังของปุ่ม
          side: const BorderSide(
              color: Colors.blue, width: 2), // สีและขนาดเส้นขอบ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // มุมโค้งของปุ่ม
          ),
        ),
      ),
    );
  }

  Widget namForm() => Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.fastfood),
            labelText: 'ຊື່ອາຫານ',
            border: OutlineInputBorder()),
      ));
  Widget pricForm() => Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.price_change),
            labelText: 'ລາຄາ',
            border: OutlineInputBorder()),
      ));
  Widget detaiForm() => Container(
      width: 250,
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.details),
            labelText: 'ລາຍລະອຽດ',
            border: OutlineInputBorder()),
      ));

  Row gourpIamge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: null, icon: Icon(Icons.add_a_photo)),
        Container(
          width: 250,
          height: 250,
          child: Image.asset('images/foodmenu.png'),
        ),
        IconButton(onPressed: null, icon: Icon(Icons.add_photo_alternate)),
      ],
    );
  }

  Widget showtitleTopFood(String str) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          MyStyle().showTitleH2(str),
        ],
      ),
    );
  }
}
