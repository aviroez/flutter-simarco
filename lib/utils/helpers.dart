import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart' as countries;

class Helpers{
  static double toDouble(dynamic number){
    if (number != null){
      if (number is String){
        return double.tryParse(number);
      } else if (number is int){
        return number+.0;
      } else if (number is num){
        return number+.0;
      }
    }
    return 0;
  }

  static double strToDouble(String number){
    if (number != null && number.length > 0){
      return double.tryParse(number);
    }
    return 0;
  }

  static int strToInt(String number, int defaultNumber){
    if (number != null && number.length > 0){
      return int.tryParse(number);
    }
    return defaultNumber;
  }

  static int toInt(number){
    if (number != null){
      if (number is String){
        return int.parse(number);
      } else {
        return number.toInt();
      }
    }
    return null;
  }

  static String toStr(number){
    if (number is double){
      return removeDecimalZeroFormat(number);
    } else {
      return number.toString();
    }
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static String currency(nominal){
    if (nominal != null){
      nominal = nominal.abs();
      var f = NumberFormat('#,###', 'id_ID');
      return f.format(nominal);
    }

    return '0';
  }

  static double currencyRemove(String nominal){
    if (nominal != null && nominal.length > 0){
      String val = nominal.replaceAll('.', '');
      return strToDouble(val);
    }
    return 0;
  }

  static String reformatDate(value){
    if (value != null){
      DateTime dateTime = DateTime.parse(value);
      return DateFormat('dd/MM/y').format(dateTime);

    }
    return null;
  }

  static bool isEmail(String em) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  static String removeLastCommaZero(double val){
    String string = val.toString();
    var lastString = string.substring(string.length - 2);
    if (lastString == '.0'){
      return string.substring(0, string.length - 2);
    }
    return string;
  }

  static String penyebut(value) {
    int nilai = value.round().abs();
    var huruf = ["", "satu", "dua", "tiga", "empat", "lima", "enam", "tujuh", "delapan", "sembilan", "sepuluh", "sebelas"];
    var temp = "";
    if (nilai < 12) {
      temp = " "+ huruf[nilai];
    } else if (nilai <20) {
      temp = penyebut(nilai - 10)+ " belas";
    } else if (nilai < 100) {
      temp = penyebut(nilai/10)+" puluh"+ penyebut(nilai % 10);
    } else if (nilai < 200) {
      temp = " seratus" + penyebut(nilai - 100);
    } else if (nilai < 1000) {
      temp = penyebut(nilai/100) + " ratus" + penyebut(nilai % 100);
    } else if (nilai < 2000) {
      temp = " seribu" + penyebut(nilai - 1000);
    } else if (nilai < 1000000) {
      temp = penyebut(nilai/1000) + " ribu" + penyebut(nilai % 1000);
    } else if (nilai < 1000000000) {
      temp = penyebut(nilai/1000000) + " juta" + penyebut(nilai % 1000000);
    } else if (nilai < 1000000000000) {
      temp = penyebut(nilai/1000000000) + " milyar" + penyebut(nilai % 1000000000);
    } else if (nilai < 1000000000000000) {
      temp = penyebut(nilai/1000000000000) + " trilyun" + penyebut(nilai % 1000000000000);
    }
    return temp.capitalizeFirstofEach;
  }

  Map<String, String> parseCountries(String phone){
    if (countries.countries != null && phone != null){
      for(Map<String, String> country in countries.countries){
        String dial_code = country['dial_code'];
        String plusPhone = '+$phone';
        if (phone.startsWith('0') && dial_code == '+62'){
          return country;
        } else if (phone.startsWith(dial_code) || plusPhone.startsWith(dial_code)){
          return country;
        }
      }
    }
    return null;
  }
}

extension CapExtension on String {
  String get inCaps => this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.split(" ").map((str) => str.inCaps).join(" ");
}
