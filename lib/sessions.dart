import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'entities/apartment.dart';
import 'entities/user.dart';
import 'entities/apartment_tower.dart';
import 'entities/apartment_unit.dart';

class Session{
  static saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(user);
    await prefs.setString("user", json);
  }

  static saveApartment(Apartment apartment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(apartment);
    await prefs.setString("apartment", json);
  }

  static saveApartments(List<Apartment> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(list);
    await prefs.setString("apartments", json);
  }

  static saveApartmentTower(ApartmentTower apartmentTower) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(apartmentTower);
    await prefs.setString("apartment_tower", json);
  }

  static saveApartmentUnit(ApartmentUnit apartmentUnit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(apartmentUnit);
    await prefs.setString("apartment_unit", json);
  }

  static saveSession(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
  }

  static Future<Map<String, dynamic>> getSession() async {
    Map<String, dynamic> map = new Map();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null) {
      if (prefs.containsKey('email')) {
        map['email'] = prefs.getString('email');
        // map.update('email', (value) => prefs.getString('email'));
      }
      if (prefs.containsKey('password')) {
        map['password'] = prefs.getString('password');
        // map.update('password', (value) => prefs.getString('password'));
      }
    }
    return map;
  }

  static Future<User> parseUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('user')) {
      String json = prefs.get('user');
      return new User.fromJson(json);
    }
    return null;
  }

  static Future<Apartment> getApartment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('apartment')) {
      String json = prefs.get('apartment');
      return new Apartment.fromJson(json);
    }
    return null;
  }

  static Future<ApartmentTower> getApartmentTower() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('apartment_tower')) {
      String json = prefs.get('apartment_tower');
      return new ApartmentTower.fromJson(json);
    }
    return null;
  }

  static Future<ApartmentUnit> getApartmentUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('apartment_unit')) {
      String json = prefs.get('apartment_unit');
      return new ApartmentUnit.fromJson(json);
    }
    return null;
  }
}