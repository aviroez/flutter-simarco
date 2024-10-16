import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simarco/generated/l10n.dart';
import '../rests/api.dart';
import '../rests/image_rest.dart';
import '../utils/image_picker_handler.dart';
import '../entities/order.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/user.dart';
import '../menu.dart';

class ScanDocuments extends StatelessWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;

  ScanDocuments(this.user, this.apartment, this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.user, this.apartment, this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;
  CustomStatefulWidget(this.user, this.apartment, this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.user, this.apartment, this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> with TickerProviderStateMixin, ImagePickerListener {
  final User user;
  Apartment apartment;
  ApartmentTower apartment_tower;
  Order order;
  CustomMenuStatefulWidget parent;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  File _image_ktp;
  File _image_npwp;
  String _ktp_url;
  String _npwp_url;
  bool loading = false;

  ImagePickerListener _listener;

  _CustomStatefulWidget(this.user, this.apartment, this.parent);

  @override
  void initState() {
    super.initState();
    order = this.parent.order;

    if (order.images != null){
      for(var image in order.images){
        if (image.pivot != null){
          if (image.pivot.code == 'ktp'){
            _ktp_url = Api().url + '/storage/' + image.url.replaceAll('public/', '');
          } else if (image.pivot.code == 'npwp'){
            _npwp_url = Api().url + '/storage/' + image.url.replaceAll('public/', '');
          }
        }
      }
    } else {

    }

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                imagePicker = new ImagePickerHandler(this, _controller, 0);
                imagePicker.init();
                imagePicker.showDialog(context);
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100,
                  minWidth: double.infinity,
                ),
                child: Card(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      _image_ktp != null ? Image.file(_image_ktp, height: 50) : (_ktp_url != null ? Image.network(_ktp_url, height: 50) : Icon(Icons.picture_in_picture_alt, size: 50)),
                      SizedBox(width: 5),
                      Text(S.of(context).captureOrScanId)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                imagePicker = new ImagePickerHandler(this, _controller, 1);
                imagePicker.init();
                imagePicker.showDialog(context);
              },
              child: Container(
                constraints: BoxConstraints(
                    minHeight: 100,
                    minWidth: double.infinity,
                ),
                child: Card(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      _image_npwp != null ? Image.file(_image_npwp, height: 50) : (_npwp_url != null ? Image.network(_npwp_url, height: 50) : Icon(Icons.credit_card, size: 50)),
                      SizedBox(width: 5),
                      Text(S.of(context).captureOrScanTax)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    this.parent.onMenuClicked('customer_identity');
                  },
                  child: Text(S.of(context).back),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!loading) this.parent.onMenuClicked('installment');
                  },
                  child: Text(S.of(context).process),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _imgFromCamera(int type) async {
    File image = (await ImagePicker().getImage(
        source: ImageSource.camera, imageQuality: 50
    )) as File;

    setState(() {
      if (type == 0) _image_ktp = image;
      else if (type == 1) _image_npwp = image;
    });
  }

  _imgFromGallery(int type) async {
    File image = (await ImagePicker().getImage(
        source: ImageSource.gallery, imageQuality: 50
    )) as File;

    setState(() {
      if (type == 0) _image_ktp = image;
      else if (type == 1) _image_npwp = image;
    });
  }

  @override
  userImage(File _image, int _respCode) {
    setState(() {
      if (_respCode == 0){ // ktp
        _image_ktp = _image;
        _uploadFile(order, _image_ktp, 'ktp');
      } else if (_respCode == 1){ // npwp
        _image_npwp = _image;
        _uploadFile(order, _image_npwp, 'npwp');
      }
    });
  }

  _uploadFile(Order order, File file, String code) {
    setState(() {
      loading = true;
    });
    Map<String, String> map = new Map();
    map.putIfAbsent('code[]', () => code);
    ImageRest().order(order.id, file, map, code).then((value) {
      setState(() {
        loading = false;
      });
    }).catchError((onError){
      setState(() {
        loading = false;
      });
    });
  }
}