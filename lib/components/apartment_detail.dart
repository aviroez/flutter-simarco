import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../entities/apartment.dart';

class ApartmentDetail extends StatelessWidget{

  final Apartment apartment;

  ApartmentDetail({Key key, @required this.apartment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.name),
      ),
      body: Container(
        height: double.maxFinite,
        child: new Stack(
          //alignment:new Alignment(x, y)
          children: <Widget>[
            Text(apartment.name, style: TextStyle(fontSize: 18)),
            // Text(apartment.email, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

}