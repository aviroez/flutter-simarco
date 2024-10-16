import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simarco/generated/l10n.dart';
import '../rests/api.dart';
import '../menu.dart';
import '../entities/apartment.dart';

class Home extends StatelessWidget {
  final CustomMenuStatefulWidget parent;

  Home(this.parent);

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  final CustomMenuStatefulWidget parent;
  CustomStatefulWidget(this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  CustomMenuStatefulWidget parent;
  List<Apartment> _apartments = [];
  List<Widget> _widgets = [];

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (parent.listApartment != null && parent.listApartment.length > 0){
      _apartments = parent.listApartment;
      initListView(context);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return _widgets[index];
                    },
                    itemCount: _widgets.length,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        this.parent.onMenuClicked('customer');
                      },
                      child: Container(
                        height: 200,
                        width: (MediaQuery.of(context).size.width / 2) - 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/customer_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          S.of(context).customer,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        this.parent.onMenuClicked('events');
                      },
                      child: Container(
                        height: 200,
                        width: (MediaQuery.of(context).size.width / 2) - 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/stunit_ng.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          S.of(context).events,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/progress_bg.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Text(
                        S.of(context).progress,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Roboto',
                          letterSpacing: 0.5,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  initListView(BuildContext context){
    if (_apartments != null){
      for(Apartment apartment in _apartments){
        String url;
        if (apartment.images != null && apartment.images.length > 0) {
          var image = apartment.images.last;
          if (image.url != null) {
            url = Api().url + '/storage/' + image.url.replaceAll('public/', '');
          }
        }
        if (mounted){
          setState(() {
            _widgets.add(GestureDetector(
              onTap: (){
                this.parent.apartment = apartment;
                this.parent.onMenuClicked('apartment_tower');
              },
              child:Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
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
}