import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../generated/l10n.dart';
import '../utils/helpers.dart';
import '../rests/user_rest.dart';
import '../entities/event.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class EditProfiles extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  EditProfiles(this.parent) ;

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
  double _loanTerm;
  double _result;
  bool _show_signature = false;
  final _sign = GlobalKey<SignatureState>();
  final _formKey = GlobalKey<FormState>();

  TextEditingController textFullName = TextEditingController();
  TextEditingController textAlias = TextEditingController();
  TextEditingController textHandphone = TextEditingController();
  TextEditingController textEmail = TextEditingController();

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    user = this.parent.user;

    if (user != null){
      textFullName.text = user.name;
      textAlias.text = user.alias;
      textHandphone.text = user.handphone;
      textEmail.text = user.email;
    }
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
    } else {
      _show_signature = true;
    }
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(1),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textFullName,
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: S.of(context).fullName,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).fullNameIsRequired;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textAlias,
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: S.of(context).aliasName,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textHandphone,
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: S.of(context).handphone,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).handphoneIsRequired;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textEmail,
                        initialValue: null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).emailIsRequired;
                          else if (value.isNotEmpty && !Helpers.isEmail(value)) return S.of(context).emailIsInvalid;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Divider(),
                      !_show_signature ? Container(
                        child: GestureDetector(
                          onTap: (){
                            showCustomDialog(context);
                          },
                          child: widget,
                        ),
                      ) : Container(),
                      _show_signature ?
                      Container(
                        height: 200,
                        child: Signature(
                          color: Colors.black,// Color of the drawing path
                          strokeWidth: 5.0, // with
                          backgroundPainter: null, // Additional custom painter to draw stuff like watermark
                          onSign: () {

                          }, // Callback called on user pan drawing
                          key: _sign, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
                        ),
                      ) : Container(),
                      Center(child: Text(S.of(context).signature)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              this.parent.onMenuClicked('profile');
                            },
                            child: Text(S.of(context).back),
                          ),
                          Expanded(child: Container()),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _show_signature = true;
                              });

                              if (_sign != null){
                                final sign = _sign.currentState;
                                if (sign != null) sign.clear();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                            ),
                            child: Text(S.of(context).clear),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()){
                                final sign = _sign.currentState;
                                final image = await sign.getData();
                                var data = await image.toByteData(format: ui.ImageByteFormat.png);
                                sign.clear();
                                final encoded = base64.encode(data.buffer.asUint8List());
                                Map<String, String> map = new Map();
                                map.putIfAbsent("signature", () => encoded);

                                UserRest().update(user.id, map).then((value) {
                                  if (value != null){
                                    setState(() {
                                      this.parent.user = value;
                                    });

                                    this.parent.onMenuClicked('profile');
                                  }
                                });
                              }
                            },
                            child: Text(S.of(context).process),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showCustomDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(S.of(context).signatureIsAlreadyExist),
          content: Text(S.of(context).cleanSignature),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).no),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            FlatButton(
              child: Text(S.of(context).yes),
              onPressed: () {
                setState(() {
                  _show_signature = true;
                });
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
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