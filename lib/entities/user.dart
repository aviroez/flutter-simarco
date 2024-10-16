import 'dart:convert';

class User{
  int id;
  String name;
  String email;
  String alias;
  String gender;
  String password;
  String ktp;
  String sim;
  String npwp;
  String address;
  String phone_number;
  String fax;
  String handphone;
  String user_position_id;
  String remember_token;
  String api_token;
  String signature;
  String reset_token;
  String status;

  User(this.id, this.name, this.email, this.alias, this.gender, this.ktp, this.sim, this.npwp,
      this.address, this.phone_number, this.fax, this.handphone, this.user_position_id,
      this.remember_token, this.api_token, this.signature, this.reset_token, this.status);

  static getUser(Map<String, dynamic> data){
    return User(
      (data['id'] is int) ? data['id'] : int.parse(data['id']),
      data['name'],
      data['email'],
      data['alias'],
      data['gender'],
      data['ktp'],
      data['sim'],
      data['npwp'],
      data['address'],
      data['phone_number'],
      data['fax'],
      data['handphone'],
      data['user_position_id'],
      data['remember_token'],
      data['api_token'],
      data['signature'],
      data['reset_token'],
      data['status'],
    );
  }

  factory User.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getUser(json);
    }
    return null;
  }

  factory User.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getUser(data);
    }

    return null;
  }

  factory User.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getUser(userData);
    }

    return User.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'alias': alias,
    'gender': gender,
    'ktp': ktp,
    'sim': sim,
    'npwp': npwp,
    'address': address,
    'phone_number': phone_number,
    'fax': fax,
    'handphone': handphone,
    'user_position_id': user_position_id,
    'remember_token': remember_token,
    'api_token': api_token,
    'signature': signature,
    'reset_token': reset_token,
    'status': status,
  };

}