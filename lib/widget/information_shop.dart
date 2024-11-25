import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/connectPHP.dart';
import 'package:tonyyyoyfood/model/user_model.dart';
import 'package:tonyyyoyfood/screen/add_info_shop.dart';
import 'package:tonyyyoyfood/screen/edit_infor_shop.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';

class InformationShop extends StatefulWidget {
  const InformationShop({super.key});

  @override
  State<InformationShop> createState() => _InformationShopState();
}

class _InformationShopState extends State<InformationShop> {
  UserModel? userModel;
  late GoogleMapController mapController;
  Set<Marker> _markers = {};

  Future<void> readDataUser() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? id = preferences.getString('id');
      if (id == null) return;

      String url =
          '${Part.baseUrl}UngFood/getUserWhereId.php?isAdd=true&id=$id';
      Response response = await Dio().get(url);

      var result = json.decode(response.data);
      if (result != null && result.isNotEmpty) {
        setState(() {
          userModel = UserModel.fromJson(result[0]);
        });
      } else {
        setState(() {
          userModel = null; // กรณีไม่มีข้อมูล
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: readDataUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (userModel == null ||
              (userModel?.nameShop?.isEmpty ?? true)) {
            return showNodata(context);
          } else {
            return Stack(
              children: <Widget>[
                showListInfoShop(),
                addAndEditButton(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget showListInfoShop() => Column(
        children: <Widget>[
          MyStyle().mySizebox(),
          MyStyle().showTitleH2('ລາຍລະອຽດຮ້ານ: ${userModel?.nameShop ?? ''}'),
          MyStyle().mySizebox(),
          showImage(),
          MyStyle().mySizebox(),
          Row(
            children: [
              MyStyle().showTitleH2('ທີ່ຢູ່ຮ້ານ: ${userModel?.address ?? ''}'),
            ],
          ),
          MyStyle().mySizebox(),
          showMap(),
        ],
      );

  Container showImage() {
    return Container(
      width: 200,
      height: 200,
      child: userModel?.urlPicture != null
          ? Image.network('${Part.baseUrl}${userModel!.urlPicture}')
          : Icon(Icons.image, size: 100, color: Colors.grey),
    );
  }

  Widget showMap() {
    double lat = double.tryParse(userModel?.lat ?? '0.0') ?? 0.0;
    double lng = double.tryParse(userModel?.lng ?? '0.0') ?? 0.0;

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 15);

    _markers.clear(); // Clear existing markers
    if (_markers.isEmpty) {
      _markers.add(Marker(
        markerId: const MarkerId('shop_location'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'ຮ້ານ ${userModel?.nameShop}',
          snippet: 'ທີ່ຢູ່: ${userModel?.address}',
        ),
      ));
    }

    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  Widget showNodata(BuildContext context) =>
      MyStyle().titleCenter(context, 'ຍັງບໍ່ມີຂໍ້ມູນ');

  Widget addAndEditButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: routeInfo,
      ),
    );
  }

  void routeInfo() {
    if (userModel == null) return;

    Widget widget = (userModel?.nameShop?.isEmpty ?? true)
        ? AddInfoShop()
        : EditInforShop();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    ).then((_) async {
      await readDataUser(); // รอให้โหลดข้อมูลเสร็จ
    });
  }
}
