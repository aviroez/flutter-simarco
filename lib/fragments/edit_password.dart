import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../rests/user_rest.dart';
import '../entities/event.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class EditPassswords extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  EditPassswords(this.parent) ;

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
  final _formKey = GlobalKey<FormState>();

  TextEditingController textOldPassword = TextEditingController();
  TextEditingController textNewPassword = TextEditingController();
  TextEditingController textRetypePassword = TextEditingController();

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();

    user = this.parent.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(1),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textOldPassword,
                        initialValue: null,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).oldPassword,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).oldPasswordIsRequired;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textNewPassword,
                        initialValue: null,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).newPassword,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).newPasswordIsRequired;
                          if (value.isNotEmpty && textOldPassword.text == value) return S.of(context).oldNewPasswordShouldNotBeSame;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textRetypePassword,
                        initialValue: null,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).retypeNewPassword,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).retypeNewPasswordIsRequired;
                          else if (value.isNotEmpty && textNewPassword.text != value) return S.of(context).retypeNewPasswordShouldBeSame;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              this.parent.onMenuClicked('home');
                            },
                            child: Text(S.of(context).back),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()){
                                Map<String, String> map = new Map();
                                map.putIfAbsent("old_password", () => textOldPassword.text);
                                map.putIfAbsent("new_password", () => textNewPassword.text);

                                UserRest().password(map).then((value) {
                                  if (value != null){
                                    setState(() {
                                      this.parent.user = value;
                                    });

                                    this.parent.onMenuClicked('home');
                                  }
                                });
                              }
                            },
                            child: Text(S.of(context).process),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}