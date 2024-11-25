import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/connectPHP.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tonyyyoyfood/urinity/normail_diarlog.dart';

class AddInfoShop extends StatefulWidget {
  const AddInfoShop({super.key});

  @override
  State<AddInfoShop> createState() => _AddInfoShopState();
}

class _AddInfoShopState extends State<AddInfoShop> {
  double? lat, lng;
  File? file;
  String? nameShop, addrss, phone, urlImage;
  late GoogleMapController mapController;
  LatLng _initialPosition = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<void> findLatLng() async {
    LocationData? locationData = await findLocationData();
    if (locationData != null) {
      setState(() {
        lat = locationData.latitude;
        lng = locationData.longitude;
        _initialPosition = LatLng(lat!, lng!); // Use non-null assertion
      });
    } else {
      print('Failed to get location data');
    }
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

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
            phoneForm(),
            MyStyle().mySizebox(),
            groupImage(),
            MyStyle().mySizebox(),
            lat == null ? MyStyle().showProgress() : showMap(),
            MyStyle().mySizebox(),
            saveIButon(),
          ],
        ),
      ),
    );
  }

  Widget saveIButon() => Container(
        width: MediaQuery.of(context).size.width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          onPressed: () {
            if (nameShop == null ||
                nameShop!.isEmpty ||
                addrss == null ||
                addrss!.isEmpty ||
                phone == null ||
                phone!.isEmpty) {
              mormailDiarlog(context, 'ປ້ອນໃຫ້ຄົບ');
            } else if (file == null) {
              mormailDiarlog(context, 'pic select');
            } else {
              uploadImge();
            }
          },
          child: Text('Save Information'),
        ),
      );
  Future<Null> uploadImge() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'shop$i.jpg';
    String url = '${Part.baseUrl}UngFood/saveShop.php';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        urlImage = '/UngFood/shop/$nameImage';
        editUserShop();
      });
    } catch (e) {}
  }

  Future<Null> editUserShop() async {
    SharedPreferences preferen = await SharedPreferences.getInstance();
    String? id = preferen.getString('id');
    String url =
        '${Part.baseUrl}UngFood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$addrss&phone=$phone&UrlpicTure=$urlImage&Lat=$lat&Lng=$lng';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        mormailDiarlog(context, 'ລອງໄໝ່');
      }
    });
  }

  Set<Marker> myMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
          title: 'My Shop',
          snippet: 'lat = $lat , lng = $lng',
        ),
      )
    ].toSet();
  }

  Container showMap() {
    return Container(
      height: 300,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),
        markers: myMarker(),
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
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 37,
          ),
        ),
        Container(
          width: 250,
          child:
              file == null ? Image.asset('images/img.png') : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 37,
          ),
        ),
      ],
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      if (pickedFile != null) {
        setState(() {
          file = File(pickedFile.path); // Set the file to the picked image
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              onChanged: (value) => nameShop = value.trim(),
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
              onChanged: (value) => addrss = value.trim(),
              decoration: InputDecoration(
                labelText: 'ທີ່ຢູ່',
                prefixIcon: Icon(Icons.home_work),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250,
            child: TextField(
              onChanged: (value) => phone = value.trim(),
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
