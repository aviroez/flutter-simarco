import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../entities/event.dart';
import '../entities/event_activity_log.dart';
import '../rests/api.dart';
import '../rests/event_activity_log_rest.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class EventDetails extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  EventDetails(this.parent) ;

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
  EventActivityLog eventActivityLog;
  CustomMenuStatefulWidget parent;
  List<EventActivityLog> _event_activity_logs = [];
  DateTime now;
  DateTime start_date;
  DateTime end_date;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    event = this.parent.event;

    now = DateTime.now();

    setState(() {
      this.parent.event_detail_valid = false;

      if (event != null && event.start_date != null && event.end_date != null){
        start_date = DateTime.parse('${event.start_date} 00:00:00');
        end_date = DateTime.parse('${event.end_date} 23:59:59');
        if (now.isAfter(start_date) && now.isBefore(end_date)){
          this.parent.event_detail_valid = true;
        }
      } else if (event != null && event.start_date != null){
        start_date = DateTime.parse('${event.start_date} 00:00:00');
        if (now.isAfter(start_date)){
          this.parent.event_detail_valid = true;
        }
      } else if (event != null && event.end_date != null){
        end_date = DateTime.parse('${event.end_date} 23:59:59');
        if (now.isBefore(end_date)){
          this.parent.event_detail_valid = true;
        }
      }
    });

    _parseEventDetail(this.parent.apartment, '');
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
    if (_event_activity_logs.length <= 0 || index >= _event_activity_logs.length) return null;

    EventActivityLog eventActivityLog = _event_activity_logs[index];
    String img_url;
    if (eventActivityLog.images != null){
      for(var image in eventActivityLog.images){
        if (image.url != null){
          img_url = Api().url + '/storage/' + image.url.replaceAll('public/', '');
        }
      }
    }
    return GestureDetector(
      onTap: (){
        // this.parent.event = event;
        // this.parent.onMenuClicked('event_detail');
      },
      onLongPress: () {
      },
      child: Card(
        margin: EdgeInsets.all(5.0),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(child: Text(eventActivityLog.event != null ? eventActivityLog.event.name : '')),
                  Text(eventActivityLog.created_at),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text(eventActivityLog.location ?? '${eventActivityLog.latitude}, ${eventActivityLog.longitude}')),
                  GestureDetector(
                    onTap: (){
                      if (img_url != null){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text(eventActivityLog.event.name),
                                content: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(img_url),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(eventActivityLog.created_at, style: TextStyle(color: Colors.white, fontSize: 9)),
                                      Expanded(child: Container()),
                                      (eventActivityLog.location != null) ? Text(eventActivityLog.location, style: TextStyle(color: Colors.white, fontSize: 9)) : Container(),
                                      (eventActivityLog.latitude != null && eventActivityLog.longitude != null) ? Text('${eventActivityLog.latitude}, ${eventActivityLog.longitude}', style: TextStyle(color: Colors.white, fontSize: 9)) : Container(),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      }
                    },
                    child: img_url != null ? Image.network(img_url, width: 75, fit: BoxFit.contain,) : Icon(Icons.image_not_supported_outlined, size: 75),
                  ),
                ],
              ),
              // Widget to display the list of project
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
      itemCount: _event_activity_logs != null ? _event_activity_logs.length : 0,
      itemBuilder: _getListItemTile,
    );
  }

  _parseEventDetail(Apartment apartment, String search){
    Map<String, String> query = new Map<String, String>();
    if (user != null) {
      query.putIfAbsent('marketing_id', () => user.id.toString());
    }
    query.putIfAbsent("order_by_desc", () => "created_at");
    if (eventActivityLog != null){
      if (eventActivityLog.event_id > 0){
        query.putIfAbsent("event_id", () => eventActivityLog.event_id.toString());

        if (eventActivityLog.apartment_id != null) {
          query.putIfAbsent("apartment_id", () => eventActivityLog.apartment_id.toString());
        }
      }
    } else if (event != null){
      query.putIfAbsent("event_id", () => event.id.toString());
      query.putIfAbsent("apartment_id", () => event.apartment_id.toString());
    }
    EventActivityLogRest().get(query).then((value) {
      if (mounted){
        setState(() {
          _event_activity_logs = value;
        });
      }
    });
  }

}