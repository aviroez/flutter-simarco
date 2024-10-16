import 'package:flutter/material.dart';
import 'package:simarco/generated/l10n.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import '../entities/order.dart';
import '../rests/order_rest.dart';
import '../rests/apartment_floor_rest.dart';
import '../menu.dart';
import '../rests/apartment_unit_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_floor.dart';
import '../entities/apartment_unit.dart';
import '../entities/user.dart';

class ApartmentUnits extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  ApartmentUnits(this.parent);

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
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit_selected;
  Order order;
  CustomMenuStatefulWidget parent;
  List<ApartmentFloor> _apartment_floors = [];
  List<ApartmentUnit> _apartment_unit_numbers = [];
  List<DataColumn> _unitNumberList = [];
  List<DataRow> _rowList = [];
  List<String> titleColumn = [];
  List<String> titleRow = [];
  List<List<String>> data = [];
  Map<int, ButtonStyle> _buttonStyle = Map();
  Map<int, bool> _buttonPressed = Map();

  String _textUnitSelected;
  bool _dialogShown = false;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    apartment = this.parent.apartment;
    apartment_tower = this.parent.apartment_tower;

    _unitNumberList.add(DataColumn(label: Expanded(child: Text('-', textAlign: TextAlign.center))));
    _rowList.add(DataRow(cells: <DataCell>[DataCell(Text('-', textAlign: TextAlign.center))]));
    _getApartmentUnit(apartment, apartment_tower);
  }

  @override
  void didUpdateWidget(covariant CustomStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  List<List<String>> makeData(columns, rows) {
    final List<List<String>> output = [];
    for (int i = 0; i < columns; i++) {
      final List<String> row = [];
      for (int j = 0; j < rows; j++) {
        row.add('T$i : L$j');
      }
      output.add(row);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    if (_dialogShown == false) {
      if (mounted) {
        setState(() {
          _dialogShown = true;
        });
        _initLastOrder(context);
      }
    }

    final columns = 10;
    final rows = 20;

    data = makeData(columns, rows);

    /// Simple generator for column title
    titleColumn = List.generate(columns, (i) => 'Top $i');

    /// Simple generator for row title
    titleRow = List.generate(rows, (i) => 'Left $i');
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Text(S.of(context).floor),
            Divider(),
            Flexible(
              child: ListView(
                children: <Widget>[
                  // StickyHeadersTable(
                  //   columnsLength: titleColumn.length,
                  //   rowsLength: titleRow.length,
                  //   columnsTitleBuilder: (i) => Text(titleColumn[i]),
                  //   rowsTitleBuilder: (i) => Text(titleRow[i]),
                  //   contentCellBuilder: (i, j) => Text(data[i][j]),
                  //   legendCell: Text('Sticky Legend'),
                  // ),
                  // StickyHeadersTable(
                  //   columnsLength: titleColumn.length,
                  //   rowsLength: titleRow.length,
                  //   columnsTitleBuilder: (i) => Text(titleColumn[i]),
                  //   rowsTitleBuilder: (i) => Text(titleRow[i]),
                  //   contentCellBuilder: (i, j) => Text(data[i][j]),
                  //   legendCell: Text('Sticky Legend'),
                  // ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 0,
                      dividerThickness: 1,
                      columns: _unitNumberList,
                      rows: _rowList,
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Container(
              child: Text(_textUnitSelected ?? S.of(context).unitIsNotSelected),
            ),
            // Text('Legenda'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text(S.of(context).back),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (apartment_unit_selected != null){
                      setState(() {
                        this.parent.apartment_unit = apartment_unit_selected;
                      });
                      this.parent.onMenuClicked('payment_schema');
                    }
                  },
                  child: Text(S.of(context).process),
                ),
              ],
            ),
          ],
        ),
      );
  }

  void _getApartmentUnit(apartment, apartment_tower){
    Map<String, String> query = new Map<String, String>();
    if (apartment_tower != null) {
      query.putIfAbsent('apartment_tower_id', () => apartment_tower.id.toString());
    } else if (apartment != null) {
      query.putIfAbsent('apartment_id', () => apartment.id.toString());
    }
    ApartmentFloorRest().populate(query).then((value) {
      _apartment_floors = value;
      print('_apartment_floors');
    });
    ApartmentUnitRest().number(query).then((value) {
      if (value != null){
        _apartment_unit_numbers = value;

        _unitNumberList = [];
        titleColumn.add('Lt');
        _unitNumberList.add(DataColumn(label: Expanded(child: Text('Lt', textAlign: TextAlign.center))));
        for (var apartment_unit in _apartment_unit_numbers) {
          if (mounted){
            setState(() {
              _unitNumberList.add(DataColumn(label: Expanded(child: Text(apartment_unit.unit_number ?? (apartment_unit.desc ?? '-'), textAlign: TextAlign.center))));
              titleColumn.add(apartment_unit.unit_number ?? (apartment_unit.desc ?? '-'));
            });
          }
        }

        _populateUnits();
      }
    });
  }

  int _page = 0;
  _populateUnits(){
    if (order != null) return;
    if (_page == 0){
      _rowList = [];
    }
    _page++;
    Map<String, String> query = new Map<String, String>();
    query.putIfAbsent('page', () => _page.toString());
    query.putIfAbsent('order_by_desc[0]', () => 'sequence');
    query.putIfAbsent('order_by_desc[1]', () => 'number');
    if (apartment_tower != null){
      query.putIfAbsent('apartment_tower_id', () => apartment_tower.id.toString());
    } else if (apartment != null){
      query.putIfAbsent('apartment_id', () => apartment.id.toString());
    }

    ApartmentFloorRest().populate(query).then((value) {
      if (value != null){
        List<ApartmentFloor> listApartmentFloor = value;
          List<DataCell> listDataCell = [];
          List<String> dataRow = [];
          for (var floor in listApartmentFloor) {
            if (floor.apartment_units != null){
              listDataCell.add(DataCell(Text(floor.name ?? (floor.code ?? '-'), textAlign: TextAlign.center)));
              titleRow.add(floor.name ?? (floor.code ?? '-'));
              for (var u in _apartment_unit_numbers) {
                if (listDataCell.length <= _unitNumberList.length){
                  var _unit = _unitAvailable(u, floor);
                  if (_unit != null){
                    // ButtonStyle _buttonStyle = ButtonStyle(
                    //   backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    //         (Set<MaterialState> states) {
                    //       if (states.contains(MaterialState.pressed))
                    //         return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                    //       return null; // Use the component's default.
                    //     },
                    //   ),
                    // );
                    ButtonStyle _style = OutlinedButton.styleFrom(
                      primary: Colors.blueAccent,
                      backgroundColor: Colors.white,
                    );
                    if (['disabled','empty','hold','booked','sold','cancel'].contains(_unit.status)){
                      // _buttonStyle = ButtonStyle(
                      //   backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      //         (Set<MaterialState> states) {
                      //       if (states.contains(MaterialState.pressed))
                      //         return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                      //       if (states.contains(MaterialState.disabled))
                      //         return Theme.of(context).colorScheme.secondaryVariant.withOpacity(0.5);
                      //       return Theme.of(context).colorScheme.secondary.withOpacity(0.5);
                      //     },
                      //   ),
                      // );
                      _style = OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.black26,
                      );
                    }
                    if (mounted){
                      setState(() {
                        // _buttonStyle[_unit.id] = _style;
                        // _buttonStyle.insert(_unit.id, _style);
                        _buttonStyle.putIfAbsent(_unit.id, () => _style);
                        _buttonPressed[_unit.id] = false;
                      });
                    }
                    listDataCell.add(DataCell(
                         // ButtonTheme(
                         //   minWidth: 10,
                         //   padding: EdgeInsets.all(0),
                           // buttonColor: Colors.red,
                          OutlinedButton(
                            style: _buttonPressed[_unit.id] != null && !_buttonPressed[_unit.id] ? _style : OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                             // style: ['disabled','empty','hold','booked','sold','cancel'].contains(_unit.status) ? ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent)) : ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)),
                             onPressed: ['disabled','hold','booked','sold','cancel'].contains(_unit.status) ? null : () {
                               if (mounted) {
                                 setState(() {
                                   apartment_unit_selected = _unit;
                                   // Session.saveApartmentUnit(apartment_unit_selected);
                                   _textUnitSelected = 'Unit dipilih Lt: ${floor
                                       .name}  No: ${apartment_unit_selected
                                       .unit_number}';
                                   _buttonPressed[_unit.id] = true;
                                 });
                               }
                             },
                             child: Text(_unit.apartment_type_desc ?? (_unit.unit_number ?? (_unit.code ?? '-'))),
                           ),
                        // ),
                    )
                    );
                    dataRow.add(_unit.unit_number ?? (_unit.code ?? '-'));
                  } else {
                    listDataCell.add(DataCell(Text('-', textAlign: TextAlign.center)));
                    dataRow.add('-');
                  }
                }
              }
            }
          }

          int rowLength = dataRow.length;
          if (rowLength > 0){
            int unitLength = _unitNumberList.length;
            int cellLength = listDataCell.length;
            while(unitLength > cellLength){
              listDataCell.add(DataCell(Text('-', textAlign: TextAlign.center)));
              cellLength = listDataCell.length;
            }
            if (mounted){
              setState(() {
                _rowList.add(DataRow(
                  cells: listDataCell,
                ));
                data.add(dataRow);
              });
              _populateUnits();
            }
          }
      }
    });
  }

  ApartmentUnit _unitAvailable(ApartmentUnit unit, ApartmentFloor floor){
    if (floor.apartment_units != null){
      for (var u in floor.apartment_units) {
        if (u.unit_number != null && u.unit_number == unit.unit_number) {
          return u;
        }
      }
    }

    return null;
  }

  _initLastOrder(BuildContext context) {
    // if (apartment == null) return;
    this.parent.order = null;
    Map<String, String> map = new Map();
    map.putIfAbsent("apartment_id", () => apartment.id.toString());
    OrderRest().last(map).then((value) {
      if (value != null){
        if (mounted){
          setState(() {
            this.parent.order = value;
            _dialogShown = true;
          });

          if (this.parent.order != null){
            _showDialog(context);
          }
        }
      }
    });
  }

  _showDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).confirmation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(S.of(context).lastOrderIsNotCompleted),
              Text(S.of(context).continueOrder),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(S.of(context).delete),
              onPressed: () {
                setState(() {
                  _dialogShown = true;
                });
                if (this.parent.order != null){
                  OrderRest().delete(this.parent.order.id).then((value) {
                    setState(() {
                      this.parent.order = null;
                    });
                    // Navigator.of(context).pop();
                    Navigator.pop(context);
                  });
                }
              },
            ),
            FlatButton(
              child: Text(S.of(context).close),
              onPressed: () {
                setState(() {
                  _dialogShown = true;
                });
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(S.of(context).next),
              onPressed: () {
                setState(() {
                  _dialogShown = true;
                });
                Navigator.pop(context);
                this.parent.onMenuClicked('payment_schema');
              },
            ),
          ],
          // actionsOverflowButtonSpacing: 500,
        );
      },
    );
  }
}