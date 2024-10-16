import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../generated/l10n.dart';
import '../menu.dart';
import '../entities/order.dart';

class Successes extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Successes(this.parent) ;

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
          children: <Widget>[
            Text(S.of(context).thanks, style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            Text(S.of(context).orderWillBeProcessed),
            SizedBox(height: 10),
            Center(
              child: SvgPicture.asset(
                'assets/images/ic_checked.svg',
                semanticsLabel: S.of(context).success,
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 10),
            Text(S.of(context).numberWillBeSentSoon),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    this.parent.onMenuClicked('home');
                  },
                  child: Text(S.of(context).back),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}