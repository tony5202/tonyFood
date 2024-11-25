import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tonyyyoyfood/connectPHP.dart';
import 'package:tonyyyoyfood/model/user_model.dart';
import 'package:tonyyyoyfood/urinity/my_styr.dart';
import 'package:tonyyyoyfood/urinity/normail_diarlog.dart';

class EditInforShop extends StatefulWidget {
  const EditInforShop({super.key});

  @override
  State<EditInforShop> createState() => _EditInforShopState();
}

class _EditInforShopState extends State<EditInforShop> {
  UserModel? userModel;
  String? nameShop, address, phone, urlPicture;
  Location location = Location();
  double? lat, lng;
  File? file;

  @override
  void initState() {
    super.initState();
    fetchCurrentInfo();
    location.onLocationChanged.listen((event) {
      setState(() {
        lat = event.latitude;
        lng = event.longitude;
      });
    });
  }

  Future<void> fetchCurrentInfo() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? idShop = preferences.getString('id');
      String url =
          '${Part.baseUrl}UngFood/getUserWhereId.php?isAdd=true&id=$idShop';

      Response response = await Dio().get(url);
      var result = json.decode(response.data);

      if (result != null && result is List && result.isNotEmpty) {
        setState(() {
          userModel = UserModel.fromJson(result[0]);
          nameShop = userModel?.nameShop ?? '';
          address = userModel?.address ?? '';
          phone = userModel?.phone ?? '';
          urlPicture = userModel?.urlPicture ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Information'),
      ),
      body: userModel == null
          ? Center(child: MyStyle().showProgress())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildTextField(
                      label: 'Shop Name',
                      value: nameShop,
                      onChanged: (value) => nameShop = value,
                    ),
                    MyStyle().mySizebox(),
                    buildImagePicker(),
                    MyStyle().mySizebox(),
                    buildTextField(
                      label: 'Address',
                      value: address,
                      onChanged: (value) => address = value,
                    ),
                    MyStyle().mySizebox(),
                    buildTextField(
                      label: 'Phone',
                      value: phone,
                      onChanged: (value) => phone = value,
                    ),
                    MyStyle().mySizebox(),
                    lat == null ? MyStyle().showProgress() : buildMap(),
                    MyStyle().mySizebox(),
                    buildEditButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () => confirmDialog(),
        child: const Text('Edit'),
      ),
    );
  }

  Future<void> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Edit'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              editThread();
            },
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> editThread() async {
    if (file == null) {
      // Show a dialog if no image is selected
      mormailDiarlog(context, 'Please select an image before editing.');
      return;
    }

    try {
      Random random = Random();
      int i = random.nextInt(100000);
      String namefile = 'editshop$i.jpg';

      // Upload image
      Map<String, dynamic> map = {
        'file': await MultipartFile.fromFile(file!.path, filename: namefile)
      };
      FormData formdata = FormData.fromMap(map);
      String urlUpload = '${Part.baseUrl}UngFood/saveShop.php';
      await Dio().post(urlUpload, data: formdata).then((value) async {
        urlPicture = '/UngFood/shop/$namefile';

        // Update shop details
        String? id = userModel?.id;
        if (id == null ||
            nameShop == null ||
            address == null ||
            phone == null) {
          mormailDiarlog(context, 'Please fill in all required fields.');
          return;
        }

        String url =
            '${Part.baseUrl}UngFood/editUserWhereId.php?isAdd=true&id=$id&NameShop=$nameShop&Address=$address&phone=$phone&UrlpicTure=$urlPicture&Lat=$lat&Lng=$lng';

        Response response = await Dio().get(url);
        if (response.toString() == 'true') {
          Navigator.pop(context); // Close the screen on success
        } else {
          mormailDiarlog(context, 'Update Failed');
        }
      });
    } catch (e) {
      debugPrint('Error updating shop info: $e');
      mormailDiarlog(context, 'An error occurred: $e');
    }
  }

  Widget buildMap() {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat ?? 0.0, lng ?? 0.0),
          zoom: 17,
        ),
        mapType: MapType.normal,
        markers: {
          if (lat != null && lng != null)
            Marker(
              markerId: const MarkerId('shopLocation'),
              position: LatLng(lat!, lng!),
              infoWindow: InfoWindow(
                title: 'Shop Location',
                snippet: 'Lat: $lat, Lng: $lng',
              ),
            ),
        },
      ),
    );
  }

  Widget buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.add_a_photo),
          onPressed: () => chooseImage(ImageSource.camera),
        ),
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: file == null
              ? (urlPicture != null
                  ? Image.network('${Part.baseUrl}$urlPicture',
                      fit: BoxFit.cover)
                  : const Center(child: Text('No Image')))
              : Image.file(file!, fit: BoxFit.cover),
        ),
        IconButton(
          icon: const Icon(Icons.add_photo_alternate),
          onPressed: () => chooseImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Future<void> chooseImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: source, maxWidth: 800, maxHeight: 800);

      if (pickedFile != null) {
        setState(() {
          file = File(pickedFile.path);
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Widget buildTextField({
    required String label,
    required String? value,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
