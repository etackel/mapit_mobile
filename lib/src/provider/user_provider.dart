import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _photoURL;
  int? _age;

  // SharedPreferences keys
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _photoURLKey = 'photoURL';
  static const String _ageKey = 'age';

  String? get name => _name;
  String? get email => _email;
  String? get photoURL => _photoURL;
  int? get age => _age;

  // Constructor
  UserProvider() {
    // Load user details from SharedPreferences when the app starts
    _loadUserDetails();
  }

  // Method to set user details and save to SharedPreferences
  void setUserDetails(String name, String email, String photoURL, int age) async {
    _name = name;
    _email = email;
    _photoURL = photoURL;
    _age = age;
    notifyListeners();
    await _saveUserDetails();
  }

  // Method to save user details to SharedPreferences
  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, _name!);
    await prefs.setString(_emailKey, _email!);
    await prefs.setString(_photoURLKey, _photoURL!);
    await prefs.setInt(_ageKey, _age!);
  }

  // Method to load user details from SharedPreferences
  Future<void> _loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_nameKey);
    _email = prefs.getString(_emailKey);
    _photoURL = prefs.getString(_photoURLKey);
    _age = prefs.getInt(_ageKey);
    notifyListeners();
  }
}
