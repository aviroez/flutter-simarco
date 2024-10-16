import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'entities/customer_lead.dart';
import 'entities/event.dart';
import 'entities/apartment_unit.dart';
import 'entities/apartment.dart';
import 'entities/customer.dart';
import 'entities/user.dart';
import 'entities/apartment_tower.dart';
import 'entities/order.dart';
import 'fragments/apartment_towers.dart';
import 'fragments/apartment_units.dart';
import 'fragments/apartments.dart';
import 'fragments/customer_details.dart';
import 'fragments/customers.dart';
import 'fragments/edit_password.dart';
import 'fragments/edit_profiles.dart';
import 'fragments/event_detail_adds.dart';
import 'fragments/event_details.dart';
import 'fragments/events.dart';
import 'fragments/order_details.dart';
import 'fragments/orders.dart';
import 'fragments/payment_schemas.dart';
import 'fragments/home.dart';
import 'fragments/profiles.dart';
import 'fragments/scan_documents.dart';
import 'fragments/calculators.dart';
import 'fragments/customer_identity.dart';
import 'fragments/customer_lead_adds.dart';
import 'fragments/customer_lead_edits.dart';
import 'fragments/event_adds.dart';
import 'fragments/installments.dart';
import 'fragments/maps.dart';
import 'fragments/signature_pads.dart';
import 'fragments/successes.dart';
import 'fragments/tos.dart';
import 'generated/l10n.dart';
import 'password.dart';
import 'rests/apartment_rest.dart';
import 'rests/user_rest.dart';
import 'constants.dart';
import 'login.dart';
import 'sessions.dart';

class Menu extends StatelessWidget {

  BuildContext context;
  final User user;

  Menu({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: Constants.appName,
      home: MenuStatefulWidget(user: user),
    );
  }
}


/// This is the stateful widget that the main application instantiates.
class MenuStatefulWidget extends StatefulWidget {
  final User user;
  MenuStatefulWidget({Key key, @required this.user}) : super(key: key);

  @override
  CustomMenuStatefulWidget createState() => CustomMenuStatefulWidget(this.user);
}

/// This is the private State class that goes with MyStatefulWidget.
class CustomMenuStatefulWidget extends State<MenuStatefulWidget> {
  List<User> listUser = [];
  List<Apartment> listApartment = [];
  UserRest userRest = UserRest();
  String _selectedMenu = 'home';
  String selectedTitle = 'Home';
  int selectedCustomerIndex = 0;
  User user;
  Apartment apartment;
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit;
  Customer customer;
  CustomerLead customer_lead;
  Event event;
  Order order;
  BuildContext context;
  bool event_detail_valid = true;
  bool _is_searching = true;
  bool is_search_view = false;
  bool loadingApartment = false;
  bool loadedApartment = false;
  final TextEditingController searchQuery = new TextEditingController();
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  Widget appBarTitle;

  CustomMenuStatefulWidget(this.user);

