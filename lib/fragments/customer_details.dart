import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simarco/constants.dart';
import 'package:simarco/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../entities/apartment.dart';
import '../entities/customer.dart';
import '../entities/customer_lead.dart';
import '../entities/user.dart';
import '../menu.dart';

class CustomerDetails extends StatelessWidget {
  User user;
  CustomMenuStatefulWidget parent;
  Apartment apartment;

  CustomerDetails(this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  User user;
  CustomMenuStatefulWidget parent;
  Apartment apartment;
  CustomStatefulWidget(this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  User user;
  Apartment apartment;
  Customer customer;
  CustomerLead customer_lead;
  CustomMenuStatefulWidget parent;
  List<DataRow> _listDataRow = [];
  String handphone;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    user = this.parent.user;
    customer = this.parent.customer;
    customer_lead = this.parent.customer_lead;

    if (customer != null){
      if (customer.handphone != null) handphone = customer.handphone;
      else if (customer.phone_number != null) handphone = customer.phone_number;

      setState(() {
        this.parent.appBarTitle = Text(Constants.customer_detail ?? Constants.appName);
      });

    }
    if (customer_lead != null){
      if (customer_lead.handphone != null) handphone = customer_lead.handphone;
      else if (customer_lead.phone_number != null) handphone = customer_lead.phone_number;

      setState(() {
        this.parent.appBarTitle = Text(Constants.customer_lead_detail ?? Constants.appName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // child: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(width: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).fullNameLabel),
                              Text(customer != null ? (customer.name ?? '-') : (customer_lead != null ? (customer_lead.name ?? '-') : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(Icons.perm_device_info, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).phoneNumberOrLineLabel),
                              Text(customer != null ? '${(customer.handphone ?? '-')} / ${(customer.phone_number ?? '-')}' : (customer_lead != null ? '${(customer_lead.handphone ?? '-')} / ${(customer_lead.phone_number ?? '-')}' : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(Icons.email, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).emailLabel),
                              Text(customer != null ? (customer.email ?? '-') : (customer_lead != null ? (customer_lead.email ?? '-') : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).idLabel),
                              Text(customer != null ? (customer.nik ?? '-') : (customer_lead != null ? (customer_lead.nik ?? '-') : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).addressLabel),
                              Text(customer != null ? (customer.address ?? '-') : (customer_lead != null ? (customer_lead.address ?? '-') : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, size: 40),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).addressCorrespondentLabel),
                              Text(customer != null ? (customer.address_correspondent ?? '-') : (customer_lead != null ? (customer_lead.address_correspondent ?? '-') : '-')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            // OutlinedButton(
            //     onPressed: (){
            //       setState(() {
            //         this.parent.customer = null;
            //         this.parent.customer_lead = null;
            //       });
            //       this.parent.onMenuClicked('customer');
            //     },
            //     child: Text('Kembali')
            // ),
            Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(Icons.email),
                    label: Text(""),
                    onPressed: () {
                      if (handphone != null){
                        _sendSms(handphone, '');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.messenger_outline),
                    label: Text(""),
                    onPressed: () {
                      if (handphone != null){
                        _sendWhatsapp(handphone, '');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.call),
                    label: Text(""),
                    onPressed: () {
                      if (handphone != null){
                        _callPhone(handphone);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text(""),
                    onPressed: () {
                      setState(() {
                        this.parent.onMenuClicked('customer_lead_edit');
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 2.0, color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      // ),
    );
  }

  Future<bool> _sendSms(String phoneNumber, String message) async {
    if (message != null) message = '';
    if (phoneNumber != null){
      if (Platform.isAndroid) {
        var uri = 'sms:$phoneNumber?body=$message';
        if (await canLaunch(uri)) return await launch(uri);
      } else if (Platform.isIOS) {
        var uri = 'sms:$phoneNumber&body=$message';
        if (await canLaunch(uri)) return await launch(uri);
      }
    }

    return Future<bool>.value(false);
  }

  Future<bool> _sendWhatsapp(String phoneNumber, String message) async {
    if (message != null) message = '';
    if (phoneNumber != null){
      final link = WhatsAppUnilink(
        phoneNumber: phoneNumber,
        text: message,
      );
      // Convert the WhatsAppUnilink instance to a string.
      // Use either Dart's string interpolation or the toString() method.
      // The "launch" method is part of "url_launcher".
      await launch('$link');
    }

    return Future<bool>.value(false);
  }

  Future<bool> _callPhone(String phoneNumber) async {
    if (phoneNumber != null){
      await launch('tel:${phoneNumber}');
    }
    return Future<bool>.value(false);
  }
}