import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../entities/order.dart';
import '../menu.dart';

class Tos extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Tos(this.parent) ;

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
  Order order;
  CustomMenuStatefulWidget parent;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(S.of(context).termAndCondition, style: TextStyle(fontSize: 16)),
            Text(S.of(context).tocA),
            Text(S.of(context).tocA1),
            Text(S.of(context).tocA1A),
            Text(S.of(context).tocA1B),
            Text(S.of(context).tocA2),
            Text(S.of(context).tocA2A),
            Text(S.of(context).tocA2B),
            Text(S.of(context).tocA2C),
            Text(S.of(context).tocA2D),
            Text(S.of(context).tocA2E),
            Text(S.of(context).tocB),
            Text(S.of(context).tocB1),
            Text(S.of(context).tocB2),
            Text(S.of(context).tocB3),
            Text(S.of(context).tocB4),
            Text(S.of(context).tocC),
            Text(S.of(context).tocC1),
            Text(S.of(context).tocC2),
            Text(S.of(context).tocC3),
            Text(S.of(context).tocC4),
            Text(S.of(context).tocD),
            Text(S.of(context).tocD1),
            Text(S.of(context).tocD2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    this.parent.onMenuClicked('installment');
                  },
                  child: Text(S.of(context).back),
                ),
                ElevatedButton(
                  onPressed: () {
                    this.parent.onMenuClicked('signature_pad');
                  },
                  child: Text(S.of(context).process),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}