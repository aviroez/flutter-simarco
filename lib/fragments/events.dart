import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../entities/event.dart';
import '../rests/event_rest.dart';
import '../entities/apartment.dart';
import '../entities/event.dart';
import '../entities/user.dart';
import '../menu.dart';

class Events extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Events(this.parent) ;

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
  List<Event> _events = [];
  int _page = 1;
  String _limit = '10';
  ScrollController controller;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    controller = new ScrollController()..addListener(_scrollListener);

    _page = 1;
    _parseEvent(this.parent.apartment, this.parent.searchQuery.text);
    this.parent.searchQuery.addListener(() {
      _page = 1;
      _parseEvent(this.parent.apartment, this.parent.searchQuery.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _eventsWidget(context),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    if (_events.length <= 0 || index >= _events.length) return null;

    Event event = _events[index];
    return GestureDetector(
      onTap: (){
        this.parent.event = event;
        this.parent.onMenuClicked('event_detail');
      },
      onLongPress: () {
      },
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(event.name ?? '', style: TextStyle(fontSize: 18))
                  ),
                  Text(event.apartment != null ? event.apartment.name : ''),
                ],
              ),

              Text(event.address ?? ''),
              Text(event.description ?? ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(event.start_date != null ? S.of(context).fromDate(event.start_date) : '-'),
                  Text(event.end_date != null ? S.of(context).toDate(event.end_date) : '-'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventsWidget(BuildContext ctx) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _events != null ? _events.length : 0,
      itemBuilder: _getListItemTile,
    );
  }

  _parseEvent(Apartment apartment, String search){
    Map<String, String> query = new Map<String, String>();
    if (apartment != null) {
      query.putIfAbsent('apartment_id', () => apartment.id.toString());
    }
    query.putIfAbsent("order_by_desc[0]", () => "start_date");
    query.putIfAbsent("order_by_desc[1]", () => "end_date");
    query.putIfAbsent("with[]", () => "apartment");
    query.putIfAbsent("active", () => "1");
    if (search != null) query.putIfAbsent("search", () => search);
    EventRest().getEvents(query).then((value) {
      if (mounted){
        setState(() {
          _events = value;
        });
      }
    });
  }

  _scrollListener() {
    if (controller.position.extentAfter == 0) {
      setState(() {
        _parseEvent(this.parent.apartment, this.parent.searchQuery.text);
      });
    }
  }

}