  _floatingActionButton() {
    if (_selectedMenu == 'home'){
      return FloatingActionButton.extended(
        onPressed: () {
          if (listApartment.length == 1) onMenuClicked('apartment_tower');
          else onMenuClicked('apartment');
        },
        label: Text(S.of(context).orderNow),
        backgroundColor: Colors.lightBlueAccent,
      );
    } else if (_selectedMenu == 'events'){
      return FloatingActionButton.extended(
        onPressed: () {
          onMenuClicked('event_add');
        },
        label: Text(S.of(context).eventAdd),
        backgroundColor: Colors.lightBlueAccent,
      );
    } else if (_selectedMenu == 'event_detail' && event_detail_valid == true){
      return FloatingActionButton.extended(
        onPressed: () {
          onMenuClicked('event_detail_add');
        },
        label: Text(S.of(context).eventAddActivity),
        backgroundColor: Colors.lightBlueAccent,
      );
    } else if (_selectedMenu == 'customer' && selectedCustomerIndex == 1){
      return FloatingActionButton(
        onPressed: () {
          onMenuClicked('customer_lead_add');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      );

    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    appBarTitle = new Text(selectedTitle ?? Constants.appName, style: new TextStyle(color: Colors.white),);
    Session.parseUser().then((user) {
      if (user != null){
        setState(() {
          this.user = user;
        });
      }
    });
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    if (!loadingApartment && (!loadedApartment || (listApartment == null || listApartment.length == 0))) initApartments();
    // if (!loadedApartment) initApartments();
    this.context = context;
    return WillPopScope(
        onWillPop: () async {
          return await _onBackPressed();
        },
        child: Scaffold(
          drawer: _customDrawer(),
          appBar: AppBar(
            title: is_search_view == true ? appBarTitle : Text(this.selectedTitle ?? Constants.appName),
            actions: <Widget>[
              is_search_view == true ? IconButton(icon: actionIcon, onPressed: () {
                setState(() {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon = new Icon(Icons.close, color: Colors.white,);
                    this.appBarTitle = new TextField(
                      controller: searchQuery,
                      style: new TextStyle(color: Colors.white,),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search, color: Colors.white),
                          hintText: S.of(context).search,
                          hintStyle: new TextStyle(color: Colors.white)
                      ),
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                }
                );
              },
              ) : Container(),

            ],
          ),
          body: Container(
            child: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.blueAccent,
                primaryColorDark: Colors.blue,
                accentColor: Colors.lightBlueAccent,
              ),
              child: fragmentView(),
            )
          ),
          floatingActionButton: _floatingActionButton(),
          floatingActionButtonLocation: ['home','events', 'event_detail'].contains(_selectedMenu) ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: _selectedMenu != 'customer' ? null : BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Customer',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt_1),
                label: 'Calon Customer',
              ),
            ],
            currentIndex: selectedCustomerIndex,
            selectedItemColor: Colors.lightBlueAccent,
            onTap: (index) {
              setState(() {
                selectedCustomerIndex = index;
              });
            },
          ),
        )
    );
  }

  Drawer _customDrawer(){
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/logo.png')
                  )
              ),
            ),
            accountName: new Container(
                child: Text(
                  user != null ? user.name : '-',
                  style: TextStyle(color: Colors.black),
                )
            ),
            accountEmail: new Container(
                child: Text(
                  user != null ? user.email : '-',
                  style: TextStyle(color: Colors.black),
                )
            ),
            decoration: BoxDecoration(
              color: Colors.blue
            ),
          ),
          ListTile(
            title: Text(S.of(context).home),
            leading: Icon(Icons.home),
            onTap: () {
              onMenuClicked('home');
              Navigator.pop(context);
            },
          ),
          listApartment != null && listApartment.length == 1 ? ListTile(
            title: Text(S.of(context).apartmentTower),
            leading: Icon(Icons.apartment_outlined),
            onTap: () {
              setState(() {
                apartment = listApartment[0];
              });
              onMenuClicked('apartment_tower');
              Navigator.pop(context);
            },
          ) : (listApartment != null && listApartment.length > 1 ? ListTile(
            title: Text(S.of(context).apartment),
            leading: Icon(Icons.apartment),
            onTap: () {
              onMenuClicked('apartment');
              Navigator.pop(context);
            },
          ) : Container()),
          ListTile(
            title: Text(S.of(context).orders),
            leading: Icon(Icons.reorder),
            onTap: () {
              onMenuClicked('order');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(S.of(context).customers),
            leading: Icon(Icons.people),
            onTap: () {
              onMenuClicked('customer');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(S.of(context).events),
            leading: Icon(Icons.event),
            onTap: () {
              onMenuClicked('events');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(S.of(context).map),
            leading: Icon(Icons.map_outlined),
            onTap: () {
              Navigator.pop(context);
              onMenuClicked('map');
            },
          ),
          ListTile(
            title: Text(S.of(context).calculatorLoan),
            leading: Icon(Icons.calculate),
            onTap: () {
              onMenuClicked('calculator');
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            title: Text(S.of(context).myProfile),
            leading: Icon(Icons.quick_contacts_dialer),
            onTap: () {
              onMenuClicked('profile');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(S.of(context).changePassword),
            leading: Icon(Icons.lock_open),
            onTap: () {
              onMenuClicked('edit_password');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(S.of(context).logout),
            leading: Icon(Icons.logout),
            onTap: () {
              _logoutAction(context);
            },
          ),
        ],
      ),
    );
  }

  _moveToLogin(BuildContext context) {
    Route route = MaterialPageRoute(builder: (context) => LoginRoute(null));
    // return Navigator.pushReplacement(context, route);
    return Navigator.of(context).pushAndRemoveUntil(route, (Route<dynamic> route) => false);;
  }

  void onMenuClicked(String code) {
    setState(() {
      _selectedMenu = code;
      BuildContext context = this.context;
      // selectedTitle = Constants.fragments[code];
      switch(code){
        case 'home': selectedTitle = S.of(context).home; break;
        case 'apartment': selectedTitle = S.of(context).apartment; break;
        case 'apartment_tower': selectedTitle = S.of(context).apartmentTower; break;
        case 'apartment_unit': selectedTitle = S.of(context).apartmentUnit; break;
        case 'payment_schema': selectedTitle = S.of(context).paymentSchema; break;
        case 'customer_identity': selectedTitle = S.of(context).customerIdentity; break;
        case 'scan_document': selectedTitle = S.of(context).scanDocument; break;
        case 'installment': selectedTitle = S.of(context).installment; break;
        case 'tos': selectedTitle = S.of(context).tos; break;
        case 'signature_pad': selectedTitle = S.of(context).signaturePad; break;
        case 'success': selectedTitle = S.of(context).success; break;
        case 'customer': selectedTitle = S.of(context).customer; break;
        case 'customer_lead_add': selectedTitle = S.of(context).customerLeadAdd; break;
        case 'customer_detail': selectedTitle = S.of(context).customerDetail; break;
        case 'order': selectedTitle = S.of(context).order; break;
        case 'order_detail': selectedTitle = S.of(context).orderDetail; break;
        case 'events': selectedTitle = S.of(context).events; break;
        case 'event_add': selectedTitle = S.of(context).eventAdd; break;
        case 'event_detail': selectedTitle = S.of(context).eventDetail; break;
        case 'event_detail_add': selectedTitle = S.of(context).eventDetailAdd; break;
        case 'customer_lead_edit': selectedTitle = S.of(context).customerLeadEdit; break;
        case 'map': selectedTitle = S.of(context).map; break;
        case 'calculator': selectedTitle = S.of(context).calculator; break;
        case 'profile': selectedTitle = S.of(context).profile; break;
        case 'edit_profile': selectedTitle = S.of(context).editProfile; break;
        case 'edit_password': selectedTitle = S.of(context).editPassword; break;
        case 'password': selectedTitle = S.of(context).password; break;
      }

      if (['order', 'customer', 'events'].contains(code)){
        is_search_view = true;
        appBarTitle = Text(selectedTitle ?? Constants.appName);
        searchQuery.clear();
      } else {
        switch(code){
          case 'customer_lead_edit':
            if (customer != null){
              selectedTitle = Constants.customer_edit;
            } else if (customer_lead != null){
              selectedTitle = Constants.customer_lead_edit;
            }
            ; break;
          case 'customer_detail':
            if (customer != null){
              selectedTitle = Constants.customer_detail;
            } else if (customer_lead != null){
              selectedTitle = Constants.customer_lead_detail;
            }
            ; break;
        }
        appBarTitle = Text(selectedTitle ?? Constants.appName);
        is_search_view = false;
        searchQuery.clear();
      }
    });
  }

  fragmentView() {
    switch (_selectedMenu){
      case 'home':
        setState(() {
          if (listApartment != null && listApartment.length > 1) apartment = null;
          order = null;
        });
        return Home(this);
      case 'apartment':
        setState(() {
          if (listApartment != null && listApartment.length > 1) apartment = null;
          order = null;
        });
        return Apartments(this);
      case 'apartment_tower':
        setState(() {
          apartment_tower = null;
          order = null;
        });
        return ApartmentTowers(this);
      case 'apartment_unit':
        setState(() {
          order = null;
        });
        return ApartmentUnits(this);
      case 'payment_schema':
        return PaymentSchemas(user, apartment, this);
      case 'customer_identity':
        return CustomerIdentites(user, apartment, this);
      case 'scan_document':
        return ScanDocuments(user, apartment, this);
      case 'installment':
        return Installments(this);
      case 'tos':
        return Tos(this);
      case 'signature_pad':
        return SignaturePads(this);
      case 'success':
        return Successes(this);
      case 'customer':
        setState(() {
          customer = null;
          customer_lead = null;
        });
        return Customers(user, apartment, this);
      case 'customer_lead_add':
        return CustomerLeadAdds(this);
      case 'customer_lead_edit':
        return CustomerLeadEdits(this);
      case 'customer_detail':
        return CustomerDetails(this);
      case 'order':
        setState(() {
          order = null;
        });
        return Orders(this);
      case 'order_detail':
        return OrderDetails(this);
      case 'events':
        setState(() {
          event = null;
        });
        return Events(this);
      case 'event_add':
        return EventAdds(this);
      case 'event_detail':
        return EventDetails(this);
      case 'event_detail_add':
        return EventDetailAdds(this);
      case 'map':
        return Maps(this);
      case 'calculator':
        return Calculators(this);
      case 'profile':
        return Profiles(this);
      case 'edit_profile':
        return EditProfiles(this);
      case 'edit_password':
        return EditPassswords(this);
      default:
        return Container();
    }
  }

  void _handleSearchStart() {
    setState(() {
      _is_searching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text(this.selectedTitle ?? Constants.appName, style: new TextStyle(color: Colors.white),);
      _is_searching = false;
      searchQuery.clear();
    });
  }

  void initApartments(){
    setState(() {
      loadingApartment = true;
    });
    Map<String, String> queryMap = new Map();
    queryMap.putIfAbsent('with', () => 'images');
    ApartmentRest().getApartments(queryMap).then((value) {
      if (mounted){
        setState(() {
          loadingApartment = false;
          loadedApartment = true;
          if (value.statusCode == 200) {
            listApartment = ApartmentRest().parseApartments(value.body);
            if (listApartment != null && listApartment.length == 1){
              apartment = listApartment.elementAt(0);
            }
          } else if (value.statusCode == 401) {
            final snackBar = SnackBar(content: Text(S.of(context).loginExpired));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            _logoutAction(context);
          }
        });
      }
    }).catchError((onError){
      setState(() {
        loadingApartment = false;
        loadedApartment = true;
      });
    });
  }

  Future<bool> _onBackPressed() async {
    switch (_selectedMenu){
      case 'home':
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop', true);
        break;
      case 'apartment':
        onMenuClicked('home');
        break;
      case 'apartment_tower':
        onMenuClicked('home');
        break;
      case 'apartment_unit':
        onMenuClicked('home');
        break;
      case 'payment_schema':
        onMenuClicked('apartment_unit');
        break;
      case 'customer_identity':
        onMenuClicked('payment_schema');
        break;
      case 'scan_document':
        onMenuClicked('customer_identity');
        break;
      case 'installment':
        onMenuClicked('scan_document');
        break;
      case 'tos':
        onMenuClicked('installment');
        break;
      case 'signature_pad':
        onMenuClicked('tos');
        break;
      case 'success':
        onMenuClicked('home');
        break;
      case 'customer':
        onMenuClicked('home');
        break;
      case 'customer_lead_add':
        onMenuClicked('customer');
        break;
      case 'customer_detail':
        onMenuClicked('customer');
        break;
      case 'order':
        onMenuClicked('home');
        break;
      case 'order_detail':
        onMenuClicked('order');
        break;
      case 'events':
        onMenuClicked('home');
        break;
      case 'event_add':
        onMenuClicked('events');
        break;
      case 'event_detail':
        onMenuClicked('events');
        break;
      case 'event_detail_add':
        onMenuClicked('event_detail');
        break;
      case 'customer_lead_edit':
        onMenuClicked('event_detail');
        break;
      case 'map':
        onMenuClicked('home');
        break;
      case 'calculator':
        onMenuClicked('home');
        break;
      case 'profile':
        onMenuClicked('home');
        break;
      case 'edit_profile':
        onMenuClicked('profile');
        break;
      case 'edit_password':
        onMenuClicked('profile');
        break;
      case 'password':
        onMenuClicked('login');
        break;
    }
    return Future<bool>.value(true);
  }

  void _logoutAction(BuildContext context) {
    Navigator.pop(context);
    Session.saveUser(null);
    _moveToLogin(context);
  }
}
