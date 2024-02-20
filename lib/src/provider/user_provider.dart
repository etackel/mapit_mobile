import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  int? _age;

  String? get name => _name;
  String? get email => _email;
  int? get age => _age;

  void setUserDetails(String name, String email, int age) {
    _name = name;
    _email = email;
    _age = age;
    notifyListeners();
  }
}
