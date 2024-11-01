import 'package:flutter/material.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddInfoShop extends StatefulWidget {
  const AddInfoShop({super.key});

  @override
  State<AddInfoShop> createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  late GoogleMapController mapController;

  final LatLng _initialPosition =
      LatLng(17.972843, 102.621245); // Example location (Bangkok)

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Information'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameForm(),
            SizedBox(height: 15),
            addressForm(),
            SizedBox(height: 15),
            PhoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            showMap(),
            MyStyle().mySizebox(),
            saveInfor()
          ],
        ),
      ),
    );
  }

  Widget saveInfor() => Container(
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          onPressed: () {},
          child: Text('Save Information'),
        ),
      );

  Container showMap() {
    return Container(
      height: 300,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_a_photo,
            size: 37,
          ),
        ),
        Container(
          width: 250,
          child: Image.asset('images/img.png'),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_photo_alternate,
            size: 37,
          ),
        ),
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ຊື່ຮ້ານ',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ທີ່ຢູ່',
                prefixIcon: Icon(Icons.home_work),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget PhoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ເບີໂທ',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
