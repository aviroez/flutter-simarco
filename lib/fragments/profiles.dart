import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simarco/generated/l10n.dart';
import '../entities/event.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class Profiles extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Profiles(this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  CustomMenuStatefulWidget parent;
  CustomStatefulWidget(this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  User user;
  Apartment apartment;
  Event event;
  CustomMenuStatefulWidget parent;
  Picture _picture;
  Image _image;

  TextEditingController textNominal = TextEditingController();
  TextEditingController textTerm = TextEditingController();
  TextEditingController textPercent = TextEditingController();

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    user = this.parent.user;
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = Container();
    if (user.signature != null){
      if (user.signature.contains('<?xml')){
        widget = _parseSvg();
      } else {
        widget = _parseBase64();
      }
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                this.parent.onMenuClicked('edit_profile');
              },
              child: Text(S.of(context).profileEdit),
            ),
          ),
          Card(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(S.of(context).fullNameLabel),
                      Text(user != null ? user.name : '-'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('${S.of(context).aliasName}:'),
                      Text(user != null ? (user.alias??'-') : '-'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(S.of(context).emailLabel),
                      Text(user != null ? user.email : '-'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('${S.of(context).handphone}:'),
                      Text(user != null ? (user.handphone ?? user.phone_number) : '-'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('${S.of(context).position}:'),
                      Text('-'),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('${S.of(context).signature}:'),
                  user.signature != null ? widget : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _parseSvg() {
    final String rawSvg = user.signature;
    return SvgPicture.string(rawSvg, height: 200);
  }

  Widget _parseBase64() {
    Uint8List _bytesImage;
    _bytesImage = Base64Decoder().convert(user.signature);
    return Image.memory(_bytesImage, height: 200);
  }

}