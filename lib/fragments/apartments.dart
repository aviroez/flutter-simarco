import 'dart:io';

import 'package:flutter/material.dart';
import '../rests/api.dart';
import '../menu.dart';
import '../entities/apartment.dart';

class Apartments extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Apartments(this.parent);

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
  CustomMenuStatefulWidget parent;
  // List<Apartment> _apartments = [];
  List<Widget> _widgets = [];

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (parent.listApartment != null){
    }
    initListView(context);
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _widgets[index];
      },
      itemCount: _widgets.length,
    );
  }

  initListView(BuildContext context){
    if (parent.listApartment != null){
      for(Apartment apartment in parent.listApartment) {
        String url;
        if (apartment.images != null && apartment.images.length > 0) {
          var image = apartment.images.last;
          if (image.url != null) {
            url = Api().url + '/storage/' + image.url.replaceAll('public/', '');
          }
        }
        setState(() {
          _widgets.add(GestureDetector(
            onTap: () {
              this.parent.apartment = apartment;
              // Session.saveApartment(apartment);
              this.parent.onMenuClicked('apartment_tower');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              // width: 380,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: url != null ? NetworkImage(url) : AssetImage('assets/images/header_bg.jpg'),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(child: Text('')),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                      color: Colors.black26,
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            title: Text(
                              apartment.name ?? (apartment.full_name ?? '-'),
                              style: TextStyle(color: Colors.white70),
                            ),
                            subtitle: Text(
                              apartment.address ?? (apartment.description ?? ''),
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
      }
    }
  }

}