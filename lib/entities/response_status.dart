import 'dart:convert';

class ResponseStatus{
  int code;
  String message;

  ResponseStatus(this.code, this.message);

  factory ResponseStatus.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getResponseStatus(json);
    }
    return null;
  }

  static getResponseStatus(data){
    if (data != null && data['code'] != null){
      return ResponseStatus(
        data['code'],
        data['message'],
      );
    }
    return null;
  }

  factory ResponseStatus.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);

    return getResponseStatus(data);
  }

  Map toJson() => {
    'code': code,
    'message': message,
  };

}