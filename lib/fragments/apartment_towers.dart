import 'package:flutter/material.dart';
import '../rests/apartment_tower_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../menu.dart';
import '../sessions.dart';

class ApartmentTowers extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  ApartmentTowers(this.parent) ;

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
  Apartment apartment;
  ApartmentTower apartment_tower;
  CustomMenuStatefulWidget parent;
  List<ApartmentTower> _apartment_towers = [];

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    if (this.parent.apartment != null){
      _parseApartmentTower(this.parent.apartment);
    } else {
      Session.getApartment().then((apartment) {
        this.apartment = apartment;

        _parseApartmentTower(apartment);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _apartment_towersWidget(context),
    );
  }

  Future _getApartmentTowers() async {
    Map<String, String> query = new Map<String, String>();
    if (apartment != null) {
      query.putIfAbsent('apartment_id', () => apartment.id.toString());
    }
    return await ApartmentTowerRest().getApartmentTowers(query);
  }

  Widget _getListItemTile(BuildContext context, int index) {
    if (_apartment_towers.length <= 0 || index >= _apartment_towers.length) return null;
    Session.saveApartmentTower(null);
    ApartmentTower apartment_tower = _apartment_towers[index];
    return GestureDetector(
      onTap: (){
        setState(() {
          this.parent.apartment_tower = apartment_tower;
        });
        this.parent.onMenuClicked('apartment_unit');
      },
      onLongPress: () {
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(apartment_tower.name, style: TextStyle(fontSize: 18)),
            subtitle: Text(apartment_tower.address ?? (apartment_tower.description ?? ''), style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _apartment_towersWidget(BuildContext ctx) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _apartment_towers != null ? _apartment_towers.length : 0,
      itemBuilder: _getListItemTile,
    );
  }

  _parseApartmentTower(Apartment apartment){
    if (apartment != null){
      Map<String, String> query = new Map<String, String>();
      if (apartment != null) {
        query.putIfAbsent('apartment_id', () => apartment.id.toString());
      }
      ApartmentTowerRest().getApartmentTowers(query).then((value) {
        if (mounted){
          setState(() {
            _apartment_towers = value;
          });
        }
      });
    }
  }

}