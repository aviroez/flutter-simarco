import 'dart:async';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../generated/l10n.dart';
import '../entities/event.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class Maps extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Maps(this.parent) ;

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

class _CustomStatefulWidget extends State<CustomStatefulWidget> with WidgetsBindingObserver{
  User user;
  Apartment apartment;
  Event event;
  CustomMenuStatefulWidget parent;
  Position _my_location;
  Completer<GoogleMapController> _controller = Completer();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  static final CameraPosition _position = CameraPosition(
    target: LatLng(-7.7833447,110.4142924),
    zoom: 14,
  );

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _checkGps();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      _checkGps();
    } else if(state == AppLifecycleState.inactive){
      // app is inactive
    } else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: Container(),
    // );

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _position,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: _getMarkers()
      ),
    );
  }

  _getMarkers(){
    Set<Marker> listMarker = Set();
    if (this.parent.listApartment != null){
      for(Apartment apartment in this.parent.listApartment){
        listMarker.add(
            Marker(
              markerId: MarkerId(apartment.id.toString()),
              position: LatLng(apartment.latitude, apartment.longitude),
              infoWindow: InfoWindow(
                title: apartment.name,
                snippet: apartment.address,
              ),
              // icon: _markerIcon,
            )
        );
      }
    }

    return listMarker;
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).myLocationIsNotActive),
              content: Text(S.of(context).activateMyLocationNow),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).yes),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS'
                    );

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      _getCurrentLocation();
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _my_location = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}