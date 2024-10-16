import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:hand_signature/signature.dart';
import 'dart:ui' as ui;
import 'dart:convert';
import '../generated/l10n.dart';
import '../menu.dart';
import '../entities/order.dart';
import '../rests/order_rest.dart';

class SignaturePads extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  SignaturePads(this.parent) ;

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
  Order order;
  CustomMenuStatefulWidget parent;
  final _sign = GlobalKey<SignatureState>();
  bool loading = false;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    order = this.parent.order;
  }

  @override
  Widget build(BuildContext context) {
    final control = HandSignatureControl(
      threshold: 3.0,
      smoothRatio: 0.65,
      velocityRange: 2.0,
    );

    final widget = HandSignaturePainterView(
      control: control,
      color: Colors.black,
      width: 1.0,
      maxWidth: 10.0,
      type: SignatureDrawType.shape,
    );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(S.of(context).signature, style: TextStyle(fontSize: 16)),
          Divider(),
          Expanded(
              child: Signature(
                color: Colors.black,// Color of the drawing path
                strokeWidth: 5.0, // with
                backgroundPainter: null, // Additional custom painter to draw stuff like watermark
                onSign: () {
                  final sign = _sign.currentState;
                  _sign.currentState.getData().then((value) {
                  });
                }, // Callback called on user pan drawing
                key: _sign, // key that allow you to provide a GlobalKey that'll let you retrieve the image once user has signed
              ),
            // child: widget,
          ),
          Divider(),
          Text((order != null && order.name != null) ? order.name : ''),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      this.parent.onMenuClicked('tos');
                    },
                    child: Text(S.of(context).back),
                  ),
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: () {
                      final sign = _sign.currentState;
                      sign.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text(S.of(context).clear),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!loading){
                        setState(() {
                          loading = true;
                        });
                        final sign = _sign.currentState;
                        //retrieve image data, do whatever you want with it (send to server, save locally...)
                        final image = await sign.getData();
                        var data = await image.toByteData(format: ui.ImageByteFormat.png);
                        sign.clear();
                        final encoded = base64.encode(data.buffer.asUint8List());
                        Map<String, String> map = new Map();
                        map.putIfAbsent("signature", () => encoded);

                        OrderRest().process(order.id, map).then((value) {
                          if (value != null){
                            setState(() {
                              this.parent.order = value;
                              loading = false;
                            });

                            this.parent.onMenuClicked('success');
                          }
                        }).catchError((catchError){
                          setState(() {
                            loading = false;
                          });

                          var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    },
                    child: Text(S.of(context).process),
                  ),
                ],
              ),
              loading ? LinearProgressIndicator() : Container(),
            ],
          ),
        ],
      ),
    );
  }
}